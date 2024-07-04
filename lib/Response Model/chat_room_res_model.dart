import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomResModel {
  final String LastChat;
  final String firstUid;
  final String secondUid;
  final String docId;
  final DateTime lastChatTime;
  final String lastMsgType;
  ChatRoomResModel(
      {required this.docId,
      required this.LastChat,
      required this.firstUid,
      required this.lastChatTime,
      required this.lastMsgType,
      required this.secondUid});

  factory ChatRoomResModel.fromJson(Map<String, dynamic> json) {
    return ChatRoomResModel(
      docId: json["roomId"],
      LastChat: json['LastChat'],
      firstUid: json['firstUid'],
      secondUid: json['secondUid'],
      lastMsgType: json['lastMsgType'],
      lastChatTime: (json['LastChatTime'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "roomId": this.docId,
      'LastChat': LastChat,
      'lastMsgType': lastMsgType,
      'LastChatTime': Timestamp.fromDate(lastChatTime),
      "firstUid": this.firstUid,
      "secondUid": this.secondUid,
    };
  }
}
