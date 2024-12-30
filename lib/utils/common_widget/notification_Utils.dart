import 'dart:convert';
import 'dart:typed_data';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:firebase_messaging/firebase_messaging.dart' as fcm;
import 'package:http/http.dart' as http;


class NotificationUtils {
  static String formatDate(String dateStr) {
    final DateTime date = new DateFormat('dd/MM/yyyy').parse(dateStr);
    final DateFormat formatter = DateFormat('dd MMM yyyy');
    final String formatted = formatter.format(date);
    return formatted; // something like 2013-04-20
  }

  static String formatDateValue(DateTime dateTime) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final String formatted = formatter.format(dateTime);
    print(formatted);
    return formatted;
  }

  static Future<void> showNotification(
      BuildContext? context, fcm.RemoteMessage event) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) {
        onDidReceiveLocalNotification(context!, id, title!, body!, payload!);
      },
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (payload) {

       // selectNotification(context!, payload!);
      },
    );




    //var fcmData = FcmData.parseJson(event.data['data'].toString());

    var fcmData;
    AndroidNotificationDetails androidPlatformChannelSpecifics;

   /* if (fcmData.image != null) {
      ByteArrayAndroidBitmap imgBitmap =
          ByteArrayAndroidBitmap(await _getByteArrayFromUrl(fcmData.image));
      BigPictureStyleInformation picStyleInfo = BigPictureStyleInformation(
        imgBitmap,
        // contentTitle: fcmData.title,
        // summaryText: fcmData.message
      );

      androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'swapco',
        'swapco',
        channelDescription: 'swapco',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        styleInformation: picStyleInfo,
      );
    } else {*/
      androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'LightGallery',
        'LightGallery',
        channelDescription: 'LightGallery',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        channelShowBadge: true
      );
   // }

    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);


   /* if(event.data['title'].toString() == 'Match Alert!') {
      await flutterLocalNotificationsPlugin.show(
          UniqueKey().hashCode, event.data['title'].toString(),
          event.data['body'].toString(), platformChannelSpecifics,
          payload: event.data['title'].toString()+","+event.data['matchingProductImageUrl'].toString()+","+event.data['myProductId'].toString()+","+
              event.data['myProductImageUrl'].toString()+","+event.data['matchingUserId'].toString()+","+event.data['matchingProductId'].toString()
      );
    }*/
   // else {
      await flutterLocalNotificationsPlugin.show( UniqueKey().hashCode, event.data['title'].toString(), event.data['body'].toString(), platformChannelSpecifics,
    payload: event.data['title'].toString());
   // }
  }

  static void onDidReceiveLocalNotification(BuildContext context, int id,
      String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
             // Navigator.of(context, rootNavigator: true).pop();
              /*
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DashboardScreen(),
                ),
              );*/
             /* await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BottomNavigation(),
                ),
              );*/
            },
          )
        ],
      ),
    );
  }

/*
  static void selectNotification(BuildContext context, String payload) async {
    if (payload != null) {


      var output = payload.split(',');

      print(output);

      if(output[0] == 'Match Alert!'){

        PrefRepository().saveNotification(output[5]);
        PrefRepository().saveNotificationDetails(payload);

        FBroadcast.instance().broadcast(
          /// message type
          'KEY',

          /// data
          value: '0',
        );
      }
      else{
        PrefRepository().saveNotification(output[1]);

        FBroadcast.instance().broadcast(
          /// message type
          'KEY',

          /// data
          value: '2',
        );
      }



      // List<String> str = payload.replaceAll("{","").replaceAll("}","").split(",");

     // Get.to(MainChatScreen(),arguments: [payload]);



      //print(str[1]);
    }

   */
/* Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => DashboardScreen()),
        (route) => false);*//*

 */
/*   Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => BottomNavigation()),
            (route) => false);*//*


    // await Navigator.push(
    //   context,
    //   MaterialPageRoute<void>(builder: (context) => DashboardScreen()),
    // );
  }
*/

  static Future<Uint8List> _getByteArrayFromUrl(String url) async {
    final http.Response response = await http.get(Uri.parse(url));
    return response.bodyBytes;
  }
}
