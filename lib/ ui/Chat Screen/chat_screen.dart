import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get.dart';
import 'package:home_hub/%20ui/Chat%20Screen/Widget/messege_container.dart';
import 'package:home_hub/%20ui/Chat%20Screen/chat_Screen_controller.dart';
import 'package:home_hub/Response%20Model/offer_res_model.dart';
import 'package:home_hub/Response%20Model/service_provider_res_model.dart';
import 'package:home_hub/Response%20Model/text_chat_res_model.dart';
import 'package:home_hub/constant/app_color.dart';
import 'package:home_hub/firebase%20services/CHAT_SERVICE.dart';
import 'package:home_hub/firebase%20services/notification_service.dart';
import 'package:home_hub/firebase%20services/repo.dart';
import 'package:home_hub/utils/extension.dart';
import 'package:home_hub/utils/local_storage.dart';
import 'package:sizer/sizer.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ChatScreenController chatScreenController = Get.find<ChatScreenController>();
  TextEditingController textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String roomId = Get.arguments["roomId"];
  String userName = Get.arguments["userName"];
  String userId = Get.arguments["userId"];
  ServiceProviderRes serviceProviderRes = Get.arguments["serviceProviderRes"];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            GestureDetector(
              onTap: () async {
                bool? res = await FlutterPhoneDirectCaller.callNumber(
                    serviceProviderRes.contectnumber);
              },
              child: Image.asset(
                "assets/images/telephone.png",
                height: 22,
              ),
            ),
            2.h.addWSpace(),
          ],
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_outlined),
            onPressed: () {
              chatScreenController.getAllRoomData();
              Get.back();
            },
          ),
          title: "${serviceProviderRes.fname} ${serviceProviderRes.lname}"
              .boldOpenSans(fontColor: Colors.black),
        ),
        body: SafeArea(
          child: StreamBuilder(
            stream: chatRoomCollection
                .doc(roomId)
                .collection("messages")
                .orderBy("createdAt", descending: false)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                    child:
                        CircularProgressIndicator()); // Loading indicator or placeholder
              }
              final chatDocs = snapshot.data?.docs ?? [];

              return ListView.builder(
                controller: _scrollController,
                itemCount: chatDocs.length,
                itemBuilder: (context, index) {
                  bool isMe = false;
                  TextChatResModel? textChatResModel;
                  OfferResModel? offerResModel;
                  final chatData = chatDocs[index].data();
                  if (chatData["msgType"] == "offers") {
                    offerResModel = OfferResModel.fromMap(chatData);
                    return offerContainer(
                        offerResModel: offerResModel,
                        offerId: chatDocs[index].id,
                        roomId: roomId,
                        context: context,
                        serviceProviderRes: serviceProviderRes);
                  } else if (chatData["msgType"] == "text") {
                    textChatResModel = TextChatResModel.fromMap(chatData);
                    if (textChatResModel!.sendBy ==
                        LocalStorage.box.read("uId")) {
                      isMe = true;
                    }
                    return messegeContainer(
                        isMe: isMe,
                        textChatResModel: textChatResModel,
                        context: context);
                  }
                },
              );
            },
          ).marginOnly(left: 1.w, right: 1.w, bottom: 8.h),
        ),
        bottomSheet: Container(
          height: 65,
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
              ),
            ],
          ),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Icon(
                  Icons.add,
                  size: 30,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Container(
                  alignment: Alignment.centerRight,
                  width: 240,
                  child: TextFormField(
                    controller: textEditingController,
                    onFieldSubmitted: (value) {
                      if (textEditingController.text.trim().isNotEmpty) {
                        ChatService.sendChat(
                            msgType: "text",
                            msg: textEditingController.text.trim(),
                            roomId: roomId);
                        _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.bounceOut);
                        textEditingController.clear();
                      }
                    },
                    decoration: const InputDecoration(
                      hintText: "Type Something",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () {
                    if (textEditingController.text.trim().isNotEmpty) {
                      ChatService.sendChat(
                          msgType: "text",
                          msg: textEditingController.text.trim(),
                          roomId: roomId);
                      ChatService.sendNotification(
                          msType: "text",
                          serviceProviderRes: serviceProviderRes,
                          msg: textEditingController.text.trim());
                      _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.bounceOut);
                      textEditingController.clear();
                    }
                  },
                  child: const Icon(
                    Icons.send,
                    color: appColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      onWillPop: () async {
        // chatScreenController.getAllRoomData();
        return true;
      },
    );
  }
}
