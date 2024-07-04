

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../Response Model/service_res_model.dart';
import '../../firebase services/repo.dart';
import '../../utils/local_storage.dart';

class SavedListController extends GetxController{
  RxList<ServiceResponseModel> documents = <ServiceResponseModel>[].obs;
  RxBool isLoading = false.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loadSavedItem();


  }

  StreamSubscription<QuerySnapshot>? _subscription;

  Future<void> loadSavedItem() async {
    isLoading.value = true;
    String uid = await LocalStorage.getUserId();
    try {
      CollectionReference servicesCollection =
      firestore.collection("Services-Provider(Provider)");

      _subscription = servicesCollection
          .where("savedBy", arrayContains: uid)
          .snapshots()
          .listen((querySnapshot) {
        documents.value = querySnapshot.docs.map((doc) {
          return ServiceResponseModel.fromMap(doc.data() as Map<String, dynamic>);
        }).toList();

        print("Document values ${documents.length}");
      });
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      print(e.toString());
    }
  }
}