import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_hub/%20ui/Service%20Details/service_detail_screen.dart';
import 'package:home_hub/%20ui/Service%20Details/service_detail_screen_controller.dart';
import 'package:home_hub/utils/extension.dart';
import 'package:rating_summary/rating_summary.dart';
import 'package:sizer/sizer.dart';

class ShowReviewScreen extends StatefulWidget {
  const ShowReviewScreen({super.key});

  @override
  State<ShowReviewScreen> createState() => _ShowReviewScreenState();
}

class _ShowReviewScreenState extends State<ShowReviewScreen> {
  @override
  Widget build(BuildContext context) {
    ServiceDetailController serviceDetailController =
        Get.find<ServiceDetailController>();
    return Scaffold(
      appBar: AppBar(
        title: "Review".boldOpenSans(fontColor: Colors.black, fontSize: 14.sp),
      ),
      body: GetBuilder<ServiceDetailController>(
        builder: (controller) {
          return SafeArea(
            child: controller.allRatings.isEmpty
                ? Center(
                    child: "No Review Found"
                        .semiOpenSans(fontColor: Colors.black, fontSize: 11.sp),
                  )
                : Column(
                    children: [
                      3.h.addHSpace(),
                      RatingSummary(
                        counter: controller.total,
                        average: controller.totalReview / controller.total,
                        showAverage: true,
                        counterFiveStars: controller.fiveStarRatings.length,
                        counterFourStars: controller.fourStarRatings.length,
                        counterThreeStars: controller.threeStarRatings.length,
                        counterTwoStars: controller.twoStarRatings.length,
                        counterOneStars: controller.oneStarRatings.length,
                      ),
                      4.h.addHSpace(),
                      Expanded(
                          child: ListView.builder(
                        itemCount: controller.allRatings.length,
                        itemBuilder: (context, index) {
                          return reviewContainer(
                              ratingResModel: controller.allRatings[index]);
                        },
                      ))
                    ],
                  ).paddingSymmetric(horizontal: 2.w),
          );
        },
      ),
    );
  }
}
