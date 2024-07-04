import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:home_hub/Response%20Model/user_res_model.dart';
import 'package:home_hub/firebase%20services/repo.dart';
import 'package:home_hub/utils/app_routes.dart';
import 'package:home_hub/utils/local_storage.dart';
import 'package:image_picker/image_picker.dart';

class FillProfileScreenController extends GetxController {
  ImagePicker imagePicker = ImagePicker();
  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  File? image;
  bool isSendData = false;
  Future<void> pickImage() async {
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
    image = File(file!.path);
    update();
  }

  void changeSendDataValue({required bool value}) {
    isSendData = value;
    update();
  }

  Future<dynamic> registerWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      update();

      if (e.code == 'weak-password') {
        Get.snackbar('Error', 'The password provided is too weak.');
        return e.code.toString();
      } else if (e.code == 'email-already-in-use') {
        Get.snackbar('Error', 'The account already exists for that email.');
        return e.code.toString();
      } else {
        Get.snackbar('Error', 'Error registering user: ${e.message}');
        return e.code.toString();
      }
    } catch (e) {
      Get.snackbar('Error', 'Error registering user: $e');

      update();
      return "Catech ${e.toString()}";
    }
  }

  Future<void> sedProfileData({required UserResModel resModel}) async {
    try {
      // set the user document in Firestore
      await userCollection.doc(resModel.uId).set(resModel.toMap());

      //  send user data to local storage
      await LocalStorage.sendUserData(userResModel: resModel);
      Get.offAllNamed(Routes.loginScreen);
      isSendData = false;
      update();
    } on FirebaseException catch (firebaseEx) {
      // Handle Firestore-specific errors
      debugPrint("FirebaseException: ${firebaseEx.message}");
      isSendData = false;
      update();
    } on Exception catch (ex) {
      // Handle other types of exceptions
      debugPrint("An error occurred: ${ex.toString()}");
      isSendData = false;
      update();
    }
  }

  Future<String> sendProfileImage({required String userId}) async {
    try {
      isSendData = true;
      update();
      // Create a reference to the Firebase Storage location
      final storageRef = FirebaseStorage.instance.ref();
      // Define the path in the Storage where you want to save the image
      final imageRef = storageRef.child("profileImage/$userId.jpg");

      // Upload the file to Firebase Storage

      if (image != null) {
        final uploadTask = imageRef.putFile(image!);

        // Wait for the upload to complete
        final snapshot = await uploadTask;

        // Get the URL of the uploaded file
        final imageUrl = await snapshot.ref.getDownloadURL();

        return imageUrl;
      } else {
        return "";
      }
    } on FirebaseException catch (e) {
      // Handle any errors
      print(e.toString());
      isSendData = false;
      update();
      return "";
    }
    return "";
  }
}
