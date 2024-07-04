import 'package:cloud_firestore/cloud_firestore.dart';

class OfferResModel {
  DateTime createdAt;
  DateTime daysToWork;
  String description;
  String msgType;
  int price;
  String sendBy;
  String serviceName;
  String status;
  String sId;

  OfferResModel({
    required this.createdAt,
    required this.sId,
    required this.status,
    required this.daysToWork,
    required this.description,
    required this.msgType,
    required this.price,
    required this.sendBy,
    required this.serviceName,
  });

  factory OfferResModel.fromMap(Map<String, dynamic> data) {
    return OfferResModel(
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      daysToWork: (data['daysToWork'] as Timestamp).toDate(),
      description: data['description'] ?? '',
      sId: data['sId'] ?? '',
      msgType: data['msgType'] ?? '',
      status: data['status'] ?? '',
      price: data['price'] ?? 0,
      sendBy: data['sendBy'] ?? '',
      serviceName: data['service_name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'createdAt': Timestamp.fromDate(createdAt),
      'daysToWork': Timestamp.fromDate(daysToWork),
      'description': description,
      'msgType': msgType,
      'sId': sId,
      'status': status,
      'price': price,
      'sendBy': sendBy,
      'service_name': serviceName,
    };
  }
}
