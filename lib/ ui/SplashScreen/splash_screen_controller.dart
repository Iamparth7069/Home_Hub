import 'dart:async';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:home_hub/%20ui/Check%20Biometric/auth_api.dart';
import 'package:home_hub/utils/app_routes.dart';
import 'package:home_hub/utils/local_storage.dart';

class SplashScreenController extends GetxController {
  String displayText = '';
  int index = 0;
  final String _fullText = 'Help Harbor';

  @override
  void onInit() {
    super.onInit();
    _navigate();
  }

  void _navigate() async {
    final box = GetStorage();
    print(box.read(LocalStorage.biometric));
    Future.delayed(const Duration(seconds: 3)).then(
      (value) {
        box.read(LocalStorage.uid) == null
            ? Get.offAllNamed(Routes.loginScreen)
            : box.read(LocalStorage.biometric) == true
                ? Get.offNamed(Routes.checkBiometric)
                : Get.offAllNamed(Routes.bottomNavBar);
      },
    );
  }
}
