import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

OfferResModel offerResModelFromMap(String str) =>
    OfferResModel.fromMap(json.decode(str));

String offerResModelToMap(OfferResModel data) => json.encode(data.toMap());

class OfferResModel {
  String? dId;
  String? discount;
  String? title;
  String? discription;
  String? image;
  String? color;
  DateTime? createdAt;

  OfferResModel({
    this.dId,
    this.discount,
    this.title,
    this.discription,
    this.image,
    this.color,
    this.createdAt,
  });

  factory OfferResModel.fromMap(Map<String, dynamic> json) => OfferResModel(
        dId: json["dId"],
        discount: json["discount"],
        title: json["title"],
        discription: json["discription"],
        image: json["image"],
        color: json["color"],
        createdAt: (json['createdAt'] as Timestamp).toDate() ?? DateTime.now(),
      );

  Map<String, dynamic> toMap() => {
        "dId": dId,
        "discount": discount,
        "title": title,
        "discription": discription,
        "image": image,
        "color": color,
        'createdAt': Timestamp.fromDate(createdAt ?? DateTime.now()),
      };
}




