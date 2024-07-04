import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:home_hub/Response%20Model/service_provider_res_model.dart';
import 'package:home_hub/firebase%20services/repo.dart';

class CountService {
  static Future<void> setCounting({required String serviceProviderId}) async {
    DocumentSnapshot dd =
        await serviceProviderUserCollection.doc(serviceProviderId).get();

    ServiceProviderRes serviceProviderRes =
        ServiceProviderRes.formMap(dd.data() as Map<String, dynamic>);

    int clicks = serviceProviderRes.clicks + 1;
    await serviceProviderUserCollection
        .doc(serviceProviderId)
        .update({'clicks': clicks});
  }
}
