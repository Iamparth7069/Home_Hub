import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:home_hub/firebase%20services/repo.dart';
import 'package:home_hub/utils/app_routes.dart';
import 'package:home_hub/utils/extension.dart';
import 'package:home_hub/utils/local_storage.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:otp/otp.dart';

class ForgotScreenController extends GetxController {
  TextEditingController email = TextEditingController();
  Future<void> checkUserAndSendResetLink(String email) async {
    final usersCollection = FirebaseFirestore.instance.collection('User');
    final querySnapshot =
        await usersCollection.where('email', isEqualTo: email).get();

    if (querySnapshot.docs.isNotEmpty) {
      // User exists, proceed with sending a reset link
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email).then(
          (value) {
            Get.offAllNamed(Routes.loginScreen);
          },
        );
        showMessege(
            title: "Hurray", messege: "Password Reset Link Sent to Your Email");
        print("Password reset email sent.");
        // Handle the UI feedback/logic here, maybe navigate or show a dialog
      } on FirebaseAuthException catch (e) {
        print("Failed to send password reset email: ${e.message}");
        showMessege(
            title: "Opps! Somethingg Went Wrong",
            messege: "Please Try After Some time");
        // Handle errors, maybe show a dialog to the user
      }
    } else {
      // User does not exist, handle accordingly
      print("No user associated with this email.");
      showMessege(
          title: "Opps! Somethingg Went Wrong",
          messege: "User Not Fount with this Email");

      // Show some UI feedback/dialog here to inform the user
    }
  }
}
