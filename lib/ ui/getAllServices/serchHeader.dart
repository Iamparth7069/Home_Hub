import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'getAllServicesController.dart';

class SearchHeaderDelegate extends SliverPersistentHeaderDelegate {
  final bool showSearchOptions;
  final VoidCallback onDragDown;

  SearchHeaderDelegate({
    required this.showSearchOptions,
    required this.onDragDown,
  });
  final GetAllServicesController getAllServicesController = Get.find<GetAllServicesController>();

  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent,
      ) {
    return GetBuilder<GetAllServicesController>(
      builder: (controller) {
        return GestureDetector(
          onVerticalDragDown: (_) => onDragDown(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            color: Colors.white,
            height: maxExtent, // Set height to maxExtent
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  TextFormField(
                    onChanged: (value) {
                      if (value.length >= 1) {
                        getAllServicesController.getSearchMesseges(searchValue: value.trim());
                        getAllServicesController.setSearchValue(value: true);
                      } else {
                        getAllServicesController.setSearchValue(value: false);
                      }
                    },
                    decoration: InputDecoration(
                      hintText: "Search",
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.search,
                        color: Color(0xFF7165D6),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  double get maxExtent => 56.0;

  @override
  double get minExtent => 56.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
