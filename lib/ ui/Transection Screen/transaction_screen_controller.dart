import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:home_hub/Response%20Model/service_provider_res_model.dart';
import 'package:home_hub/Response%20Model/transectionResModel.dart';
import 'package:home_hub/firebase%20services/repo.dart';
import 'package:home_hub/utils/local_storage.dart';

class TransactionScreenController extends GetxController {
  List<TransectionResModel> allData = [];
  List<TransectionResModel> myData = [];
  List<ServiceProviderRes?> userData = [];
  bool isLoading = false;
  @override
  onInit() {
    super.onInit();
    getAllData();
  }

  Future<void> getAllData() async {
    isLoading = true;
    update();
    Stream<QuerySnapshot> querySnapshot = transectionCollection.snapshots();
    String myUid = await LocalStorage.getUserId();
    querySnapshot.listen((event) {
      allData.clear();
      myData.clear();
      userData.clear();
      event.docs.forEach((element) async {
        TransectionResModel transectionResModel =
            TransectionResModel.fromMap(element.data() as Map<String, dynamic>);
        if (transectionResModel.from == myUid) {
          myData.add(transectionResModel);

          await getServiceProviderData(id: transectionResModel.to).then(
            (value) {
              userData.add(value);
            },
          );
        } else if (transectionResModel.to == myUid) {
          myData.add(transectionResModel);
          userData.add(ServiceProviderRes(
              fname: "",
              clicks: 0,
              lname: "",
              Images: "",
              email: "",
              contectnumber: "",
              contectNumber2: "",
              address: ""));
        }
        isLoading = false;
        update();
      });
    });
  }

  Future<ServiceProviderRes> getServiceProviderData(
      {required String id}) async {
    DocumentSnapshot dd = await serviceProviderUserCollection.doc(id).get();
    ServiceProviderRes serviceProviderRes =
        ServiceProviderRes.formMap(dd.data() as Map<String, dynamic>);
    return serviceProviderRes;
  }
}
