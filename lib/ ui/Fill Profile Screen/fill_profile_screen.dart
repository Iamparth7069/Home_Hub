import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:home_hub/%20ui/Fill%20Profile%20Screen/fill_profile_screen_controller.dart';
import 'package:home_hub/%20ui/Register/registerController.dart';
import 'package:home_hub/Response%20Model/user_res_model.dart';
import 'package:home_hub/constant/app_color.dart';
import 'package:home_hub/utils/extension.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';

class FillProfileScreen extends StatefulWidget {
  const FillProfileScreen({super.key});

  @override
  State<FillProfileScreen> createState() => _FillProfileScreenState();
}

class _FillProfileScreenState extends State<FillProfileScreen> {
  FillProfileScreenController fillProfileScreenController =
      Get.put(FillProfileScreenController());
  String email = Get.arguments['email'];
  String password = Get.arguments['password'];
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () => Get.back, child: const Icon(Icons.arrow_back_rounded)),
        title: "Fill Your Profile"
            .boldOpenSans(fontColor: Colors.black, fontSize: 14.sp),
      ),
      body: GetBuilder<FillProfileScreenController>(
        builder: (controller) {
          return SingleChildScrollView(
            child: Form(
              key: formKey,
              child: SizedBox(
                height: 85.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    2.h.addHSpace(),
                    Center(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          CircleAvatar(
                            backgroundColor: const Color(0xfff5f5f8),
                            radius: 15.w,
                            backgroundImage: controller.image != null
                                ? FileImage(controller.image as File)
                                : const AssetImage(
                                        "assets/images/profile_image.jpg")
                                    as ImageProvider,
                          ),
                          Positioned(
                            right: 3,
                            bottom: 3,
                            child: GestureDetector(
                              onTap: () {
                                controller.pickImage();
                              },
                              child: Container(
                                width: 6.w,
                                height: 6.w,
                                decoration: BoxDecoration(
                                    color: appColor,
                                    borderRadius: BorderRadius.circular(5)),
                                child: const Center(
                                  child: Icon(Icons.edit,
                                      color: Colors.white, size: 14),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    6.h.addHSpace(),
                    customTextFormField(
                      hintText: "First Name",
                      textEditingController: controller.fNameController,
                      validator: (p0) {
                        if (p0!.isEmpty) {
                          return "Please Enter First Name";
                        }
                      },
                    ),
                    2.h.addHSpace(),
                    customTextFormField(
                      hintText: "Last Name",
                      textEditingController: controller.lNameController,
                      validator: (p0) {
                        if (p0!.isEmpty) {
                          return "Please Enter Last Name";
                        }
                      },
                    ),
                    2.h.addHSpace(),
                    customTextFormField(
                      hintText: "Phone Number",
                      data: [
                        LengthLimitingTextInputFormatter(10),
                      ],
                      textEditingController: controller.phoneNumberController,
                      validator: (p0) {
                        if (p0!.isEmpty) {
                          return "Please Enter Phone Number";
                        } else if (p0!.length > 10) {
                          return "Please Enter Valid Phone Number";
                        }
                      },
                    ),
                    2.h.addHSpace(),
                    customTextFormField(
                        hintText: "Address",
                        textEditingController: controller.addressController,
                        validator: (p0) {
                          if (p0!.isEmpty) {
                            return "Please Enter Address";
                          }
                        },
                        maxLines: 2),
                    const Spacer(),
                    controller.isSendData == true
                        ? LoadingAnimationWidget.hexagonDots(
                            color: appColor, size: 5.h)
                        : appButton(
                            onTap: () async {
                              if (formKey.currentState!.validate()) {
                                controller.changeSendDataValue(value: true);
                                await controller.registerWithEmailAndPassword(
                                    email: email, password: password);
                                User? user = FirebaseAuth.instance.currentUser;
                                String imageUrl = await controller
                                    .sendProfileImage(userId: user!.uid);

                                UserResModel userModel = UserResModel(
                                    firstName: controller.fNameController.text,
                                    lastName: controller.lNameController.text,
                                    phoneNumber:
                                        controller.phoneNumberController.text,
                                    address: controller.addressController.text,
                                    email: user.email ?? "",
                                    uId: user.uid ?? "",
                                    profileImage: imageUrl,
                                    fcmToken: '');
                                await controller.sedProfileData(
                                    resModel: userModel);
                              }
                            },
                            color: appColor,
                            width: 90.w,
                            fontColor: Colors.white,
                            fontSize: 10.sp,
                            text: "Continue")
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
