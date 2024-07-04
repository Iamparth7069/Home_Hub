import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:home_hub/firebase%20services/repo.dart';
import 'package:home_hub/utils/local_storage.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:otp/otp.dart';

class RegisterController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Rx<User?> user = Rx<User?>(null);
  RxBool isLoading = false.obs;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  void onInit() {
    super.onInit();
    user.value = _auth.currentUser;
    _auth.authStateChanges().listen((User? firebaseUser) {
      user.value = firebaseUser;
    });
  }

  Future<dynamic> registerWithEmailAndPassword() async {
    try {
      isLoading(false);
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: emailController.text.toString().trim(),
              password: passwordController.text.toString().trim());
      user.value = userCredential.user;
      isLoading(true);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      isLoading(false);
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
      isLoading(false);
      update();
      return "Catech ${e.toString()}";
    }
  }

  sendOtp(String email) async {
    String secret = 'asdnasjdnasjdnasjdasdnasjdnajsdndnasdjnasd';
    String otp = OTP
        .generateTOTPCode(secret, DateTime.now().millisecondsSinceEpoch,
            length: 6)
        .toString();
    final smtpServer = gmail('zsp.bhavik@gmail.com', 'iwvu vtof svpj ubfc');
    // Create the email message
    final message = Message()
      ..from = const Address('vyasparth451@gmail.com', 'Home Hub')
      ..recipients.add(email)
      ..subject = 'Email Verification OTP'
      ..html = '''
     <!DOCTYPE html>
<html>

<head>
  <style>
    body {
      font-family: 'Arial', sans-serif;
      background-color: #f4f4f4;
      color: #333;
      margin: 0;
      padding: 0;
      text-align: center;
    }

    .container {
      max-width: 600px;
      margin: 0 auto;
      padding: 20px;
      background-color: #fff;
      border-radius: 5px;
      box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    }

    h2 {
      color: #007bff;
    }

    .verification-code {
      color: #007bff;
      font-size: 36px;
      margin: 20px 0;
    }

    .expire-message {
      color: #dc3545;
      margin-top: 10px;
    }

    .notice {
      color: #28a745;
      margin-top: 10px;
    }

    .support-info {
      margin-top: 20px;
    }

    .contact-link {
      color: #007bff;
      text-decoration: none;
      font-weight: bold;
    }
  </style>
</head>

<body>
  <div class="container">
    <h2>Home Hub Services Email Verification</h2>
    <p>Dear User,</p>
    <p>Your verification code for Home Hub Services is:</p>
    <h1 class="verification-code">$otp</h1>
    <p class="expire-message">This code will expire in 5 minutes.</p>
    <p class="notice">Please do not share this code with anyone for security reasons.</p>
    <p>If you have any questions or need assistance, feel free to reach out to our support team.</p>
    <div class="support-info">
      <p>Contact us at: <a class="contact-link" href="mailto:support@homehub.com">support@homehub.com</a></p>
    </div>
    <p>Thank you for choosing Home Hub!</p>
  </div>
</body>

</html>

    ''';

    try {
      final sendReport = await send(message, smtpServer);

      print('Message sent: ${sendReport.toString()}');
      isLoading(false);
      await LocalStorage.sendOtp(value: otp);

      // await sendOTPTOFirebase(email, otp);
    } on MailerException catch (e) {
      print('Failed to send the email: $e');
    }
  }

  Future<void> sendOTPTOFirebase(String email, String otp) async {
    try {
      await otpService.doc(email).set({
        'email': email,
        'otp': otp,
        'timestamp': FieldValue.serverTimestamp(), // Store server timestamp
      });
    } catch (e) {
      print('Error sending OTP data: $e');
    }
  }

  // Future<dynamic> signIngoogle() async {
  //   try {
  //     isLoading(true);
  //     final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
  //     if (googleUser == null) {
  //       print("return Null");
  //       return null;
  //     }
  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser.authentication;
  //     final OAuthCredential credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );
  //     UserCredential? userCredential =
  //         await _auth.signInWithCredential(credential);
  //     if (userCredential != null) {
  //       // Handle successful sign-in
  //       print('User signed in: ${userCredential.user?.displayName}');
  //     } else {
  //       // Handle sign-in failure
  //       print('Failed to sign in with Google.');
  //     }
  //     print("Accsess Tocken = ${credential.accessToken}");
  //     // print(credential.idToken);
  //     isLoading(false);
  //     return await _auth.signInWithCredential(credential);
  //   } catch (e) {
  //     print(e.toString());
  //     return null;
  //   }
  // }
}
