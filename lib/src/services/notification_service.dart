//TODO: Add NotificationHelper class

import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationHelper {
  final _firebaseMessaging = FirebaseMessaging.instance;
  // final _localNotifications = FlutterLocalNotificationsPlugin();

  // final AndroidNotificationChannel channel = const AndroidNotificationChannel(
  //   'high_importance_channel', // id
  //   'High Importance Notifications', // title
  //   description:
  //       'This channel is used for important notifications.', // description
  //   importance: Importance.high,
  // );

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();
    final fcmToken = await getFcmToken();
    print("FCM Token: $fcmToken");

    // const initializationSettings = InitializationSettings(
    //   android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    // );

    // await _localNotifications
    //     .resolvePlatformSpecificImplementation<
    //         AndroidFlutterLocalNotificationsPlugin>()
    //     ?.createNotificationChannel(channel);

    // await _localNotifications.initialize(initializationSettings);

    initPushNotification();
  }

  Future<void> initPushNotification() async {
    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      await handleMessage(message);
    });

    _firebaseMessaging.getInitialMessage().then((message) async {
      if (message != null) {
        await handleMessage(message);
      }
    });

    FirebaseMessaging.onMessage.listen((message) async {
      await readMessage(message);
      // if (message.data["image"] != null) {
      //   await _showLocalImageNotification(message);
      // } else {
      //   await _showLocalNotification(message);
      // }
    });
  }

  Future<void> showMessageInBackground(RemoteMessage message) async {
    await readMessage(message);
    // if (message.data["image"] != null) {
    //   await _showLocalImageNotification(message);
    // } else {
    //   await _showLocalNotification(message);
    // }
  }

  // Future<void> _showLocalNotification(RemoteMessage message) async {
  //   var notificationDetails = NotificationDetails(
  //     android: AndroidNotificationDetails(
  //       channel.id, // Channel ID
  //       channel.name, // Channel name
  //       importance: Importance.max,
  //       priority: Priority.high,
  //       icon: '@mipmap/launcher_icon',
  //       colorized: true,
  //       color: const Color(0xffE28B2D),
  //     ),
  //   );

  //   if (message.notification != null) {
  //     await _localNotifications.show(
  //       message.hashCode,
  //       message.notification!.title,
  //       message.notification!.body,
  //       notificationDetails,
  //     );
  //   }
  // }

  // Future<void> _showLocalImageNotification(RemoteMessage message) async {
  //   final imageUrl = message.data['image'];
  //   BigPictureStyleInformation? bigPictureStyleInformation;
  //   try {
  //     final response = await http.get(Uri.parse(imageUrl));
  //     if (response.statusCode == 200) {
  //       final byteArray = response.bodyBytes;
  //       bigPictureStyleInformation = BigPictureStyleInformation(
  //         ByteArrayAndroidBitmap(byteArray),
  //         largeIcon: ByteArrayAndroidBitmap(byteArray),
  //         contentTitle: message.notification!.title,
  //         summaryText: message.notification!.body,
  //       );

  //       var notificationDetails = NotificationDetails(
  //         android: AndroidNotificationDetails(
  //           'high_importance_channel',
  //           'High Importance Notifications',
  //           channelDescription:
  //               'This channel is used for important notifications.',
  //           importance: Importance.high,
  //           priority: Priority.high,
  //           icon: '@mipmap/launcher_icon',
  //           colorized: true,
  //           color: const Color(0xffE28B2D),
  //           styleInformation: bigPictureStyleInformation,
  //           actions: [],
  //         ),
  //         iOS: const DarwinNotificationDetails(
  //           presentAlert: true,
  //           presentBadge: true,
  //           presentSound: true,
  //         ),
  //       );

  //       if (message.notification != null) {
  //         await _localNotifications.show(
  //           message.hashCode,
  //           message.notification!.title,
  //           message.notification!.body,
  //           notificationDetails,
  //           payload: jsonEncode(message.data),
  //         );
  //       }
  //     } else {
  //       throw "respnose-error";
  //     }
  //   } catch (e) {
  //     print('Failed to fetch image: $e');
  //     _showLocalNotification(message);
  //   }
  // }

  Future<void> readMessage(RemoteMessage? message) async {
    if (message == null) return;

    print('Foreground message: ${message.toMap().toString()}');
  }

  Future<void> handleMessage(RemoteMessage? message) async {
    if (message == null) return;

    // await _showLocalNotification(message);
  }

  Future<String?> getFcmToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    return token;
  }
}
