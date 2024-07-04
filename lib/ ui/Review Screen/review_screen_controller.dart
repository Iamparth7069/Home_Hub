import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:home_hub/Response%20Model/order_res_model.dart';
import 'package:home_hub/Response%20Model/rating_res_model.dart';
import 'package:home_hub/Response%20Model/service_provider_res_model.dart';
import 'package:home_hub/Response%20Model/service_res_model.dart';
import 'package:home_hub/Response%20Model/user_res_model.dart';
import 'package:home_hub/firebase%20services/repo.dart';
import 'package:home_hub/utils/local_storage.dart';

class ReviewScreenController extends GetxController {
  List<String> likeMost = [
    "Service Quality",
    "Punctuality",
    "Professionalism",
    "Pricing",
    "Communication",
    "Cleanliness",
    "Overall Experience",
  ];
  bool isDataSend = false;
  double rating = 0.0;
  List<String> selectedLikeMost = [];
  TextEditingController discription = TextEditingController();

  void setLikeMostValue({required String value}) {
    if (selectedLikeMost.contains(value)) {
      selectedLikeMost.remove(value);
    } else {
      selectedLikeMost.add(value);
    }
    update();
  }

  void setRatingValue({required double value}) {
    rating = value;
    update();
  }

  Future<void> sendReviewData(
      {required OrderResModel orderResModel,
      required ServiceResponseModel serviceResponseModel,
      required ServiceProviderRes serviceProviderRes}) async {
    isDataSend = true;
    update();
    String myUserId = await LocalStorage.getUserId();

    UserResModel myData = await LocalStorage.getUserData();
    RatingResModel ratingResModel = RatingResModel(
        ratings: rating,
        whatLike: selectedLikeMost,
        description: discription.text.trim(),
        userId: myUserId,
        orderId: orderResModel.orderId ?? "",
        serviceId: serviceResponseModel.serviceIds,
        createdAt: DateTime.now(),
        userName: "${myData.firstName} ${myData.lastName}",
        profileImage: myData.profileImage);
    await servicesCollection
        .doc(serviceResponseModel.serviceIds)
        .collection("ratings")
        .doc(orderResModel.orderId)
        .set(ratingResModel.toMap());
    Map<String, dynamic> data = await calculateAverageRating(
        serviceId: serviceResponseModel.serviceIds, rating: rating);
    await servicesCollection.doc(serviceResponseModel.serviceIds).update(
        {"average_rating": data["average"], "total_rating": data["total"]});
    isDataSend = false;
    update();
  }

  Future<Map<String, dynamic>> calculateAverageRating(
      {required String serviceId, required double rating}) async {
    try {
      CollectionReference ratings =
          servicesCollection.doc(serviceId).collection("ratings");

      QuerySnapshot querySnapshot = await ratings.get();

      List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      if (documents.isEmpty) {
        return {"average": rating, "total": 1};
      }

      double totalRating = 0.0;
      int ratingsCount = documents.length;

      for (var doc in documents) {
        totalRating += doc['ratings']
            as double; // Ensure the 'rating' field exists and is a double
      }
      double r = (totalRating + rating) / (ratingsCount + 1);
      double roundedValue = double.parse(r.toStringAsFixed(2));
      return {"average": roundedValue, "total": ratingsCount + 1};
    } catch (e) {
      return {"average": rating, "total": 1};
    }
  }
}
