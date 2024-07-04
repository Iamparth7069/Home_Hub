import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_hub/%20ui/Check%20Biometric/auth_api.dart';
import 'package:home_hub/%20ui/Check%20Biometric/check_biometric_controller.dart';
import 'package:home_hub/utils/extension.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

class CheckBiometric extends StatefulWidget {
  const CheckBiometric({super.key});

  @override
  State<CheckBiometric> createState() => _CheckBiometricState();
}

class _CheckBiometricState extends State<CheckBiometric> {
  CheckBioMetricController checkBioMetricController =
      Get.put(CheckBioMetricController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkBioMetricController.checkAuth();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          20.h.addHSpace(),
          Center(
            child: Lottie.asset("assets/lottie/finger.json",
                width: 200, height: 200, frameRate: FrameRate(10000)),
          ),
          Spacer(),
          appButton(
              onTap: () {
                checkBioMetricController.checkAuth();
              },
              text: "Authenticate"),
          5.h.addHSpace(),
        ],
      ),
    );
  }
}
