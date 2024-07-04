import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:home_hub/Response%20Model/user_res_model.dart';
import 'package:home_hub/firebase%20services/notification_service.dart';
import 'package:home_hub/firebase%20services/repo.dart';
import 'package:home_hub/utils/local_storage.dart';

import '../../utils/app_routes.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Rx<User?> user = Rx<User?>(null);
  String? get userId => user.value?.uid;
  RxBool isLoading = false.obs;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    LocalStorage.sendBiometric(bio: false);
    user.bindStream(_auth.authStateChanges());
  }

  Future<void> signInWithEmailAndPassword() async {
    try {
      isLoading(true);
      UserCredential login = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      if (login != null) {
        DocumentSnapshot userData =
            await userCollection.doc(login.user!.uid).get();
        String fcmToken = await NotificationService().getFCMToken();
        UserResModel userResModel =
            UserResModel.fromMap(userData.data() as Map<String, dynamic>);
        userResModel.fcmToken = fcmToken;
        await userCollection.doc(login.user!.uid).update(userResModel.toMap());
        await LocalStorage.sendUserData(userResModel: userResModel);
      }
      LocalStorage.sendUserId(userId: login.user!.uid.toString());
      Get.offAllNamed(Routes.bottomNavBar);
      isLoading(false);
    } on FirebaseAuthException catch (e) {
      isLoading(false);
      if (e.code == 'user-not-found') {
        Get.snackbar(
          'Login Error',
          'No user found for that email',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else if (e.code == 'wrong-password') {
        Get.snackbar(
          'Login Error',
          'Wrong password provided for that user',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else if (e.code == 'invalid-email') {
        Get.snackbar(
          'Login Error',
          'Invalid email address',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Login Error',
          'Error: Invalid email address And Password',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      print('Login failed: $e');
    } catch (e) {
      // Catch other exceptions
      print('Login failed: $e');
      Get.snackbar(
        'Login Error',
        'Failed to sign in: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential authResult =
            await FirebaseAuth.instance.signInWithCredential(credential);
        final User? user = authResult.user;

        if (user != null) {
          // Checking if user is logging in for the first time
          final userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
          if (!userDoc.exists) {
            // New user. You can now navigate the user to your onboarding screen or create a new user document in Firestore.
            // For example, creating a user document:
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .set({
              'uid': user.uid,
              'email': user.email,
              // Add more fields as needed
            });
            print("New user created");
          } else {
            // Existing user. Navigate the user to your home screen or perform other actions.
            print("Welcome back!");
          }
        }
        return authResult;
      }
    } catch (error) {
      print('Error signing in with Google: $error');
      // Handle error further if needed
    }
  }
}
