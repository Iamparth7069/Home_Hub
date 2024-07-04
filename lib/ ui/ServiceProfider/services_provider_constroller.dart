import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_hub/firebase%20services/repo.dart';

import '../../Response Model/service_res_model.dart';

class ServiceProviderController extends GetxController{
  String serviceName;
  bool isSearch = false;


  ServiceProviderController(this.serviceName);

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loadServices();
  }
  TextEditingController search = TextEditingController();

  List<ServiceResponseModel> services = [];
  List<ServiceResponseModel> searchServices = [];
  Future<void> loadServices() async {
    print("Service $serviceName");
    servicesCollection
        .where("category_name", isEqualTo: serviceName)
        .snapshots()
        .listen((QuerySnapshot querySnapshot) {
      services.clear(); // Clear the existing list before updating with new data
      querySnapshot.docs.forEach((doc) {
        ServiceResponseModel service =
        ServiceResponseModel.fromMap(doc.data() as Map<String, dynamic>);
        services.add(service);
      });
      update(); // You may need to replace this with appropriate logic for updating your UI
    });
  }
  void setSearchValue({required bool value}) {
    isSearch = value;
    update();
  }



  void getSearchServices({required String searchValue}){
    searchServices.clear();
    services.forEach((element){
      if (element.serviceName!.toLowerCase()
          .contains(searchValue.toLowerCase())) {
        searchServices.add(element);
      }
    });
    update();
  }


}