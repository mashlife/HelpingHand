import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

class OverlaySettingsProvider with ChangeNotifier {
  bool _isShowingWindow = false;
  bool get isShowingWindow => _isShowingWindow;

  bool _isPermissionGranted = false;

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    _isPermissionGranted = await FlutterOverlayWindow.isPermissionGranted();
    if (!_isPermissionGranted) {
      _isPermissionGranted =
          await FlutterOverlayWindow.requestPermission() ?? false;
    }
    notifyListeners();
  }

  String overlayTitle = "Trouble finder ON";
  String overlayContent = 'Double tap bubble if you are in danger';

  void showOverlayWindow(BuildContext context) async {
    print("Is windows: $_isShowingWindow");

    if (!_isShowingWindow) {
      if (await FlutterOverlayWindow.isActive()) {
        _isShowingWindow = true;
        overlayTitle = "Trouble finder Active";
        overlayContent = "Press and hold the bubble to stop";
        notifyListeners();
        return;
      }
      initPlatformState();
      await FlutterOverlayWindow.showOverlay(
        enableDrag: true,
        overlayTitle: overlayTitle,
        overlayContent: overlayContent,
        flag: OverlayFlag.defaultFlag,
        visibility: NotificationVisibility.visibilityPublic,
        positionGravity: PositionGravity.none,
        height: (MediaQuery.of(context).size.height * 0.6).toInt(),
        width: WindowSize.matchParent,
        startPosition: const OverlayPosition(0, -50),
      );

      _isShowingWindow = true;
      overlayTitle = "Trouble finder Active";
      overlayContent = "Press and hold the bubble to stop";
      notifyListeners();
    } else {
      await FlutterOverlayWindow.closeOverlay()
          .then((value) => print('STOPPED: value: $value'));

      _isShowingWindow = false;
      overlayTitle = "Trouble finder ON";
      overlayContent = 'Double tap bubble if you are in danger';
      notifyListeners();
    }
  }

  closeOverlayWindow() {}
}
