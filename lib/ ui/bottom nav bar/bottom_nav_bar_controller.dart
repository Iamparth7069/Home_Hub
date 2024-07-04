import 'package:get/get.dart';

class BottomNavBarController extends GetxController {
  int selectedPage = 0;

  void setSelectedPage({required int value}) {
    selectedPage = value;
    update();
  }
}
