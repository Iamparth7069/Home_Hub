import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:home_hub/Response%20Model/service_provider_res_model.dart';
import 'package:home_hub/Response%20Model/user_res_model.dart';
import 'package:home_hub/firebase%20services/notification_service.dart';
import 'package:home_hub/firebase%20services/repo.dart';
import 'package:home_hub/utils/local_storage.dart';

class ChatService {
  static Future<void> createRoom({required String secondUserId}) async {
    try {
      String myId = await LocalStorage.getUserId();
      await chatRoomCollection.doc("${myId}-${secondUserId}").set({
        "firstUid": myId,
        "secondUid": secondUserId,
        "LastChatTime": DateTime.now(),
        "LastChat": "",
        "lastMsgType": "text",
        "roomId": "$myId-${secondUserId}",
      });
    } catch (e) {
      print("${e.toString()}");
    }
  }

  static Future<Map> isChatRoomExist(String id1, String id2) async {
    var room1 = await chatRoomCollection.doc("$id1-$id2").get();
    var room2 = await chatRoomCollection.doc("$id2-$id1").get();

    bool isExist = false;
    String currectRoomId = "";
    if (room1.exists) {
      currectRoomId = "$id1-$id2";
      isExist = true;
    }
    if (room2.exists) {
      currectRoomId = "$id2-$id1";
      isExist = true;
    }
    return {"isExist": isExist, "chatRoomId": currectRoomId};
  }

  static Future<bool> isMyChat({required String userId}) async {
    String myId = await LocalStorage.getUserId();

    if (userId == myId) {
      return true;
    } else {
      return false;
    }
  }

  static Future sendChat(
      {required String msgType,
      required String msg,
      required String roomId}) async {
    String myId = await LocalStorage.getUserId();
    DateTime dateTime = DateTime.now();
    await chatRoomCollection.doc(roomId).collection("messages").doc().set({
      "createdAt": dateTime,
      "msg": msg,
      "msgType": msgType,
      "sendBy": myId,
    });
    await chatRoomCollection.doc(roomId).update(
        {"LastChatTime": dateTime, "LastChat": msg, "lastMsgType": "text"});
  }

  static Future sendNotification(
      {required String msType,
      required ServiceProviderRes serviceProviderRes,
      String? msg}) async {
    UserResModel userResModel = await LocalStorage.getUserData();
    NotificationService.sendMessage(
        receiverFcmToken: serviceProviderRes.fcmToken,
        title: "${userResModel.firstName} ${userResModel.lastName}",
        msg: msg);
  }
}
