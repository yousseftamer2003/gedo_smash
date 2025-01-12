import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


Future<void> handleBackGoroundMessage(RemoteMessage message) async{
  log('message: ${message.notification!.title}');
}

class NotificationController with ChangeNotifier {
  Future<void> initFCMToken(int userId) async {
    FirebaseMessaging.onBackgroundMessage(handleBackGoroundMessage);

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Get the FCM token
    String? token = await messaging.getToken();

    if (token != null) {
        await FirebaseFirestore.instance.collection('users').doc(userId.toString()).set({
        'fcm_token': token,
      });

      log("FCM Token stored for user $userId: $token");
      
    } else {
      log("Failed to get FCM token");
    }

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        log('App opened from terminated state by notification: ${message.notification?.title}');
        // Handle the data message here
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Received message in foreground: ${message.notification?.title}');
      // Handle foreground message
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('App opened by notification: ${message.notification?.title}');
      // Handle the case when the app is opened by tapping a notification
    });

  }

  
}