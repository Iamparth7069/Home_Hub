import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:home_hub/utils/local_storage.dart';
import 'package:path/path.dart' as path;

import 'package:get/get.dart';
import 'package:home_hub/Response%20Model/user_res_model.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileController extends GetxController{
  RxBool isLoading = false.obs;
  Rx<File?> imageFile = Rx<File?>(null);
  Rx<UserResModel?> userdata = Rx<UserResModel?>(null);
  final fName=  TextEditingController();
  final lName = TextEditingController();
  final mobileNumber = TextEditingController();
  final address = TextEditingController();
  final globel = GlobalKey<FormState>();
  String? images;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loadUserData();
  }

  Future<bool> updateData(UserResModel userResModel) async {
    try {

      isLoading.value = true;
      FirebaseStorage storage = FirebaseStorage.instance;
      var firebase = FirebaseFirestore.instance.collection("User").doc(userResModel.uId);
      String img = "";
      if(imageFile.value == null){
        img =userResModel.profileImage;
      }else{
        img = await pickImages();
      }
      userResModel.profileImage = img;
      await firebase.update(userResModel.toMap());
      isLoading.value = false;
      return true; // Return true if the update was successful
    } catch (e) {
      isLoading.value = false;
      print(e.toString());
      return false; // Return false if an error occurred during the update
    }
  }


  Future<void> pickImageFromGallery() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage != null) {
      imageFile.value = File(pickedImage.path);
    }
  }

  Future<void> pickImageFromCamera() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );

    if (pickedImage != null) {
      imageFile.value = File(pickedImage.path);
    }
  }

  Future<List<UserResModel>> loadUserData() async {
    List<UserResModel> data = [];
    String uid =await LocalStorage.getUserId();
    CollectionReference collectionReference = FirebaseFirestore.instance.collection("User");
    QuerySnapshot querySnapshot = await collectionReference.where("uId",isEqualTo: uid).get();
    try{
      if(querySnapshot.docs.isNotEmpty){
        querySnapshot.docs.forEach((element) {
          Map<String, dynamic> datas = element.data() as Map<String, dynamic>;
          data.add(UserResModel.fromMap(datas));
        });
        return data;
      }else{
        print("Data Error");
        return [];
      }
    } catch(e){
      return [];
    }
  }

  pickImages() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    String downloadUrl = "";
    String extentions = path.extension(imageFile.value!.path);
    String fileName = DateTime.now().millisecondsSinceEpoch.toString() + extentions;
    Reference ref = storage.ref().child('profileImage').child(fileName);
    File file = imageFile.value!;
    await ref.putFile(file);
    downloadUrl = await ref.getDownloadURL();
    return downloadUrl;

  }


}