import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:io';
import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fooddelivery/pages/alarm.dart';
import 'package:fooddelivery/pages/orders/myorders.dart';
import 'package:fooddelivery/pages/orderstaxi/delivery.dart';

final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

getTokenDevice() async {
  String mytoken;
  await firebaseMessaging.getToken().then((String token) {
    print("=======================");
    print("token 1 ${token}");
    print("=======================");
    if (token == null) {
      firebaseMessaging.getToken().then((String newtoken) {
        mytoken = newtoken;
        print(" 2 retry token");
      });
    } else {
      mytoken = token;
    }
    print("=======================");
    print("token  2 ${mytoken}");
    print("=======================");
  });
  return mytoken;
}

void redirectPage(Map<String, dynamic> message, BuildContext context,
    [idpage]) async {
  String page_name = message["data"]["page_name"].toString();
  String page_id = message["data"]["page_id"].toString();

  if (page_name == "orderswait") {
    Navigator.of(context).pushNamed("myorders");
  }
  if (page_name == "orderswaittaxi") {
    Navigator.of(context).pushNamed("myorderstaxi");
  }
  if (page_name == "alerm") {
    var infoordertable = jsonDecode(message["data"]["page_id"]);
    var resid = infoordertable['resid'];
    var ordersid = infoordertable['ordersid'];
    var table = infoordertable['table'];
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return Alerm(ordersid: ordersid, resid: resid, table: table);
    }));
  }

  if (page_name == "approveorderstaxi") {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      var infoordertaxi = jsonDecode(message["data"]["page_id"]);

      var orderid = infoordertaxi['ordersid'];
      var taxiid = infoordertaxi['taxiid'];
      var destlat = infoordertaxi['destlat'];
      var destlong = infoordertaxi['destlong'];
      var lat = infoordertaxi['lat'];
      var long = infoordertaxi['long'];

      return Delivery(
          orderid: orderid,
          taxiid: taxiid,
          destlat: destlat,
          destlong: destlong,
          lat: lat,
          long: long,
          statusorders: 1.toString());
    }));
  }
  if (page_name == "ordersdone") {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return MyOrders(initialpage: 1);
    }));
  }
  //   if(page_name == "orders") {
  //     Navigator.of(context).pushNamed("orders");
  // }
}

getNotify(context) {
  firebaseMessaging.configure(
    onMessage: (Map<String, dynamic> message) async {
      if (Platform.isAndroid) {
        String title = message["notification"]["title"].toString();
        String body = message["notification"]["body"].toString();
        print("Hay Food Delivery: $message");
        showNotification(title, body);
        redirectPage(message, context);
      } else if (Platform.isIOS) {
        String title = message['aps']['alert']['title'].toString();
        String body = message['aps']['alert']['body'].toString();
        print("Hay Food Delivery: $message");
        showNotification(title, body);
        redirectPage(message, context);
      }
    },
    onLaunch: (Map<String, dynamic> message) async {
      print("onLaunch: $message");
    },
    onResume: (Map<String, dynamic> message) async {
      print("onResume: $message");
      redirectPage(message, context);
    },
  );
}

requestPermissons() async {
  firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(
          sound: true, badge: true, alert: true, provisional: true));
  firebaseMessaging.onIosSettingsRegistered
      .listen((IosNotificationSettings settings) {
    print("Settings registered: $settings");
  });
}

//==============================================
// =================== For Local Notifcation
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
getLocalNotification() async {
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
          onDidReceiveLocalNotification: onDidReceiveLocalNotification);
  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: selectNotification);
}

void requestLocalPermissions() {
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
}

// At the second last line ‘selectNotification: onSelectNotification’. This line is responsible for the action which is going to be happen when we will click on the Notification. This method must return Future and this method must have a string paramter which will be payload.
Future selectNotification(String payload) async {
  if (payload != null) {
    debugPrint('notification payload: $payload');
  }
  print(payload);

  // var resid = sharedPrefs.getString("id") ;
  // navigatorKey.currentState.pushNamed("items" , arguments: {
  //        "resid" : resid
  // }) ;
}

Future onDidReceiveLocalNotification(
    int id, String title, String body, String payload) async {
  // var resid = sharedPrefs.getString("id") ;

  //    navigatorKey.currentState.pushNamed("items" , arguments: {
  //        "resid" : resid
  // }) ;
}
// Show Notifcation
Future<void> showNotification(String title, String body) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
          'your channel id', 'your channel name', 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker');
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin
      .show(0, title, body, platformChannelSpecifics, payload: 'item');
}
