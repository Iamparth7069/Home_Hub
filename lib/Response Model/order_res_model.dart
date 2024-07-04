import 'package:cloud_firestore/cloud_firestore.dart';

class OrderResModel {
  final String? userId;
  final String? serviceProviderId;
  final DateTime? createdAt;
  final DateTime? completeDate;
  final String? status;
  final String? paymentStatus;
  final String? subServiceId;
  final String? orderId;
  final String? offerId;
  final String? serviceName;
  final String? address;
  final int? amount;
  final String? transactionId;

  OrderResModel({
    this.userId,
    this.serviceProviderId,
    this.createdAt,
    this.completeDate,
    this.status,
    this.address,
    this.paymentStatus,
    this.subServiceId,
    this.orderId,
    this.transactionId,
    this.amount,
    this.serviceName,
    this.offerId,
  });

  factory OrderResModel.fromJson(Map<String, dynamic> json) => OrderResModel(
        userId: json['userId'] ?? "",
        serviceProviderId: json['serviceProviderId'] ?? "",
        createdAt: (json['createdAt'] as Timestamp).toDate(),
        completeDate: (json['complete_date'] as Timestamp).toDate(),
        status: json['status'] ?? "",
        paymentStatus: json['paymentStatus'] ?? "",
        subServiceId: json['subServiceId'] ?? "",
        orderId: json['orderId'] ?? "",
        serviceName: json['serviceName'] ?? "",
        offerId: json['offerId'] ?? "",
        amount: json['amount'] ?? 0,
        address: json['address'] ?? "",
        transactionId: json['transactionId'] ?? "",
      );

  Map<String, dynamic> toJson() => {
        'userId': userId ?? "",
        'serviceProviderId': serviceProviderId ?? "",
        'createdAt': Timestamp.fromDate(createdAt!),
        'complete_date': Timestamp.fromDate(completeDate!),
        'status': status,
        'paymentStatus': paymentStatus,
        'subServiceId': subServiceId,
        'serviceName': serviceName,
        'orderId': orderId,
        'offerId': offerId,
        'address': address,
        'amount': amount,
        'transactionId': transactionId,
      };
}
