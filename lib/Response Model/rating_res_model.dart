import 'package:cloud_firestore/cloud_firestore.dart';

class RatingResModel {
  final double ratings;
  final List<String> whatLike;
  final String description;
  final String userId;
  final String orderId;
  final String serviceId;
  final String userName;
  final String profileImage;
  final DateTime createdAt;

  RatingResModel({
    required this.ratings,
    required this.userName,
    required this.profileImage,
    required this.whatLike,
    required this.description,
    required this.userId,
    required this.orderId,
    required this.serviceId,
    required this.createdAt,
  });

  // Factory constructor to create a RatingResponse object from a map (useful for deserialization)
  factory RatingResModel.fromMap(Map<String, dynamic> map) {
    return RatingResModel(
      userName: map['userName'] ?? '',
      profileImage: map['profileImage'] ?? '',
      ratings: map['ratings']?.toDouble() ?? 0.0,
      whatLike: List<String>.from(map['whatLike']),
      description: map['description'] ?? '',
      userId: map['userId'] ?? '',
      orderId: map['orderId'] ?? '',
      serviceId: map['serviceId'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate() ?? DateTime.now(),
    );
  }

  // Method to convert a RatingResponse object to a map (useful for serialization)
  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'profileImage': profileImage,
      'ratings': ratings,
      'whatLike': whatLike,
      'description': description,
      'userId': userId,
      'orderId': orderId,
      'serviceId': serviceId,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
