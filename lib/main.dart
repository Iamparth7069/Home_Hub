import 'dart:convert';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:home_hub/%20ui/Chat%20Screen/chat_Screen_controller.dart';
import 'package:home_hub/%20ui/Forgot%20Password/forgot_password_screen.dart';
import 'package:home_hub/%20ui/Payment%20Screen/payment_controller.dart';
import 'package:home_hub/firebase%20services/notification_service.dart';

import 'package:home_hub/utils/app_routes.dart';
import 'package:home_hub/utils/local_storage.dart';
import 'package:sizer/sizer.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', 'High Importance Notifications',
    importance: Importance.high, playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();

  NotificationService().getFCMToken();
  FirebaseMessaging.onBackgroundMessage(
      NotificationService.firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
  );
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
  );
  NotificationService.getInitialMsg();
  NotificationService.showMsgHandler();
  NotificationService.onMsgOpen();
  flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
    if (notificationResponse.payload != null &&
        notificationResponse.payload!.isNotEmpty) {
      final Map<String, dynamic> data =
          jsonDecode(notificationResponse.payload!);

      // Assuming Routes.messegeScreen is set up to handle the data as arguments
      Get.toNamed(Routes.messegeScreen, arguments: data);
    }
    log('notificationResponse-----${notificationResponse.payload}');
  });
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ChatScreenController chatScreenController = Get.put(ChatScreenController());

    return Sizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
          ),
          initialRoute: Routes.splashScreen,
          getPages: Routes.getPages,
        );
      },
    );
  }
}
