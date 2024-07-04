import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:home_hub/%20ui/Check%20Biometric/auth_api.dart';
import 'package:home_hub/constant/app_color.dart';
import 'package:home_hub/utils/extension.dart';
import 'package:home_hub/utils/local_storage.dart';
import 'package:sizer/sizer.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool twoFector = false;
  bool biometricLock = false;
  final box = GetStorage();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // biometricLock = LocalStorage.getBiometric() ?? false;
    biometricLock = box.read(LocalStorage.biometric);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: "Security"
              .semiOpenSans(fontSize: 14.sp, fontColor: Colors.black)),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            2.h.addHSpace(),
            // Row(
            //   children: [
            //     "Two-Step Authentication"
            //         .semiOpenSans(fontColor: Colors.black, fontSize: 12.sp),
            //     const Spacer(),
            //     Switch(
            //       value: twoFector,
            //       activeTrackColor: appColor,
            //       inactiveTrackColor: lightPurple,
            //       onChanged: (value) {
            //         twoFector = value;
            //         setState(() {});
            //       },
            //     )
            //   ],
            // ),
            // 1.h.addHSpace(),
            Row(
              children: [
                "Biometric Lock"
                    .semiOpenSans(fontColor: Colors.black, fontSize: 12.sp),
                const Spacer(),
                Switch(
                  value: biometricLock,
                  activeTrackColor: appColor,
                  inactiveTrackColor: lightPurple,
                  onChanged: (value) async {
                    if (value == true) {
                      bool a = await LocalAuthApi.hasBiometrics();
                      if (a == true) {
                        biometricLock = value;
                        setState(() {});
                        LocalStorage.sendBiometric(bio: biometricLock);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Biometric Lock Is Not Enable")));
                      }
                    } else {
                      biometricLock = value;
                      setState(() {});
                      LocalStorage.sendBiometric(bio: biometricLock);
                    }
                  },
                )
              ],
            ),
            1.h.addHSpace(),
            1.0.appDivider(color: Colors.grey),
            1.h.addHSpace(),
            1.h.addHSpace(),
            "Strong Passwords:"
                .semiOpenSans(fontSize: 12.sp, fontColor: Colors.black),
            1.h.addHSpace(),
            " Create strong and unique passwords for your Home Hub account and all your smart home devices. Avoid using easily guessable information like birthdays or pet names. Consider using a password manager to generate and store strong passwords."
                .mediumOpenSans(fontSize: 11.sp, fontColor: Colors.black),
            2.h.addHSpace(),
            "Multi-Factor Authentication (MFA):"
                .semiOpenSans(fontSize: 12.sp, fontColor: Colors.black),
            1.h.addHSpace(),
            "Enable multi-factor authentication whenever possible. This adds an extra layer of security by requiring a second verification step, such as a code sent to your phone, in addition to your password."
                .mediumOpenSans(fontSize: 11.sp, fontColor: Colors.black),
            2.h.addHSpace(),
          ],
        ).paddingSymmetric(horizontal: 2.w),
      ),
    );
  }
}
