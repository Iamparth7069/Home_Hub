import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_hub/%20ui/SplashScreen/splash_screen_controller.dart';
import 'package:home_hub/constant/app_assets.dart';
import 'package:home_hub/constant/app_color.dart';
import 'package:home_hub/utils/extension.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  SplashScreenController splashScreenController =
      Get.put(SplashScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 40.w,
            height: 40.h,
            child: assetImage(AppAssets.appLogo),
          ),
          20.h.addHSpace(),
          LoadingAnimationWidget.hexagonDots(color: appColor, size: 5.h),
          15.h.addHSpace(),
        ],
      ),
    );
  }
}
