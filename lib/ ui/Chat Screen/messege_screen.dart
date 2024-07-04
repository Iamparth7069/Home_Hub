import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_hub/%20ui/Chat%20Screen/chat_Screen_controller.dart';
import 'package:home_hub/Response%20Model/chat_room_res_model.dart';
import 'package:home_hub/Response%20Model/service_provider_res_model.dart';
import 'package:home_hub/utils/app_routes.dart';
import 'package:home_hub/utils/date_helper.dart';
import 'package:home_hub/utils/extension.dart';
import 'package:sizer/sizer.dart';

class MessegeScreen extends StatefulWidget {
  const MessegeScreen({super.key});

  @override
  State<MessegeScreen> createState() => _MessegeScreenState();
}

class _MessegeScreenState extends State<MessegeScreen> {
  ChatScreenController chatScreenController = Get.find<ChatScreenController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: GetBuilder<ChatScreenController>(
          builder: (controller) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Messages",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 10,
                              color: Colors.black12)
                        ]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextFormField(
                              onChanged: (value) {
                                if (value.length == 0) {
                                  controller.setSerchedValue(value: false);
                                } else {
                                  controller.setSerchedValue(value: true);
                                  controller.getSearchedData(
                                      value: value.toLowerCase());
                                }
                              },
                              decoration: const InputDecoration(
                                  hintText: "Search", border: InputBorder.none),
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.search,
                          color: Color(0xFF7165D6),
                        )
                      ],
                    ),
                  ),
                ),
                3.5.h.addHSpace(),
                controller.isSearch == true &&
                        controller.searchedChatRoom.length == 0
                    ? Center(
                        child: "No Search Data Found"
                            .semiOpenSans(fontColor: Colors.black),
                      )
                    : controller.chatRoom.length == 0
                        ? Center(
                            child: "No Data Found"
                                .semiOpenSans(fontColor: Colors.black),
                          )
                        : ListView.separated(
                            padding: EdgeInsets
                                .zero, // Add this line to remove top padding
                            separatorBuilder: (context, index) {
                              return Container(
                                height: 1.h,
                              );
                            },
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: controller.isSearch == true
                                ? controller.searchedChatRoom.length
                                : controller.chatRoom.length,
                            //images.length,
                            itemBuilder: (context, index) {
                              ServiceProviderRes serviceProviderRes =
                                  controller.isSearch == true
                                      ? controller
                                          .searchedChatRoomUserData[index]
                                      : controller.chatRoomUserData[index];
                              ChatRoomResModel chatRoom =
                                  controller.isSearch == true
                                      ? controller.searchedChatRoom[index]
                                      : controller.chatRoom[index];
                              return ListTile(
                                onTap: () {
                                  Get.toNamed(Routes.chatScreen, arguments: {
                                    "roomId": chatRoom.docId,
                                    "userName":
                                        "${serviceProviderRes.fname} ${serviceProviderRes.lname}",
                                    "userId": serviceProviderRes.Uid,
                                    "serviceProviderRes": serviceProviderRes,
                                  });
                                },
                                leading: Container(
                                  height: 90,
                                  width: 55,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: Colors.red),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: controller.chatRoomUserData[index]
                                                .Images ==
                                            ""
                                        ? Image.asset(
                                            "assets/images/profile_image.jpg",
                                            fit: BoxFit.fill,
                                          )
                                        : CachedNetworkImage(
                                            fit: BoxFit.fill,
                                            imageUrl:
                                                serviceProviderRes.Images),
                                  ),
                                ),
                                title: Text(
                                  "${serviceProviderRes.fname} ${serviceProviderRes.lname}",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  "${chatRoom.LastChat}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                                trailing: Text(
                                  "${DateFormatUtil.formatTimeAgo(chatRoom.lastChatTime)}",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black54),
                                ),
                              );
                            },
                          ),
              ],
            );
          },
        ),
      ),
    );
  }
}
