import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_hub/utils/app_routes.dart';

class OnBordingScreenController extends GetxController {
  int currentPageIndex = 0;
  final PageController pageController = PageController(initialPage: 0);
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  changePageIndex(int value) {
    currentPageIndex = value;
    update();
  }

  navigateToPage() {
    if (currentPageIndex < 2) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      Get.offAllNamed(Routes.letsYouInScreen);
    }
  }
}
