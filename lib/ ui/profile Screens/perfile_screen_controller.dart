import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';



import '../../Response Model/user_res_model.dart';
import '../../utils/local_storage.dart';

class ProfileScreenController extends GetxController{

  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loadUserData();
  }
  RxBool isLoading = false.obs;
  Rx<UserResModel?> userdata = Rx<UserResModel?>(null);
 void loadUserData() async {
    try{
      isLoading.value = true;
      String? uid = _auth.currentUser!.uid;
      print(uid);
      FirebaseFirestore.instance.collection("User").where("uId" ,isEqualTo: uid).snapshots().listen((QuerySnapshot<Map<String, dynamic>> snapshot)  {
        if(snapshot.docs.isNotEmpty){
          userdata.value  = UserResModel.fromMap(snapshot.docs.first.data());
        }
      });
      print("Updte");
      isLoading.value = false;
    }catch(e){
      isLoading.value = false;
      print(e.toString());
    }
  }


}