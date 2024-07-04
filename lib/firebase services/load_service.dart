import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:home_hub/Response%20Model/service_res_model.dart';
import 'package:home_hub/firebase%20services/repo.dart';

class LoadService {
  static Stream<List<ServiceResponseModel>> getAllServicesStream() {
    return servicesCollection
        .limit(5)
        .where("serviceStatus", isEqualTo: "available")
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ServiceResponseModel.fromMap(
                doc.data() as Map<String, dynamic>))
            .toList());
  }

  static Stream<List<ServiceResponseModel>> getSecondStream() {
    return servicesCollection
        .limit(5)
        .where("serviceStatus", isEqualTo: "available")
        .orderBy("average_rating", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ServiceResponseModel.fromMap(
                doc.data() as Map<String, dynamic>))
            .toList());
  }
}
