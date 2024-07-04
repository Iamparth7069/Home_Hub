import 'package:awesome_icons/awesome_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_hub/%20ui/Login/logincontroller.dart';
import 'package:home_hub/firebase%20services/notification_service.dart';
import 'package:home_hub/utils/app_routes.dart';
import 'package:home_hub/utils/extension.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../constant/app_assets.dart';
import '../../constant/app_color.dart';

class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final LoginController authController = Get.put(LoginController());

  final _globel = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Form(
              key: _globel,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 5.w,
                  ),
                  // Container(
                  //   decoration: const BoxDecoration(
                  //     shape: BoxShape.circle,
                  //   ),
                  //   child: InkWell(
                  //     onTap: () {
                  //       Get.offAllNamed(Routes.letsYouInScreen);
                  //     },
                  //     child: Icon(
                  //       Icons.arrow_back_outlined,
                  //       size: 3.h,
                  //     ),
                  //   ),
                  // ),
                  5.h.addHSpace(),
                  Center(
                      child: Lottie.asset("assets/lottie/login.json",
                          width: 70.w)),
                  "Login to your Account".mediumRoboto(
                    fontColor: Colors.black,
                    fontSize: 40,
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || !AppAssets.isvalidemail(value)) {
                        return "Enter the Valid Email";
                      } else {
                        return null;
                      }
                    },
                    controller: authController.emailController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: "Email",
                      filled: true,
                      fillColor: Colors.grey[100],
                      prefixIcon: const Icon(Icons.email),
                    ),
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  TextFormField(
                    controller: authController.passwordController,
                    validator: (value) {
                      if (value == null || !AppAssets.isvalidpassword(value)) {
                        return "Enter the validPassword";
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: "Password",
                        filled: true,
                        fillColor: Colors.grey[100],
                        prefixIcon: Icon(MdiIcons.formTextboxPassword),
                        suffixIcon: const Icon(Icons.remove_red_eye_sharp)),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                        onPressed: () {
                          Get.toNamed(Routes.forgotPassScreen);
                        },
                        icon: "Forgot Password?".semiOpenSans(
                            fontColor: appColor, fontSize: 10.sp)),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Obx(
                    () => authController.isLoading.value
                        ? LoadingAnimationWidget.hexagonDots(
                            color: appColor, size: 5.h)
                        : appButton(
                            onTap: () {
                              if (_globel.currentState!.validate()) {
                                authController.signInWithEmailAndPassword();
                              } else {
                                print("Error");
                              }
                            },
                            text: "Sign In"),
                  ),
                  3.h.addHSpace(),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 10),
                  //   child: Row(
                  //     children: [
                  //       const Expanded(
                  //         flex: 2,
                  //         child: Divider(
                  //           thickness: 2,
                  //           color: Colors.grey,
                  //         ),
                  //       ),
                  //       2.w.addWSpace(),
                  //       // Adding space between the divider and text
                  //       const Expanded(
                  //         flex: 3,
                  //         child: Text(
                  //           "or continue with",
                  //           maxLines: 1,
                  //           overflow: TextOverflow.ellipsis,
                  //           textAlign: TextAlign.center,
                  //           style: TextStyle(
                  //             fontSize: 16, // Adjust font size as needed
                  //             color: Colors
                  //                 .black, // Change text color if necessary
                  //           ),
                  //         ),
                  //       ),
                  //       SizedBox(width: 3.w),
                  //       // Adding space between the text and divider
                  //       const Expanded(
                  //         flex: 2,
                  //         child: Divider(
                  //           thickness: 2,
                  //           color: Colors.grey,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // 2.h.addHSpace(),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 30),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //     children: [
                  //       customSquareButton(
                  //           icon: Icons.facebook,
                  //           onTap: () {},
                  //           color: Colors.blue,
                  //           iconSize: 4.h),
                  //       customSquareButton(
                  //           icon: FontAwesomeIcons.google,
                  //           onTap: () async {
                  //             var login =
                  //                 await authController.signInWithGoogle();
                  //             print(login);
                  //           },
                  //           iconSize: 4.h),
                  //       customSquareButton(
                  //           icon: Icons.apple, onTap: () {}, iconSize: 4.h)
                  //     ],
                  //   ),
                  // ),
                  SizedBox(
                    height: 3.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      "Don't have an account?"
                          .mediumRoboto(fontSize: 14, fontColor: Colors.grey),
                      SizedBox(
                        width: 1.w,
                      ),
                      InkWell(
                          onTap: () {
                            Get.offAllNamed(Routes.reistrationScreen);
                          },
                          child: "Sign up"
                              .boldRoboto(fontColor: lightBlue, fontSize: 15))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
