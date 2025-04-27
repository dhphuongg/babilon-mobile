import 'dart:convert';
import 'dart:io';

import 'package:babilon/core/domain/utils/logger.dart';
import 'package:babilon/core/domain/utils/share_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:babilon/core/application/models/notification/notification_information.dart';
// import 'package:babilon/infrastructure/services/deeplink_service.dart';
// import 'package:babilon/presentation/pages/notifications/cubit/notification_cubit.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // late NotificationCubit notificationCubit;
  // final DeepLinkService deepLinkService = DeepLinkService();

  final _defaultChannel = const AndroidNotificationChannel(
    'default_channel', // id
    'Default Notifications', // title
    description:
        'This channel is used for default notifications without custom sound.',
    importance: Importance.max,
    sound:
        RawResourceAndroidNotificationSound('sound_default'), // No custom sound
  );

  Future<void> initialize() async {
    await initLocalNotifications();
    await initPushNotifications();
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        _handleOpenNotification(message);
      }
    });
  }

  Future<void> initPushNotifications() async {
    await messaging.setForegroundNotificationPresentationOptions(
      alert: false,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      await _handleOpenNotification(message);
    });

    FirebaseMessaging.onMessage.listen((message) async {
      // notificationCubit = BlocProvider.of<NotificationCubit>(
      //     NavigationService.navigatorKey.currentContext!);
      // await notificationCubit.getUnseenNotifications();
    });
  }

  Future<void> initLocalNotifications() async {
    try {
      var android = const AndroidInitializationSettings('@mipmap/ic_launcher');
      var ios = const DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        defaultPresentSound: true,
      );

      var initSettings = InitializationSettings(android: android, iOS: ios);

      await _localNotifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (details) {
          String payload = details.payload ?? '';
          final message = RemoteMessage.fromMap(jsonDecode(payload));
          _handleOpenNotification(message);
        },
      );

      // Register both channels
      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(_defaultChannel);
    } on Exception catch (error) {
      AppLogger.instance.error('_initLocalNotification $error');
    }
  }

  Future<bool> requestPermission() async {
    try {
      final settings = await messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true,
      );

      return settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;
    } on Exception catch (error) {
      AppLogger.instance.error('requestPermission $error');
      return false;
    }
  }

  Future<void> _handleOpenNotification(RemoteMessage message) async {
    // NotificationInformationEntity notificationInformationEntity =
    //     NotificationInformationEntity.fromJson(message.data);
    // final deepLinkUrl = notificationInformationEntity.deepLink ?? '';
    // final notificationId = notificationInformationEntity.id ?? '';
    // if (deepLinkUrl.isNotEmpty && notificationId.isNotEmpty) {
    //   deepLinkService.processDeepLink(
    //       notificationId, Uri.parse(deepLinkUrl), false);
    // }
  }

  Future<void> showNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null && !kIsWeb) {
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _defaultChannel.id,
            _defaultChannel.name,
            channelDescription: _defaultChannel.description,
            icon: android.smallIcon,
            sound: const RawResourceAndroidNotificationSound('sound_default'),
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        payload: jsonEncode(message.toMap()),
      );
    }
  }

  Future<String> getDeviceToken() async {
    try {
      if (Platform.isIOS) {
        final apnsToken = await messaging.getAPNSToken();
        if (apnsToken == null) {
          return '';
        }
      }
      String? token = await messaging.getToken();
      String deviceToken = await SharedPreferencesHelper.getStringValue(
          SharedPreferencesHelper.DEVICE_TOKEN);
      if (token != deviceToken && token != null) {
        await SharedPreferencesHelper.saveStringValue(
            SharedPreferencesHelper.DEVICE_TOKEN, token);
      }
      return token ?? '';
    } on Exception catch (error) {
      AppLogger.instance.error('getDeviceToken $error');
      return '';
    }
  }
}
