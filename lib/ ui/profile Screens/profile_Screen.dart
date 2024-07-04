import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get_storage/get_storage.dart';
import 'package:home_hub/%20ui/profile%20Screens/editprofile/editprofile.dart';
import 'package:home_hub/%20ui/profile%20Screens/perfile_screen_controller.dart';
import 'package:home_hub/constant/app_color.dart';
import 'package:home_hub/utils/app_routes.dart';
import 'package:home_hub/utils/extension.dart';
import 'package:home_hub/utils/local_storage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';
import 'package:sizer/sizer.dart';

import '../../Response Model/profileListItem.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreenController controller = Get.put(ProfileScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                          height: 4.8.h,
                          width: 10.w,
                          decoration: BoxDecoration(
                              color: appColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Image.asset(
                            "assets/images/app_logo.png",
                            scale: 18,
                            color: Colors.white,
                          )),
                      2.w.addWSpace(),
                      Text(
                        "Profile",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 25),
                      )
                    ],
                  ),
                  ImageIcon(AssetImage("assets/images/more.png"))
                ],
              ),
              2.h.addHSpace(),
              Obx(
                () {
                  if (controller.isLoading.value) {
                    return LoadingAnimationWidget.hexagonDots(
                        color: appColor, size: 5.h);
                  } else {
                    final userdata = controller.userdata.value;
                    if (userdata != null) {
                      return Column(
                        children: [
                          Center(
                            child: Stack(
                              children: [
                                Container(
                                  width: 130,
                                  height: 130,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 2.0,
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    radius: 100,
                                    backgroundColor: Colors.transparent,
                                    child: ClipOval(
                                      child: CachedNetworkImage(
                                        placeholder: (context, url) {
                                          return LoadingAnimationWidget
                                              .hexagonDots(
                                                  color: appColor, size: 5.h);
                                        },
                                        imageUrl: userdata.profileImage,
                                        width: 130,
                                        height: 130,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            "${controller.userdata.value!.lastName} ${controller.userdata.value!.firstName}",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                          1.h.addHSpace(),
                          Text(
                            "${controller.userdata.value!.email}",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 16),
                          ),
                        ],
                      );
                    } else {
                      return Text("No data");
                    }
                  }
                },
              ),
              1.5.h.addHSpace(),
              4.1.appDivider(color: Colors.grey),
              ProfileListItem(
                onPressed: () {
                  Get.to(EditProfile(controller.userdata.value!));
                },
                icon: "assets/images/svg/user1.svg",
                name: "Edit Profile",
              ),
              1.5.h.addHSpace(),
              ProfileListItem(
                onPressed: () {
                  openAppSettings();
                },
                icon: "assets/images/svg/bell1.svg",
                name: "Notification",
              ),
              1.5.h.addHSpace(),
              ProfileListItem(
                onPressed: () {
                  Get.toNamed(Routes.transectionScreen);
                },
                icon: "assets/images/svg/expense.svg",
                name: "Payment",
              ),
              1.5.h.addHSpace(),
              ProfileListItem(
                onPressed: () {
                  Get.toNamed(Routes.securityScreen);
                },
                icon: "assets/images/svg/shield-check.svg",
                name: "Security",
              ),
              1.5.h.addHSpace(),
              ProfileListItem(
                onPressed: () async {
                  try {
                    String referralLink = '<your_referral_link>';

                    await Share.share(
                      'Join our app and get rewarded! Here is the referral link: $referralLink',
                      subject: 'Check out this cool app!',
                    );
                  } catch (e) {
                    print('Error sharing: $e');
                  }
                },
                icon: "assets/images/svg/images.svg",
                name: "Invite Friends ",
              ),
              1.5.h.addHSpace(),
              ProfileListItem(
                iconColors: Colors.red,
                color: Colors.red,
                onPressed: () {
                  final box = GetStorage();
                  FirebaseAuth.instance.signOut();
                  LocalStorage.clearAllData();
                  Get.offAllNamed(Routes.loginScreen);
                },
                icon: "assets/images/svg/logout.svg",
                name: "LogOut",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
