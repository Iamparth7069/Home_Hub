import 'package:carousel_slider/carousel_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:home_hub/Response%20Model/rating_res_model.dart';
import 'package:home_hub/firebase%20services/repo.dart';

import '../../Response Model/service_res_model.dart';

class ServiceDetailController extends GetxController {
  int selectedPosterImageIndex = 0;

  void setSelectedPosterImageIndex({required int value}) {
    selectedPosterImageIndex = value;
    update();
  }

  List<RatingResModel> fiveStarRatings = [];
  List<RatingResModel> fourStarRatings = [];
  List<RatingResModel> threeStarRatings = [];
  List<RatingResModel> twoStarRatings = [];
  List<RatingResModel> oneStarRatings = [];
  List<RatingResModel> allRatings = [];
  List<RatingResModel> selectedRatings = [];

  List<String> ratingsType = [
    "All",
    "1",
    "2",
    "3",
    "4",
    "5",
  ];
  int total = 0;
  int selectedRating = 0;
  double totalReview = 0;

  void setReviewFilter({required int index}) {
    selectedRating = index;
    if (index == 0) {
      selectedRatings = allRatings;
    } else if (index == 1) {
      selectedRatings = oneStarRatings;
    } else if (index == 2) {
      selectedRatings = twoStarRatings;
    } else if (index == 3) {
      selectedRatings = threeStarRatings;
    } else if (index == 4) {
      selectedRatings = fourStarRatings;
    } else if (index == 5) {
      selectedRatings = fiveStarRatings;
    }
    update();
  }

  Future<void> getReviewData(
      {required ServiceResponseModel serviceResponseModel}) async {
    Stream<QuerySnapshot> data = servicesCollection
        .doc(serviceResponseModel.serviceIds)
        .collection("ratings")
        .orderBy("createdAt", descending: true)
        .snapshots();
    setReviewFilter(index: 0);
    data.listen((event) {
      fiveStarRatings.clear();
      fourStarRatings.clear();
      threeStarRatings.clear();
      twoStarRatings.clear();
      oneStarRatings.clear();
      allRatings.clear();

      for (var element in event.docs) {
        total = total + 1;
        RatingResModel ratingResModel =
            RatingResModel.fromMap(element.data() as Map<String, dynamic>);
        totalReview = totalReview + ratingResModel.ratings;
        allRatings.add(ratingResModel);
        if (ratingResModel.ratings >= 1 && ratingResModel.ratings < 2) {
          oneStarRatings.add(ratingResModel);
        } else if (ratingResModel.ratings >= 2 && ratingResModel.ratings < 3) {
          twoStarRatings.add(ratingResModel);
        } else if (ratingResModel.ratings >= 3 && ratingResModel.ratings < 4) {
          threeStarRatings.add(ratingResModel);
        } else if (ratingResModel.ratings >= 4 && ratingResModel.ratings < 5) {
          fourStarRatings.add(ratingResModel);
        } else if (ratingResModel.ratings == 5) {
          fiveStarRatings.add(ratingResModel);
        }
        update();
      }
    });
  }
}
