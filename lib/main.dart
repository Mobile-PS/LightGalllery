import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:light_gallery/routes/routes.dart';
import 'package:light_gallery/utils/common_widget/notification_Utils.dart';
import 'package:light_gallery/utils/constant/const_color.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

String initialRoute = '/';

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  // This widget is the root of your application.

  @override
  void initState() {
    // TODO: implement initState


    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(message.data);
      NotificationUtils.showNotification(context, message);
    });

    _requestPermissions();

    super.initState();

  }

  Future<void> _requestPermissions() async {

    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin?  androidImplementation =
      FlutterLocalNotificationsPlugin().resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      final bool? granted = await androidImplementation?.requestPermission();
    }

  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: primaryColor
    ));
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
      title: "Light's Gallery",
      theme: lightTheme(),
      themeMode: ThemeMode.light,
      initialRoute: initialRoute,
      getPages: pages(),

    );  }
}

ThemeData lightTheme() {
  var baseTheme = ThemeData.light();
  baseTheme.textTheme.apply(fontFamily: 'RedHat');
  baseTheme.copyWith(
      scaffoldBackgroundColor: primaryColor,
      colorScheme: baseTheme.colorScheme.copyWith(
        primary: Colors.white,
        secondary: Colors.white,
        onSecondary: Colors.white,
      ));

  return baseTheme;
}


