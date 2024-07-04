import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:home_hub/%20ui/Booking%20Screen/booking_screen.dart';
import 'package:home_hub/%20ui/Chat%20Screen/messege_screen.dart';
import 'package:home_hub/%20ui/Home/home_screen.dart';
import 'package:home_hub/%20ui/bottom%20nav%20bar/bottom_nav_bar_controller.dart';
import 'package:home_hub/%20ui/profile%20Screens/profile_Screen.dart';
import 'package:home_hub/constant/app_color.dart';
import 'package:sizer/sizer.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  BottomNavBarController bottomNavBarController =
      Get.put(BottomNavBarController());
  List<Map<String, String>> iconList = [
    {
      "unselectedIcon": "assets/images/svg/home.svg",
      "selectedIcon": "assets/images/svg/home_fill.svg",
      "label": "Home"
    },
    {
      "unselectedIcon": "assets/images/svg/memo.svg",
      "selectedIcon": "assets/images/svg/memo_fill.svg",
      "label": "Bookings"
    },
    {
      "unselectedIcon": "assets/images/svg/messages.svg",
      "selectedIcon": "assets/images/svg/messages_fill.svg",
      "label": "Inbox"
    },
    {
      "unselectedIcon": "assets/images/svg/user.svg",
      "selectedIcon": "assets/images/svg/user_fill.svg",
      "label": "Profile"
    },
  ];
  List screens = [
    const HomeScreen(),
    const BookingScreen(),
    const MessegeScreen(),
    ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return GetBuilder<BottomNavBarController>(
      builder: (controller) {
        return Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: controller.selectedPage,
            showUnselectedLabels: true,
            onTap: (value) {
              controller.setSelectedPage(value: value);
            },
            selectedItemColor: appColor,
            unselectedItemColor: Colors.grey,
            unselectedLabelStyle:
                TextStyle(color: Colors.grey, fontSize: 12.sp),
            items: List.generate(
              4,
              (index) => BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  iconList[index]["unselectedIcon"]!,
                  width: 20,
                  color: Colors.grey,
                ),
                label: iconList[index]["label"]!,
                activeIcon: SvgPicture.asset(
                  iconList[index]["selectedIcon"]!,
                  width: 20,
                  color: appColor,
                ),
                backgroundColor: Colors.white,
              ),
            ),
          ),
          body: screens[controller.selectedPage],
        );
      },
    );
  }
}
