import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:home_hub/Response%20Model/chat_room_res_model.dart';
import 'package:home_hub/Response%20Model/service_provider_res_model.dart';
import 'package:home_hub/firebase%20services/repo.dart';
import 'package:home_hub/utils/local_storage.dart';

class ChatScreenController extends GetxController {
  bool isSearch = false;

  @override
  void onInit() {
    super.onInit();
    getAllRoomData();
  }

  List<ChatRoomResModel> chatRoom = [];
  List<ServiceProviderRes> chatRoomUserData = [];
  List<ChatRoomResModel> searchedChatRoom = [];
  List<ServiceProviderRes> searchedChatRoomUserData = [];
  void setSerchedValue({required bool value}) {
    isSearch = value;
    update();
  }

  Future<void> getAllRoomData() async {
    String myUid = await LocalStorage.getUserId();
    Stream<QuerySnapshot> chatRoomData = chatRoomCollection
        .where("firstUid", isEqualTo: myUid)
        .orderBy("LastChatTime", descending: true)
        .snapshots();
    chatRoom.clear();
    chatRoomUserData.clear();
    chatRoomData.listen((event) async {
      chatRoom.clear();
      chatRoomUserData.clear();
      for (var element in event.docs) {
        ChatRoomResModel chatRoomResModel =
            ChatRoomResModel.fromJson(element.data() as Map<String, dynamic>);
        chatRoom.add(chatRoomResModel);
        ServiceProviderRes serviceProviderRes =
            await getServiceProviderData(userId: chatRoomResModel.secondUid);
        chatRoomUserData.add(serviceProviderRes);
      }
      update();
    });
  }

  static Future<ServiceProviderRes> getServiceProviderData(
      {required String userId}) async {
    DocumentSnapshot userData =
        await serviceProviderUserCollection.doc(userId).get();
    ServiceProviderRes serviceProviderRes =
        ServiceProviderRes.formMap(userData.data() as Map<String, dynamic>);
    return serviceProviderRes;
  }

  void getSearchedData({required String value}) {
    searchedChatRoom.clear();
    searchedChatRoomUserData.clear();
    for (int i = 0; i < chatRoomUserData.length; i++) {
      if (chatRoomUserData[i].fname.toLowerCase().contains(value) ||
          chatRoomUserData[i].lname.toLowerCase().contains(value)) {
        searchedChatRoom.add(chatRoom[i]);
        searchedChatRoomUserData.add(chatRoomUserData[i]);
      }
    }
  }
}
