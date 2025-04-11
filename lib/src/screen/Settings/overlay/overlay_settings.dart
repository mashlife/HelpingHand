import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:helping_hand/src/screen/HomeScreen/home_screen.dart';
import 'package:helping_hand/src/screen/Settings/overlay/overlay_settings_provider.dart';
import 'package:helping_hand/src/services/navigation_service.dart';
import 'package:provider/provider.dart';

class OverlaySettings extends StatefulWidget {
  const OverlaySettings({super.key});

  @override
  _OverlaySettingsState createState() => _OverlaySettingsState();
}

class _OverlaySettingsState extends State<OverlaySettings> {
  static const String _mainAppPort = 'MainApp';
  final _receivePort = ReceivePort();
  SendPort? homePort;
  String? latestMessageFromOverlay;

  @override
  void initState() {
    super.initState();
    // context.read<OverlaySettingsProvider>().requestPermissions();
    context.read<OverlaySettingsProvider>().initPlatformState();

    if (homePort != null) return;
    final res = IsolateNameServer.registerPortWithName(
      _receivePort.sendPort,
      _mainAppPort,
    );
    log("$res: OVERLAY");
    _receivePort.listen((message) {
      switch (message) {
        case "Action":
          NavService.removeAllAndOpen(const HomeScreen());
          break;
        case "DoubleTap":
          Fluttertoast.showToast(
            msg: 'What is this?',
            toastLength: Toast.LENGTH_LONG,
            fontSize: 13,
            backgroundColor: Colors.red,
          );
          // context
          //     .read<NativeMethods>()
          //     .showToast('Are we goinng to die?', duration: "long");
          break;
        default:
          log("message from OVERLAY: $message");
          break;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OverlaySettingsProvider>(
      builder: (BuildContext context, OverlaySettingsProvider viewModel,
          Widget? child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
                'System Alert Window Example App \n with flutterview'),
          ),
          body: Center(
            child: Column(
              children: <Widget>[
                const Text('Running on: platformVersion\n'),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: MaterialButton(
                    onPressed: () => viewModel.showOverlayWindow(context),
                    textColor: Colors.white,
                    color: Colors.deepOrange,
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: !viewModel.isShowingWindow
                        ? const Text("Show system alert window")
                        : const Text("Close system alert window"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: MaterialButton(
                    onPressed: () async => await FlutterOverlayWindow.shareData(
                        "Hello from the other side"),
                    textColor: Colors.white,
                    color: Colors.deepOrange,
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: const Text("send message to overlay"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
