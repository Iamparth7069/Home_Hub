import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:home_hub/%20ui/Check%20Biometric/auth_api.dart';
import 'package:home_hub/utils/app_routes.dart';
import 'package:local_auth/local_auth.dart';

class CheckBioMetricController extends GetxController {
  bool isAuthenticate = false;

  checkAuth() async {
    isAuthenticate = await LocalAuthApi.authenticate();
    if (isAuthenticate == true) {
      Get.offNamed(Routes.bottomNavBar);
    }
  }
}
