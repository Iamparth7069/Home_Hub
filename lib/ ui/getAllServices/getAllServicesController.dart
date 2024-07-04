import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../Response Model/service_res_model.dart';
import '../../firebase services/repo.dart';

class GetAllServicesController extends GetxController{
  List<ServiceResponseModel> servicesData = [];
  List<ServiceResponseModel> filterData = [];
  bool isLoading = false;
  bool isSearch = false;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getAllservices();
  }

  Future<void> getAllservices() async {
    isLoading =true;
      CollectionReference collectionReference = FirebaseFirestore.instance.collection("Services-Provider(Provider)");
      collectionReference.where("serviceStatus",isEqualTo: "available").snapshots().listen((QuerySnapshot<Object?> event) {
        servicesData.clear();
        event.docs.forEach((doc) {
          if (doc.data() != null) {
            servicesData.add(ServiceResponseModel.fromMap(doc.data()! as Map<String, dynamic>));
          }
        });
        isLoading = false;
        update();
      });

      QuerySnapshot<Map<String, dynamic>>? initialSnapshot =  (await servicesCollection.get())as QuerySnapshot<Map<String, dynamic>>?;
      servicesData.clear();
      initialSnapshot!.docs.forEach((doc) {
        servicesData.add(ServiceResponseModel.fromMap(doc.data()));
      });
      isLoading = false;
      update();
  }

  void getSearchMesseges({required String searchValue}) {
    filterData.clear();

    servicesData.forEach((element) {
      if (element.userName!.toLowerCase()
          .contains(searchValue.toLowerCase()) || element.serviceName.toLowerCase().contains(searchValue.toLowerCase())) {
        print(element.categoryName);
        print("Call");
        filterData.add(element);
      }
    });
    update();
  }

  void setSearchValue({required bool value}) {
    isSearch = value;
    update();
  }

}