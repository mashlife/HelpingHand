// import 'dart:async';
// import 'dart:developer';
// import 'dart:math' as math;

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:helping_hand/src/services/bubble_service.dart';
// import 'package:helping_hand/src/services/notification_service.dart';

// class SecondHome extends StatefulWidget {
//   const SecondHome({super.key});

//   @override
//   State<SecondHome> createState() => _SecondHomeState();
// }

// class _SecondHomeState extends State<SecondHome> with WidgetsBindingObserver {
//   String msg = 'Unknown';
//   final _bubblePlugin = BubbleService.I;

//   bool inTrip = false;

//   bool serviceStarted = true;

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     log(state.name, name: 'APP STATE');
//     log(inTrip.toString(), name: 'IS SERVICE WORKING?');

//     if (!inTrip) return;
//     switch (state) {
//       case AppLifecycleState.resumed:
//         clearNotificationService();
//         stopService();
//         break;
//       case AppLifecycleState.paused:
//         startService();
//         break;
//       default:
//         break;
//     }
//   }

//   @override
//   void initState() {
//     clearNotificationService();
//     WidgetsBinding.instance.addObserver(this);
//     //Request notification permission for android 13 and above
//     NotificationService().requestNotificationPermission(context);

//     //Init The Service, Without init the service you cannot start it
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       _bubblePlugin
//           .initService(
//         screenHeight: MediaQuery.sizeOf(context).height,
//       )
//           .then((value) {
//         serviceStarted = value ?? false;
//         setState(() {});
//       });
//     });
//     super.initState();
//   }

//   @override
//   void didChangeMetrics() {
//     stopService();
//     super.didChangeMetrics();
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }

//   Future<void> startService() async {
//     bool serviceWorks;
//     try {
//       const double navigationBar = 40;
//       if (!mounted) return;
//       final double density = MediaQuery.of(context).devicePixelRatio;
//       final double screenHeight = MediaQuery.of(context).size.height;
//       final double screenWidth = MediaQuery.of(context).size.width * density;
//       log(
//         {
//           'screenWidth-P.P': screenWidth,
//           'screenHeight-L.P': screenHeight,
//           'density-DPR': density,
//           'navigationBarHeight': navigationBar,
//         }.toString(),
//         name: 'From Flutter Side'.toUpperCase(),
//       );
//       int randomNum = math.Random().nextInt(500);
//       serviceWorks = await _bubblePlugin.startService() ?? false;

//       if (!serviceWorks) return;
//     } on PlatformException catch (e) {
//       serviceWorks = false;
//       log(e.message.toString(), name: 'START SERVICE ERROR');
//     }
//     if (!mounted) return;

//     setState(() {
//       msg = (serviceWorks
//           ? "Success starting chat head service"
//           : "Error when starting chat head service");
//     });
//   }

//   Future<void> stopService() async {
//     bool serviceStop;
//     try {
//       serviceStop = await _bubblePlugin.stopService() ?? false;
//     } on PlatformException catch (e) {
//       log(e.message.toString(), name: 'START SERVICE ERROR');
//       serviceStop = false;
//     }
//     if (!mounted) return;

//     setState(() {
//       msg = (serviceStop
//           ? "Success stop chat head service"
//           : "Error when stop hat head service");
//     });
//   }

//   Future<void> clearNotificationService() async =>
//       _bubblePlugin.clearNotificationService();

//   // Future<double> getNavHeight() async {
//   //   final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
//   //   final screenHeight = MediaQuery.of(context).size.height;

//   //   final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
//   //   final AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
//   //   final deviceHeight = androidInfo.displayMetrics.heightPx;

//   //   final androidNavHeight = deviceHeight / devicePixelRatio - screenHeight;
//   //   return androidNavHeight;
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text('Bubble Plugin'),
//       ),
//       body: SizedBox(
//         width: MediaQuery.of(context).size.width,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('$msg\n'),
//             if (serviceStarted) ...[
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () async {
//                   if (!inTrip) {
//                     final hasAPermission =
//                         await _bubblePlugin.checkPermission();

//                     if (!(hasAPermission ?? true)) {
//                       await _bubblePlugin.askPermission();
//                       return;
//                     }
//                   }
//                   inTrip = !inTrip;

//                   log(inTrip.toString(), name: 'bubbleIsWorking');
//                   setState(() {});
//                 },
//                 child: Text(inTrip ? 'Stop trip' : 'Start trip'),
//               ),
//             ]
//           ],
//         ),
//       ),
//     );
//   }
// }
