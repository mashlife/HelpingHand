import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:helping_hand/firebase_options.dart';
import 'package:helping_hand/src/controllers/native_methods.dart';
import 'package:helping_hand/src/screen/CustomOverlay/custom_overlay.dart';
import 'package:helping_hand/src/screen/Settings/overlay/overlay_settings_provider.dart';
import 'package:helping_hand/src/screen/SplashScreen/splash_screen.dart';
import 'package:helping_hand/src/services/navigation_service.dart';
import 'package:helping_hand/src/services/notification_service.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OverlaySettingsProvider()),
        ChangeNotifierProvider(create: (_) => NativeMethods()),
      ],
      child: const MyApp(),
    ),
  );
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A background message just showed up: ${message.messageId}');
  await NotificationHelper().showMessageInBackground(message);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: NavService.navigatorKey,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

@pragma("vm:entry-point")
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      navigatorKey: NavService.navigatorKey,
      debugShowCheckedModeBanner: false,
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (context) => OverlaySettingsProvider()),
          ChangeNotifierProvider(create: (context) => NativeMethods()),
        ],
        child: const CustomOverlay(),
      ),
    ),
  );
}
