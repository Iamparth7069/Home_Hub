import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:home_hub/%20ui/ServiceProfider/services_provider_constroller.dart';
import 'package:home_hub/firebase%20services/count_service.dart';
import 'package:home_hub/utils/extension.dart';
import 'package:sizer/sizer.dart';

import '../../Response Model/service_res_model.dart';
import '../../constant/app_color.dart';
import '../../utils/app_routes.dart';
import '../Widgets/service_layout.dart';

class Service_Provider extends StatefulWidget {
  String ServiceName;

  Service_Provider(this.ServiceName);

  @override
  State<Service_Provider> createState() => _Service_ProviderState();
}

class _Service_ProviderState extends State<Service_Provider> {
  bool _isLoading = true;
  bool _showNoData = false;
  @override
  void initState() {
    super.initState();
    // Simulating a 2-second delay before showing "No data found"
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
        _showNoData = true;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ServiceProviderController _serviceProviderController =
        Get.put(ServiceProviderController(widget.ServiceName));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.ServiceName}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        bottom: PreferredSize(
            preferredSize: Size(100.w, 7.h),
            child: Expanded(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13),
              child: TextFormField(
                controller: _serviceProviderController.search,
                onChanged: (value) {
                  if (value.length >= 1) {
                    print(value);
                    _serviceProviderController.getSearchServices(
                        searchValue: value);
                    _serviceProviderController.setSearchValue(value: true);
                  } else {
                    _serviceProviderController.setSearchValue(value: false);
                  }
                },
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
              ),
            ))),
      ),
      body: GetBuilder<ServiceProviderController>(
        builder: (controller) {
          List<ServiceResponseModel> serviceData = [];
          if (controller.isSearch == true) {
            serviceData.clear();
            serviceData = controller.searchServices;
          } else {
            serviceData.clear();
            serviceData = controller.services;
          }
          return controller.services.isEmpty
              ? Center(
                  child: _isLoading
                      ? SingleChildScrollView(
                          child: Column(
                          children: List.generate(
                              10,
                              (index) => loadingEffect(
                                      width: 100.w, height: 20.h, radius: 10)
                                  .paddingSymmetric(
                                      horizontal: 2.w, vertical: 1.h)),
                        ))
                      : Visibility(
                          visible: _showNoData,
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Spacer(),
                              Text("No data found"),
                              Spacer(),
                            ],
                          ),
                        ),
                )
              : serviceData.isEmpty
                  ? Center(
                      child: "Opps! No Data Found"
                          .boldOpenSans(fontColor: Colors.black))
                  : SingleChildScrollView(
                      child: Column(
                        children: List.generate(
                            serviceData.length,
                            (index) => GestureDetector(
                                onTap: () {
                                  CountService.setCounting(
                                      serviceProviderId:
                                          controller.services[index].userId);
                                  Get.toNamed(Routes.serviceDetailScreen,
                                      arguments: controller.services[index]);
                                },
                                child: ServiceContainer(
                                  serviceResponseModel: serviceData[index],
                                ).paddingOnly(bottom: 3.h))),
                      ),
                    );
        },
      ),
    );
  }
}
