import 'package:flutter/material.dart';

import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:cookie_app/datasource/api/restClient.dart';
import 'package:cookie_app/service/auth.service.dart';
import 'package:cookie_app/utils/logger.dart';
import 'package:cookie_app/utils/navigation_service.dart';
import 'package:cookie_app/utils/udid.dart';
import 'package:cookie_app/view/pages/chatroom/chatpage.dart';

class NotificationService {
  late RestClient _api;
  BuildContext context = NavigationService.navigatorKey.currentContext!;
  NotificationService(AuthService authService) {
    _api = RestClient(authService.dio, baseUrl: dotenv.env['BASE_URI']!);

    FirebaseMessaging.instance.onTokenRefresh.listen((token) {
      registerDeviceToken(token);
    }).onError((error) {
      logger.e(error.message);
    });

    FirebaseMessaging.instance
        .subscribeToTopic("cookie-server")
        .then((value) => logger.d("subscribed to cookie-server"))
        .onError(
          (error, stackTrace) => logger.e("error subscribing to cookie-server"),
        );

    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: false,
      badge: false,
      sound: false,
    );

    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      Flushbar(
        title: message.notification?.title,
        message: message.notification?.body,
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.GROUNDED,
        duration: const Duration(seconds: 2),
        onTap: (flushbar) {
          if (message.data['type'] != 'chat') return;
          var chatRoom = message.data['chatRoom'];
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(room: chatRoom),
            ),
          );
        },
      ).show(context);
    });
  }

  Future<NotificationSettings> requestPermission() async {
    return await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  void registerDeviceToken([String? token]) async {
    token ??= await FirebaseMessaging.instance.getToken();
    if (token == null) return;
    try {
      String? udid = await getUdid();
      await _api.patchDeviceToken(udid!, token);
    } on DioException catch (e) {
      logger.e(e);
      e.response == null
          ? throw Exception('서버와 연결할 수 없습니다.')
          : throw Exception(e.response!.statusMessage!);
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}
