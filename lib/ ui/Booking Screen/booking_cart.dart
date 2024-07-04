import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:home_hub/%20ui/Chat%20Screen/Widget/messege_container.dart';
import 'package:home_hub/Response%20Model/order_res_model.dart';
import 'package:home_hub/Response%20Model/service_provider_res_model.dart';
import 'package:home_hub/Response%20Model/service_res_model.dart';
import 'package:home_hub/Response%20Model/user_res_model.dart';
import 'package:home_hub/constant/app_color.dart';
import 'package:home_hub/firebase%20services/notification_service.dart';
import 'package:home_hub/firebase%20services/repo.dart';
import 'package:home_hub/utils/app_routes.dart';
import 'package:home_hub/utils/extension.dart';
import 'package:home_hub/utils/local_storage.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class BookingCart extends StatefulWidget {
  const BookingCart(
      {super.key,
      required this.statusColor,
      required this.status,
      this.onCancleTap,
      required this.serviceProviderRes,
      required this.orderResModel,
      required this.serviceResponseModel});
  final Color statusColor;
  final String status;
  final ServiceProviderRes serviceProviderRes;
  final OrderResModel orderResModel;
  final ServiceResponseModel serviceResponseModel;
  final onCancleTap;
  @override
  State<BookingCart> createState() => _BookingCartState();
}

class _BookingCartState extends State<BookingCart> {
  bool isExpand = false;
  UserResModel? userData;
  bool isReviewed = false;
  Future<bool> checkReview() async {
    try {
      DocumentSnapshot dd = await servicesCollection
          .doc(widget.serviceResponseModel.serviceIds)
          .collection("ratings")
          .doc(widget.orderResModel.orderId)
          .get();
      if (dd.exists) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  getUserData() async {
    userData = await LocalStorage.getUserData();
    isReviewed = await checkReview();
  }

  @override
  Widget build(BuildContext context) {
    final OrderResModel orderResModel = widget.orderResModel;
    final ServiceProviderRes serviceProviderRes = widget.serviceProviderRes;
    final ServiceResponseModel serviceResponseModel =
        widget.serviceResponseModel;
    return Container(
      width: 100.w,
      height: isExpand ? 45.h : 25.h,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          2.h.addHSpace(),
          SizedBox(
            // Adjust the height based on screen height
            child: Row(
              children: [
                Container(
                  height: 12.h,
                  width: 12.h,
                  decoration: BoxDecoration(
                    color: lightPurple,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: serviceResponseModel.images[0],
                    ),
                  ),
                ),
                3.w.addWSpace(),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${orderResModel.serviceName}",
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: blackColor,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        "${serviceProviderRes.fname} ${serviceProviderRes.lname}",
                        style: TextStyle(
                          fontSize: 10.5.sp,
                          color: Colors.grey,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: widget.statusColor,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Text(
                          widget.status,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.sp,
                          ),
                        ).paddingSymmetric(
                          horizontal: 16, // Adjusted padding
                          vertical: 8, // Adjusted padding
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    String myUid = await LocalStorage.getUserId();
                    Get.toNamed(Routes.chatScreen, arguments: {
                      "roomId": "$myUid-${serviceProviderRes.Uid}",
                      "userName":
                          "${serviceProviderRes.fname} ${serviceProviderRes.lname}",
                      "userId": "${serviceProviderRes.Uid}",
                      "serviceProviderRes": serviceProviderRes,
                    });
                  },
                  child: CircleAvatar(
                    radius: 22,
                    backgroundColor: const Color(0xfff1e7ff),
                    child: Center(
                      child: SvgPicture.asset(
                        "assets/images/svg/messages_fill.svg",
                        width: 16,
                        color: appColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          2.5.h.addHSpace(),
          1.5.appDivider(color: greyColor.withOpacity(0.3)),
          if (isExpand)
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                1.h.addHSpace(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    "Date & Time".mediumOpenSans(
                        fontColor: Colors.grey, fontSize: 10.sp),
                    DateFormat('MMM d.yyyy')
                        .format(orderResModel.completeDate ?? DateTime.now())
                        .semiOpenSans(fontSize: 11.sp, fontColor: Colors.black)
                  ],
                ),
                1.h.addHSpace(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    "Location".mediumOpenSans(
                        fontColor: Colors.grey, fontSize: 10.sp),
                    SizedBox(
                      width: 50.w,
                      child: "${orderResModel.address}".semiOpenSans(
                          fontSize: 11.sp,
                          textOverflow: TextOverflow.ellipsis,
                          fontColor: Colors.black,
                          maxLines: 2),
                    )
                  ],
                ),
                4.h.addHSpace(),
                Row(
                  children: [
                    widget.status == "Pending" || widget.status == "Accepted"
                        ? Expanded(
                            child: GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  isDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return SizedBox(
                                      height: 40.h,
                                      width: 100.w,
                                      child: Column(
                                        children: [
                                          3.0
                                              .appDivider(
                                                  color: greyColor
                                                      .withOpacity(0.4))
                                              .paddingSymmetric(
                                                  horizontal: 35.w),
                                          2.h.addHSpace(),
                                          "Cancel Booking".boldOpenSans(
                                            fontSize: 13.sp,
                                            fontColor: const Color(0xfff75555),
                                          ),
                                          2.h.addHSpace(),
                                          2.0.appDivider(
                                              color:
                                                  greyColor.withOpacity(0.2)),
                                          2.h.addHSpace(),
                                          "Are you sure want to cancel your\nservice booking?"
                                              .boldOpenSans(
                                                  fontColor: Colors.black,
                                                  fontSize: 14.sp,
                                                  textAlign: TextAlign.center),
                                          1.h.addHSpace(),
                                          "Only 80% of the money you can refund from\nyour payment according to our policy"
                                              .mediumOpenSans(
                                                  fontColor: Colors.black
                                                      .withOpacity(0.9),
                                                  fontSize: 10.sp,
                                                  textAlign: TextAlign.center),
                                          2.h.addHSpace(),
                                          2.0.appDivider(
                                              color:
                                                  greyColor.withOpacity(0.2)),
                                          const Spacer(),
                                          Row(
                                            children: [
                                              Expanded(
                                                  flex: 2,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Get.back();
                                                    },
                                                    child: Container(
                                                      height: 6.2.h,
                                                      decoration: BoxDecoration(
                                                        color: const Color(
                                                            0xfff0e6ff),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                      ),
                                                      child: Center(
                                                        child: "Cancel"
                                                            .boldOpenSans(
                                                          fontSize: 11.sp,
                                                          fontColor: blueColor,
                                                        ),
                                                      ),
                                                    ),
                                                  )),
                                              2.w.addWSpace(),
                                              Expanded(
                                                  flex: 3,
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                      Map<String, dynamic>
                                                          emptyMap = {};
                                                      UserResModel user =
                                                          await LocalStorage
                                                              .getUserData();
                                                      await orderCollection
                                                          .doc(orderResModel
                                                              .orderId)
                                                          .update({
                                                        "status": "Cancelled"
                                                      });
                                                      Get.back();
                                                      DocumentReference dd =
                                                          await paymentRequest
                                                              .add(emptyMap);
                                                      String myUid =
                                                          await LocalStorage
                                                              .getUserId();
                                                      await paymentRequest
                                                          .doc(dd.id)
                                                          .set({
                                                        "userId": myUid,
                                                        "amount": orderResModel
                                                            .amount,
                                                        "date": DateTime.now(),
                                                        "type": "Refund",
                                                        "orderId": orderResModel
                                                            .orderId
                                                      });

                                                      NotificationService.sendMessage(
                                                          receiverFcmToken:
                                                              serviceProviderRes
                                                                  .fcmToken,
                                                          title:
                                                              "Your Order Is Cancelled",
                                                          msg:
                                                              "Your order From ${user.firstName} was Cancelled");
                                                    },
                                                    child: Container(
                                                      height: 6.2.h,
                                                      decoration: BoxDecoration(
                                                          color: blueColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      50)),
                                                      child: Center(
                                                        child: "Yes, Cancel Booking"
                                                            .boldOpenSans(
                                                                fontSize: 11.sp,
                                                                fontColor: Colors
                                                                    .white
                                                                    .withOpacity(
                                                                        0.9)),
                                                      ),
                                                    ),
                                                  )),
                                            ],
                                          ),
                                          5.w.addHSpace()
                                        ],
                                      ).paddingSymmetric(horizontal: 7.w),
                                    );
                                  },
                                );
                              },
                              child: Center(
                                child: Container(
                                  height: 5.h,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: appColor.withOpacity(0.8)),
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Center(
                                    child: "Cancel Booking".semiOpenSans(
                                        fontColor: appColor.withOpacity(0.8),
                                        fontSize: 11.sp),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(),
                    widget.status == "Pending" || widget.status == "Accepted"
                        ? 5.0.addWSpace()
                        : 0.0.addWSpace(),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          ///Code For Bill
                          ///
                          Get.toNamed(Routes.invoiceScreen, arguments: {
                            "orderDetails": orderResModel,
                            "serviceData": serviceResponseModel,
                            "userData": userData
                          });
                        },
                        child: Center(
                          child: Container(
                            height: 5.h,
                            decoration: BoxDecoration(
                                color: appColor.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(50)),
                            child: Center(
                              child: "View E-Receipt".semiOpenSans(
                                  fontColor: whiteColor.withOpacity(0.9),
                                  fontSize: 11.sp),
                            ),
                          ),
                        ),
                      ),
                    ),
                    widget.status == "Completed"
                        ? 5.0.addWSpace()
                        : 0.0.addWSpace(),
                    //&& isReviewed == false
                    //                         ?
                    widget.status == "Completed" && isReviewed == false
                        ? Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Get.toNamed(Routes.reviewScreen, arguments: {
                                  "orderDetails": orderResModel,
                                  "serviceProvider": serviceProviderRes,
                                  "serviceRes": serviceResponseModel
                                });
                              },
                              child: Center(
                                child: Container(
                                  height: 5.h,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: appColor.withOpacity(0.8)),
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Center(
                                    child: "Review".semiOpenSans(
                                        fontColor: appColor.withOpacity(0.8),
                                        fontSize: 11.sp),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ],
                ).paddingSymmetric(horizontal: 2.5.w),
              ],
            ),
          Center(
            child: IconButton(
              highlightColor: Colors.transparent,
              onPressed: () {
                setState(() {
                  isExpand = !isExpand;
                });
              },
              icon: SvgPicture.asset(
                isExpand
                    ? "assets/images/svg/angle-up.svg"
                    : "assets/images/svg/angle-down.svg",
                width: isExpand ? 6.w : 4.w,
              ),
            ),
          ),
          const Spacer(),
        ],
      ).paddingSymmetric(
        horizontal: 2.w,
      ),
    );
  }
}
