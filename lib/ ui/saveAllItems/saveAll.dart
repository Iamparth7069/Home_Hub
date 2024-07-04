import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_hub/%20ui/saveAllItems/saveAllItemController.dart';

import '../../firebase services/count_service.dart';
import '../../utils/app_routes.dart';
import '../Widgets/service_layout.dart';

class SaveAllItems extends StatelessWidget {
  SaveAllItems({Key? key}) : super(key: key);

  final SavedListController _controller = Get.put(SavedListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "All Saved Item",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
        ),
      ),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }else if (_controller.documents.isEmpty) {
          return Center(
            child: Text("No saved items found"),
          );
        } else {
          return RefreshIndicator(
            onRefresh: _controller.loadSavedItem,
            child: ListView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount: _controller.documents.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    CountService.setCounting(
                        serviceProviderId: _controller
                            .documents[index].userId);
                    Get.toNamed(
                        Routes.serviceDetailScreen,
                        arguments: _controller
                            .documents[index]);
                  },
                  child: ServiceContainer(
                    serviceResponseModel: _controller.documents[index],
                  ),
                );
              },
            ),
          );
        }
      }),
    );
  }
}
