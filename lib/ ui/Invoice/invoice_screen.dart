import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_hub/Response%20Model/order_res_model.dart';
import 'package:home_hub/Response%20Model/service_provider_res_model.dart';
import 'package:home_hub/Response%20Model/service_res_model.dart';
import 'package:home_hub/Response%20Model/user_res_model.dart';
import 'package:home_hub/utils/extension.dart';
import 'package:home_hub/utils/local_storage.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:sizer/sizer.dart';

class InvoiceScreen extends StatefulWidget {
  @override
  _InvoiceScreenState createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();

  // Function to capture and share the screenshot
  void _shareInvoice() async {
    try {
      // Capture screenshot
      Uint8List? bytes = await _capturePng();

      // Check if bytes is not null
      if (bytes != null) {
        // Save the image to device temporarily
        final tempDir = await getTemporaryDirectory();
        final file = await new File('${tempDir.path}/invoice.png').create();
        await file.writeAsBytes(bytes);

        // Share screenshot
        Share.shareFiles([file.path], text: 'Invoice');
      } else {
        print('Error capturing screenshot: bytes is null');
      }
    } catch (e) {
      print('Error sharing invoice: $e');
    }
  }

  // Function to capture screenshot
  Future<Uint8List?> _capturePng() async {
    try {
      Uint8List? pngBytes = await _screenshotController.capture();

      return pngBytes;
    } catch (e) {
      print('Error capturing screenshot: $e');
      return null;
    }
  }

  UserResModel? userResModel = Get.arguments['userData'];
  ServiceResponseModel serviceResponseModel = Get.arguments['serviceData'];
  OrderResModel orderResModel = Get.arguments['orderDetails'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice'),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: _shareInvoice,
          ),
        ],
      ),
      body: Center(
        child: Screenshot(
          controller: _screenshotController,
          child: _buildInvoice(
              userResModel: userResModel,
              orderResModel: orderResModel,
              serviceResponseModel:
                  serviceResponseModel), // Your invoice widget
        ),
      ),
    );
  }

  // Function to build invoice widget
  Widget _buildInvoice(
      {UserResModel? userResModel,
      required OrderResModel orderResModel,
      required ServiceResponseModel serviceResponseModel}) {
    return Container(
      height: 100.h,
      width: 100.w,
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                  height: 10.h,
                  child: Image.asset("assets/images/app_logo.png")),
              5.w.addWSpace(),
              "Home Hub".boldOpenSans(fontColor: Colors.black, fontSize: 16.sp),
            ],
          ),
          3.h.addHSpace(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  "${userResModel!.firstName} ${userResModel!.lastName}"
                      .boldOpenSans(fontColor: Colors.black, fontSize: 12.sp),
                  1.h.addHSpace(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      "Mo. :- ".boldOpenSans(
                          textOverflow: TextOverflow.ellipsis,
                          fontColor: Colors.black,
                          fontSize: 11.sp),
                      SizedBox(
                        width: 20.w,
                        child: "${userResModel.phoneNumber}".semiOpenSans(
                            maxLines: 2,
                            textOverflow: TextOverflow.ellipsis,
                            fontColor: Colors.black,
                            fontSize: 10.sp),
                      ),
                    ],
                  ),
                  1.h.addHSpace(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      "Address :- ".boldOpenSans(
                          textOverflow: TextOverflow.ellipsis,
                          fontColor: Colors.black,
                          fontSize: 11.sp),
                      SizedBox(
                        width: 40.w,
                        child: "${userResModel.address}".semiOpenSans(
                            maxLines: 2,
                            textOverflow: TextOverflow.ellipsis,
                            fontColor: Colors.black,
                            fontSize: 10.sp),
                      ),
                    ],
                  ),
                ],
              ),
              Spacer(),
              DateFormat("MMMM dd, yyyy")
                  .format(DateTime.now())
                  .semiOpenSans(fontColor: Colors.black, fontSize: 10.sp),
            ],
          ),
          3.h.addHSpace(),
          2.0.appDivider(color: Colors.grey),
          Row(
            children: [
              Container(
                height: 45.h,
                width: 21.w,
                child: Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: [
                        "Date".boldOpenSans(
                            fontColor: Colors.black, fontSize: 12.sp),
                        1.h.addHSpace(),
                        DateFormat("dd/mm/yyyy")
                            .format(orderResModel.completeDate!)
                            .semiOpenSans(
                                fontColor: Colors.black, fontSize: 11.sp),
                      ],
                    )),
              ),
              0.5.w.addWSpace(),
              Container(
                height: 45.h,
                width: 0.5.w,
                color: Colors.black,
              ),
              0.5.w.addWSpace(),
              Expanded(
                child: Container(
                    height: 45.h,
                    child: Align(
                        alignment: Alignment.topCenter,
                        child: Column(
                          children: [
                            "Service Name".boldOpenSans(
                                fontColor: Colors.black, fontSize: 12.sp),
                            1.h.addHSpace(),
                            "${serviceResponseModel.serviceName}".semiOpenSans(
                                fontColor: Colors.black, fontSize: 11.sp),
                          ],
                        ))),
              ),
              0.5.w.addWSpace(),
              Container(
                height: 45.h,
                width: 0.5.w,
                color: Colors.black,
              ),
              0.5.w.addWSpace(),
              Container(
                height: 45.h,
                width: 22.w,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Align(
                      alignment: Alignment.topCenter,
                      child: Column(
                        children: [
                          "Amount".boldOpenSans(
                              fontColor: Colors.black, fontSize: 12.sp),
                          1.h.addHSpace(),
                          "₹ ${orderResModel.amount}".semiOpenSans(
                              fontColor: Colors.black, fontSize: 11.sp),
                        ],
                      )),
                ),
              ),
              0.5.w.addWSpace(),
              Container(
                height: 45.h,
                width: 0.5.w,
                color: Colors.black,
              ),
            ],
          ),
          2.0.appDivider(color: Colors.black),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              "Total :- "
                  .boldOpenSans(fontSize: 12.sp, fontColor: Colors.black),
              4.w.addWSpace(),
              "₹ ${orderResModel.amount}"
                  .boldOpenSans(fontSize: 12.sp, fontColor: Colors.black),
              4.w.addWSpace(),
            ],
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              "support.homehub@gmail.com "
                  .mediumOpenSans(fontSize: 10.sp, fontColor: Colors.black),
              "tel :- 70214151515"
                  .mediumOpenSans(fontSize: 10.sp, fontColor: Colors.black),
            ],
          ),
        ],
      ),
    );
  }
}
