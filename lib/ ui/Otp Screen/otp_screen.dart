import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:home_hub/%20ui/Otp%20Screen/otp_screen_controller.dart';
import 'package:home_hub/%20ui/Register/registerController.dart';
import 'package:home_hub/utils/app_routes.dart';
import 'package:home_hub/utils/extension.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  OtpScreenController otpScreenController = Get.put(OtpScreenController());
  String email = Get.arguments['email'];
  String password = Get.arguments['password'];
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: GetBuilder<OtpScreenController>(
          builder: (controller) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  8.h.addHSpace(),
                  Lottie.asset("assets/lottie/otp.json"),
                  "Please check your email and enter the 6-digit OTP below."
                      .semiOpenSans(
                          fontColor: Colors.black,
                          textAlign: TextAlign.center,
                          fontSize: 12.sp),
                  7.h.addHSpace(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(6, (index) {
                      return SizedBox(
                        width: 50,
                        height: 60,
                        child: TextFormField(
                          controller: controller.otpControllers[index],
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            if (value.length == 1) {
                              controller.isOtpFielled();
                              FocusScope.of(context).nextFocus();
                            } else {
                              FocusScope.of(context).previousFocus();
                            }
                          },
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1),
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                              hintText: "0",
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                      );
                    }),
                  ),
                  3.h.addHSpace(),
                  TextButton(
                    onPressed: controller.enableResend == true
                        ? () {
                            controller.resendOtp(email: email);
                          }
                        : () {},
                    child: Text(controller.enableResend == true
                        ? "Resend OTP"
                        : "Resend in ${controller.start} seconds"),
                  ),
                  20.h.addHSpace(),
                  controller.otpfilled == true
                      ? appButton(
                          onTap: () async {
                            String filledOtp = controller.getOtpFromScreen();
                            bool result = await controller.varifyOtp(filledOtp);
                            if (result) {
                              Get.offNamed(Routes.fillProfileScreen,
                                  arguments: {
                                    "email": email,
                                    "password": password
                                  });
                            }
                          },
                          fontSize: 12.sp,
                          fontColor: Colors.white,
                          text: "Submit")
                      : const SizedBox(),
                  10.h.addHSpace(),
                ],
              ).paddingSymmetric(horizontal: 2.w),
            );
          },
        ),
      ),
    );
  }
}
