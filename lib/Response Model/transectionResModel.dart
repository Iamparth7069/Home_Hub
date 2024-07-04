import 'package:cloud_firestore/cloud_firestore.dart';

class TransectionResModel {
  final String from;
  final String to;
  final String transectionId;
  final String status;
  final String type;
  final String amount;
  final DateTime time;

  TransectionResModel({
    required this.from,
    required this.to,
    required this.status,
    required this.type,
    required this.amount,
    required this.transectionId,
    required this.time,
  });

  // Factory method to create a TextChat instance from a map
  factory TransectionResModel.fromMap(Map<String, dynamic> map) {
    return TransectionResModel(
      from: map['from'],
      to: map['to'],
      type: map['type'],
      amount: map['amount'],
      status: map['status'],
      transectionId: map['transectionId'],
      time:
          (map['time'] as Timestamp).toDate(), // Convert Timestamp to DateTime
    );
  }

  // Method to convert TextChat instance to a map
  Map<String, dynamic> toMap() {
    return {
      'from': from,
      'to': to,
      'type': type,
      'amount': amount,
      'status': status,
      'transectionId': transectionId,
      'time': Timestamp.fromDate(time), // Convert DateTime back to Timestamp
    };
  }
}
