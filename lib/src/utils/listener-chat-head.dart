// import 'package:flutter/services.dart';
// import 'package:helping_hand/src/screen/HomeScreen/home_screen.dart';
// import 'package:helping_hand/src/services/navigation_service.dart';

// class ChatHeadListener {
//   static const MethodChannel _channel = MethodChannel("bubble");

//   static void initialize() {
//     _channel.setMethodCallHandler((call) async {
//       print("Received MethodChannel call: ${call.method}");
//       if (call.method == "chatHeadClicked") {
//         print("Chat Head Clicked! Navigating to SuccessScreen...");
//         NavService.removeAllAndOpen(const SuccessScreen());
//       }
//     });
//   }
// }
