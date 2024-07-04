import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:home_hub/Response%20Model/service_res_model.dart';
import 'package:home_hub/Response%20Model/user_res_model.dart';
import 'package:home_hub/firebase%20services/load_service.dart';
import 'package:home_hub/firebase%20services/repo.dart';
import 'package:home_hub/models/offer_res_model.dart';
import 'package:home_hub/models/services.dart';

import 'package:home_hub/utils/extension.dart';
import 'package:home_hub/utils/local_storage.dart';

class HomeScreenController extends GetxController {
  TextEditingController searchController = TextEditingController();
  LocalStorage storage = LocalStorage();
  RxString uid = ''.obs;
  bool userLoadData = false;
  getUid() async {
    uid.value = await LocalStorage.getUserId();
    print(uid);
  }

  int popularServicesIndex = 0;
  bool isServicesLoading = false;
  Rx<UserResModel> userData = UserResModel(
          firstName: "",
          lastName: "",
          phoneNumber: "",
          address: "",
          email: "",
          uId: "",
          profileImage: "",
          fcmToken: "")
      .obs;
  Rx<Services> services =
      Services(did: "", servicesName: "", createdAt: "", images: "").obs;
  List<Services> servicesList = [];
  List<OfferResModel> offerDAta = [];
  bool isSaved = false;
  List<ServiceResponseModel> servicesData = [];
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loadServicesData();
    loadUserData();
    getAllOfferData();
    getUid();
  }

  void setPopularServicesIndex({required int index}) {
    popularServicesIndex = index;
    update();
  }

  void setSavedValue({required bool value}) {
    isSaved = value;
    update();
  }

  Future<void> loadServicesData() async {
    try {
      isServicesLoading = true;
      update();
      LoadService.getSecondStream().listen((data) {
        servicesData = data;
        isServicesLoading = false;
        print("DATA LENGTH: ${servicesData.length}");
        update();
      });
    } catch (e) {
      isServicesLoading = false;
      print("Error loading services data: $e");
      update();
    }
    update();
  }

  Future<void> saveBy(String serviceIds, String userid) async {
    try {
      print("Call");
      DocumentReference docRef = servicesCollection.doc(serviceIds);
      DocumentSnapshot docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        // Cast the result of docSnapshot.data() to a Map<String, dynamic>
        Map<String, dynamic>? data =
            docSnapshot.data() as Map<String, dynamic>?;

        // Retrieve the current 'savedBy' list or initialize it to an empty list if it doesn't exist
        List<dynamic>? savedByList = data?['savedBy'] as List<dynamic>?;

        if (savedByList != null) {
          // Convert the list of dynamic to list of strings
          List<String> savedBy =
              savedByList.map((dynamic item) => item.toString()).toList();
          // Check if the user ID is already in the 'savedBy' list
          if (!savedBy.contains(userid)) {
            savedBy.add(userid);
            await docRef.update({'savedBy': savedBy});
            print("User added to savedBy list.");
          } else {
            savedBy.remove(userid);
            await docRef.update({'savedBy': savedBy});
            print("User removed from savedBy list.");
          }
          update();
        } else {
          // If 'savedBy' field is null or not present, initialize it with the current user ID
          await docRef.update({
            'savedBy': [userid]
          });
          print("User added to savedBy list.");
        }
      } else {
        print("Document does not exist.");
      }
    } catch (e) {
      print('Error saving or removing user ID: $e');
    }
  }

  Future<void> loadUserData() async {
    userLoadData = true;
    String uid = await LocalStorage.getUserId();
    if (uid != null) {
      DocumentReference<Map<String, dynamic>> userRef =
          FirebaseFirestore.instance.collection('User').doc(uid);
      DocumentSnapshot<Map<String, dynamic>> snapshot = await userRef.get();
      if (snapshot.exists) {
        servicesList = await loadCategory();
        userData.value = UserResModel.fromMap(snapshot.data()!);
        print("Success");
      } else {
        print("Data is empty");
      }
      update();
      userRef.snapshots().listen((snapshot) {
        if (snapshot.exists) {
          userData.value = UserResModel.fromMap(snapshot.data()!);
        } else {
          print("Data is empty");
        }
      });
    }
    userLoadData = false;
    update();
  }

  Future<List<Services>> loadCategory() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('servicesInfo').get();

      return querySnapshot.docs
          .map((doc) => Services.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Error fetching data: ${e.toString()}");
      // Depending on your requirements, you might want to rethrow the error
      // throw e;
      return [];
    }
  }

  void getAllOfferData() {
    update();
    Stream<QuerySnapshot> data =
        FirebaseFirestore.instance.collection('offers').snapshots();
    offerDAta.clear();
    data.listen((event) {
      offerDAta.clear();
      event.docs.forEach((element) {
        OfferResModel offerResModel =
            OfferResModel.fromMap(element.data() as Map<String, dynamic>);
        offerDAta.add(offerResModel);
      });
      update();
    });
  }
}
