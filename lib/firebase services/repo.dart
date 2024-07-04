import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseAuth firebaseAuth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;

CollectionReference servicesCollection =
    firestore.collection("Services-Provider(Provider)");
CollectionReference chatRoomCollection = firestore.collection("chatRoom");
CollectionReference userCollection = firestore.collection("User");
CollectionReference serviceProviderUserCollection =
    firestore.collection("service_providers");
CollectionReference otpService = firestore.collection('otp');
CollectionReference orderCollection = firestore.collection('Orders');
CollectionReference paymentRequest = firestore.collection('Payment_request');
CollectionReference transectionCollection =
    firestore.collection('transectionCollection');
