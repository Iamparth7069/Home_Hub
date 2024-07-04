import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_hub/%20ui/Payment%20Screen/payment_controller.dart';
import 'package:home_hub/Response%20Model/offer_res_model.dart';
import 'package:home_hub/Response%20Model/service_provider_res_model.dart';
import 'package:home_hub/utils/extension.dart';
import 'package:sizer/sizer.dart';


class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  PaymentController paymentController = Get.put(PaymentController());
  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (context) {
        return Container(
          width: 100.w,
          height: 50.h,
          color: Colors.red,
        );
      },
    );
  }
}