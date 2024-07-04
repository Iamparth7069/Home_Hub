import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:home_hub/%20ui/service_manage/service_manage_controller.dart';
import 'package:home_hub/utils/extension.dart';
import 'package:sizer/sizer.dart';
import '../../constant/app_color.dart';
import '../../models/services.dart';
import '../ServiceProfider/services_provider.dart';

class ServiceManege extends StatelessWidget {
  ServiceManege({super.key});
  ServiceManageController serviceScreenController =
      Get.put(ServiceManageController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "All Services"
            .boldOpenSans(fontColor: Colors.black, fontSize: 14.sp),
        bottom: PreferredSize(
            preferredSize: Size(100.w, 7.h),
            child: Expanded(
                child: TextFormField(
              decoration: InputDecoration(
                  prefixIcon: SvgPicture.asset(
                    "assets/images/svg/search.svg",
                    height: 20,
                  ).paddingAll(17),
                  suffixIcon: SvgPicture.asset(
                    "assets/images/svg/settings-sliders.svg",
                    height: 20,
                    color: appColor,
                  ).paddingAll(17),
                  fillColor: const Color(0xfff5f5f5),
                  filled: true,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  hintText: "Search..",
                  hintStyle: TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 11.sp,
                      color: greyColor)),
              controller: serviceScreenController.search,
              onChanged: (value) {
                if (value.length >= 1) {
                  serviceScreenController.getSearchServices(searchValue: value);
                  serviceScreenController.setSearchValue(value: true);
                } else {
                  serviceScreenController.setSearchValue(value: false);
                }
              },
            ))),
      ),
      body: SafeArea(
        child: GetBuilder<ServiceManageController>(
          builder: (controller) {
            List<Services> serviceData = [];
            if (controller.isSearch == true) {
              serviceData.clear();
              serviceData = controller.searchServices;
            } else {
              serviceData.clear();
              serviceData = controller.allServices;
            }
            return serviceData.isEmpty
                ? Center(
                    child: "Opps! No Data Found"
                        .boldOpenSans(fontColor: Colors.black))
                : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: serviceData.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: SizedBox(
                                width: 100.w,
                                height: 8.h,
                                child: Center(
                                  child: ListTile(
                                    onTap: () {
                                      Get.to(Service_Provider(
                                          serviceData[index].servicesName));
                                    },
                                    leading: Container(
                                      width: 45,
                                      height: 45,
                                      decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              serviceData[index].images ?? "",
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    title: Row(
                                      children: [
                                        serviceData[index]
                                            .servicesName
                                            .semiOpenSans(
                                                fontColor: Colors.black,
                                                fontSize: 12.sp),
                                        const Spacer(),
                                        const Icon(Icons.chevron_right),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ).paddingOnly(top: 1.h);
                          },
                        ),
                      )
                    ],
                  ).paddingSymmetric(horizontal: 2.w);
          },
        ),
      ),
    );
  }
}
