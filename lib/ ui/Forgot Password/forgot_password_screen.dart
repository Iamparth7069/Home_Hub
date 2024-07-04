import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:home_hub/%20ui/Forgot%20Password/forgot_screen_controller.dart';
import 'package:home_hub/constant/app_assets.dart';
import 'package:home_hub/utils/extension.dart';
import 'package:sizer/sizer.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  ForgotScreenController forgotScreenController =
      Get.put(ForgotScreenController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ForgotScreenController>(
        builder: (controller) {
          return SafeArea(
              child: SingleChildScrollView(
            child: Column(
              children: [
                10.h.addHSpace(),
                Center(
                  child: SvgPicture.asset(
                    "assets/images/svg/forgot.svg",
                    width: 70.w,
                  ),
                ),
                5.h.addHSpace(),
                Center(
                    child: "Forgot Password".boldOpenSans(
                        fontColor: Colors.black, fontSize: 20.sp)),
                5.h.addHSpace(),
                TextFormField(
                  controller: controller.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || !AppAssets.isvalidemail(value)) {
                      return "Enter the Valid Email";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: "Email",
                    filled: true,
                    fillColor: Colors.grey[100],
                    prefixIcon: const Icon(Icons.email),
                  ),
                ).paddingSymmetric(horizontal: 2.w),
                30.h.addHSpace(),
                appButton(
                    onTap: () {
                      controller.checkUserAndSendResetLink(
                          controller.email.text.trim());
                    },
                    text: "Send Otp")
              ],
            ),
          ));
        },
      ),
    );
  }
}
