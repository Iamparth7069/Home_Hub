import 'package:cloud_firestore/cloud_firestore.dart';

class TextChatResModel {
  final String msg;
  final String msgType;
  final String sendBy;
  final DateTime createdAt;

  TextChatResModel({
    required this.msg,
    required this.msgType,
    required this.sendBy,
    required this.createdAt,
  });

  // Factory method to create a TextChat instance from a map
  factory TextChatResModel.fromMap(Map<String, dynamic> map) {
    return TextChatResModel(
      msg: map['msg'],
      msgType: map['msgType'],
      sendBy: map['sendBy'],
      createdAt: (map['createdAt'] as Timestamp)
          .toDate(), // Convert Timestamp to DateTime
    );
  }

  // Method to convert TextChat instance to a map
  Map<String, dynamic> toMap() {
    return {
      'msg': msg,
      'msgType': msgType,
      'sendBy': sendBy,
      'createdAt':
          Timestamp.fromDate(createdAt), // Convert DateTime back to Timestamp
    };
  }
}
