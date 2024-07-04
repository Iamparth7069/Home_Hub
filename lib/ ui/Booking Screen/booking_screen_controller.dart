import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:home_hub/Response%20Model/order_res_model.dart';
import 'package:home_hub/Response%20Model/service_provider_res_model.dart';
import 'package:home_hub/Response%20Model/service_res_model.dart';
import 'package:home_hub/firebase%20services/repo.dart';
import 'package:home_hub/utils/local_storage.dart';

class BookingScreenController extends GetxController {
  int selectedTab = 0;
  bool isLoading = false;

  List<OrderResModel> pendingOrders = [];
  List<ServiceProviderRes> pendingOrdersUserDetails = [];
  List<ServiceResponseModel> pendingOrdersServiceDetails = [];
  List<OrderResModel> completedOrders = [];
  List<ServiceProviderRes> completedOrdersUserDetails = [];
  List<ServiceResponseModel> completedOrdersServiceDetails = [];
  List<OrderResModel> calcleOrders = [];
  List<ServiceProviderRes> calcleOrdersUserDetails = [];
  List<ServiceResponseModel> calcleOrdersServiceDetails = [];
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getAllBookings();
  }

  void setSelectedTab({required int value}) {
    selectedTab = value;
    update();
  }

  Future<void> getAllBookings() async {
    isLoading = true;
    update();
    String myUid = await LocalStorage.getUserId();

    Stream<QuerySnapshot> data = orderCollection
        .where("userId", isEqualTo: myUid)
        .orderBy("createdAt", descending: true)
        .snapshots();

    data.listen((event) async {
      pendingOrders.clear();
      completedOrders.clear();
      completedOrdersUserDetails.clear();
      pendingOrdersUserDetails.clear();
      calcleOrders.clear();
      calcleOrdersUserDetails.clear();
      pendingOrdersServiceDetails.clear();
      calcleOrdersServiceDetails.clear();
      completedOrdersServiceDetails.clear();
      for (var element in event.docs) {
        OrderResModel orderResModel =
            OrderResModel.fromJson(element.data() as Map<String, dynamic>);
        print("======>${orderResModel.toJson()}");
        ServiceProviderRes serviceProviderRes = await getServiceProviderData(
            serviceProviderId: orderResModel.serviceProviderId ?? "");
        ServiceResponseModel serviceResponseModel =
            await getServiceData(serviceId: orderResModel.subServiceId ?? "");
        if (orderResModel.status == "Pending" || orderResModel.status == "Accepted") {
          pendingOrders.add(orderResModel);
          pendingOrdersUserDetails.add(serviceProviderRes);
          pendingOrdersServiceDetails.add(serviceResponseModel);
        } else if (orderResModel.status == "Completed") {
          completedOrders.add(orderResModel);
          completedOrdersUserDetails.add(serviceProviderRes);
          completedOrdersServiceDetails.add(serviceResponseModel);
        } else {
          calcleOrders.add(orderResModel);
          calcleOrdersUserDetails.add(serviceProviderRes);
          calcleOrdersServiceDetails.add(serviceResponseModel);
        }
      }
      isLoading = false;
      update();
    });
  }

  Future<ServiceProviderRes> getServiceProviderData(
      {required String serviceProviderId}) async {
    DocumentSnapshot dd =
        await serviceProviderUserCollection.doc(serviceProviderId).get();
    ServiceProviderRes serviceProviderRes =
        ServiceProviderRes.formMap(dd.data() as Map<String, dynamic>);
    return serviceProviderRes;
  }

  Future<ServiceResponseModel> getServiceData(
      {required String serviceId}) async {
    DocumentSnapshot dd = await servicesCollection.doc(serviceId).get();
    ServiceResponseModel serviceResponseModel =
        ServiceResponseModel.fromMap(dd.data() as Map<String, dynamic>);
    return serviceResponseModel;
  }
}
