import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_hub/%20ui/Transection%20Screen/transaction_screen_controller.dart';
import 'package:home_hub/utils/extension.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class TransectionScreen extends StatefulWidget {
  const TransectionScreen({super.key});

  @override
  State<TransectionScreen> createState() => _TransectionScreenState();
}

class _TransectionScreenState extends State<TransectionScreen> {
  TransactionScreenController transactionScreenController =
      Get.put(TransactionScreenController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Transactions"
            .boldOpenSans(fontColor: Colors.black, fontSize: 14.sp),
      ),
      body: GetBuilder<TransactionScreenController>(
        builder: (controller) {
          return controller.isLoading == true
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : controller.myData.isEmpty
                  ? Center(
                      child: "No Transaction Found"
                          .semiOpenSans(fontColor: Colors.black),
                    )
                  : ListView.builder(
                      itemCount: controller.myData.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: controller.myData[index].type == "Payment"
                              ? "Sent to ${controller.userData[index]!.fname} ${controller.userData[index]!.lname}"
                                  .boldOpenSans(
                                      fontSize: 12.sp, fontColor: Colors.black)
                              : "Received".boldOpenSans(
                                  fontSize: 12.sp, fontColor: Colors.black),
                          subtitle:
                              "${DateFormat('d MMM yyyy, HH:mm a').format(controller.myData[index].time)}"
                                  .mediumOpenSans(
                                      fontSize: 9.sp,
                                      fontColor: Colors.black26),
                          trailing: controller.myData[index].type == "Payment"
                              ? "- ₹${controller.myData[index].amount}"
                                  .boldOpenSans(
                                      fontSize: 12.5.sp, fontColor: Colors.red)
                              : "+ ₹${controller.myData[index].amount}"
                                  .boldOpenSans(
                                      fontSize: 12.5.sp,
                                      fontColor: Colors.green),
                        );
                      },
                    );
        },
      ),
    );
  }
}
