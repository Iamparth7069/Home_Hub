import 'package:get/get.dart';
import 'package:home_hub/%20ui/Chat%20Screen/chat_screen.dart';
import 'package:home_hub/%20ui/Chat%20Screen/messege_screen.dart';
import 'package:home_hub/%20ui/Check%20Biometric/check_biometric.dart';
import 'package:home_hub/%20ui/Fill%20Profile%20Screen/fill_profile_screen.dart';
import 'package:home_hub/%20ui/Forgot%20Password/forgot_password_screen.dart';
import 'package:home_hub/%20ui/Forgot%20Password/forgot_screen_controller.dart';

import 'package:home_hub/%20ui/Home/home_screen.dart';
import 'package:home_hub/%20ui/Invoice/invoice_screen.dart';
import 'package:home_hub/%20ui/LetsYouInScreen/lets_you_in_Screen.dart';
import 'package:home_hub/%20ui/Login/LoginScreen.dart';
import 'package:home_hub/%20ui/OnBordingScreen/on_bording_screen.dart';
import 'package:home_hub/%20ui/Otp%20Screen/otp_screen.dart';

import 'package:home_hub/%20ui/Register/Register.dart';
import 'package:home_hub/%20ui/Review%20Screen/review_screen.dart';
import 'package:home_hub/%20ui/Service%20Details/review_show_screen.dart';
import 'package:home_hub/%20ui/Service%20Details/service_detail_screen.dart';
import 'package:home_hub/%20ui/SplashScreen/splash_screen.dart';
import 'package:home_hub/%20ui/Transection%20Screen/transection_screen.dart';
import 'package:home_hub/%20ui/bottom%20nav%20bar/bottom_nav_bar.dart';
import 'package:home_hub/%20ui/getAllServices/getAllServices.dart';
import 'package:home_hub/%20ui/profile%20Screens/profile_Screen.dart';
import 'package:home_hub/%20ui/saveAllItems/saveAll.dart';
import 'package:home_hub/%20ui/security%20screen/security_screen.dart';

class Routes {
  static String splashScreen = "/";
  static String onBordingScreen = "/onBordingScreen";
  static String letsYouInScreen = "/letsYouInScreen";
  static String reistrationScreen = '/reistrationScreen';
  static String loginScreen = '/loginScreen';
  static String homeScreen = '/homeScreen';
  static String savedAll = '/allSavedItems';
  static String bottomNavBar = '/bottomNavBar';
  static String serviceDetailScreen = '/ServiceDetailScreen';
  static String chatScreen = '/chatScreen';
  static String messegeScreen = '/MessegeScreen';
  static String fillProfileScreen = '/FillProfileScreen';
  static String otpScreen = '/otpScreen';
  static String paymentScreen = '/paymentScreen';
  static String allServices = '/GetAllService';
  static String profileScreen = '/profileScreen';
  static String checkBiometric = '/checkBiometric';
  static String securityScreen = '/securityScreen';
  static String transectionScreen = '/transectionScreen';
  static String invoiceScreen = '/invoiceScreen';
  static String reviewScreen = '/reviewScreen';
  static String showReviewScreen = '/showReviewScreen';
  static String forgotPassScreen = '/forgotPassScreen';
  static final getPages = [
    GetPage(name: splashScreen, page: () => SplashScreen()),
    GetPage(name: onBordingScreen, page: () => const OnBordingScreen()),
    GetPage(
      name: letsYouInScreen,
      page: () => LetsYouInScreen(),
    ),
    GetPage(
      name: reistrationScreen,
      page: () => Register(),
    ),
    GetPage(
      name: loginScreen,
      page: () => Login(),
    ),
    GetPage(
      name: fillProfileScreen,
      page: () => const FillProfileScreen(),
    ),
    GetPage(
      name: homeScreen,
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: bottomNavBar,
      page: () => const BottomNavBar(),
    ),
    GetPage(
      name: serviceDetailScreen,
      page: () => const ServiceDetailsScreen(),
    ),
    GetPage(
      name: chatScreen,
      page: () => const ChatScreen(),
    ),
    GetPage(
      name: messegeScreen,
      page: () => const MessegeScreen(),
    ),
    GetPage(
      name: otpScreen,
      page: () => const OtpScreen(),
    ),
    GetPage(
      name: profileScreen,
      page: () => ProfileScreen(),
    ),
    GetPage(
      name: checkBiometric,
      page: () => const CheckBiometric(),
    ),
    GetPage(
      name: securityScreen,
      page: () => const SecurityScreen(),
    ),
    GetPage(
      name: transectionScreen,
      page: () => const TransectionScreen(),
    ),
    GetPage(
      name: invoiceScreen,
      page: () => InvoiceScreen(),
    ),
    GetPage(
      name: savedAll,
      page: () => SaveAllItems(),
    ),
    GetPage(
      name: reviewScreen,
      page: () => const ReviewScreen(),
    ),
    GetPage(
      name: showReviewScreen,
      page: () => const ShowReviewScreen(),
    ),
    GetPage(
      name: allServices,
      page: () => const GetAllService(),
    ),
    GetPage(
      name: forgotPassScreen,
      page: () => const ForgotPasswordScreen(),
    ),
  ];
}
