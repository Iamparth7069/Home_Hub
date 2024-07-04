import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../models/services.dart';

class ServiceManageController extends GetxController{

  RxString DataFiring = "".obs;
  var isLoading = true.obs;
  var hasError = false.obs;
  bool isSearch = false;
  List<Services> allServices = [];
  List<Services> searchServices = [];
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getAllServices();
  }
  TextEditingController search = TextEditingController();



  void getAllServices(){
    CollectionReference serviceCollection = FirebaseFirestore.instance.collection("servicesInfo");
    Stream<QuerySnapshot> data = serviceCollection.orderBy("createdAt", descending: true).snapshots();
    data.listen((event) {
      allServices.clear();
      event.docs.forEach((element) {
        Services serviceResModel = Services.fromJson(element.data() as Map<String, dynamic>);
        allServices.add(serviceResModel);
      });
      update();

    });
  }

  Future<void> getSearchServices({required String searchValue}) async {
    searchServices.clear();
    allServices.forEach((element) {
      if (element.servicesName!.toLowerCase()
          .contains(searchValue.toLowerCase())) {
        searchServices.add(element);
      }
    });
    update();
  }

  void setSearchValue({required bool value}) {
    isSearch = value;
    update();
  }

}