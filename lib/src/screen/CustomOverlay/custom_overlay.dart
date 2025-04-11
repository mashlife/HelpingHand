import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

class CustomOverlay extends StatefulWidget {
  const CustomOverlay({super.key});

  @override
  State<CustomOverlay> createState() => _CustomOverlayState();
}

class _CustomOverlayState extends State<CustomOverlay> {
  static const String _mainAppPort = 'MainApp';
  static const String _overlayAppPort = 'Overlay';

  bool showCancel = false;
  final _receivePort = ReceivePort();
  SendPort? mainAppPort;
  String? messageFromOverlay;

  final GlobalKey _floatingKey = GlobalKey();
  Size? floatingSize;

  bool isActive = false;
  IconData isDone = Icons.dangerous;
  Color iconBc = Colors.green;

  Duration _duration = const Duration(seconds: 5);
  Timer? _timer;
  int _countdownValue = 0;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _countdownValue = _duration.inSeconds;
        _duration = _duration - const Duration(seconds: 1);
      });

      if (_countdownValue > 0) {
        print("Still not done");
        return;
      } else {
        overlayCallback("trouble-resolved");
        _timer?.cancel();
      }
      print("New count value: $_countdownValue");
      print("New duration value: ${_duration.inSeconds}");
    });
  }

  @override
  void initState() {
    super.initState();

    _listenForIsolate();
    overlayCallback("check-geofire");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getFloatingSize();
    });
  }

  _listenForIsolate() {
    if (mainAppPort != null) return;
    final res = IsolateNameServer.registerPortWithName(
      _receivePort.sendPort,
      _overlayAppPort,
    );
    print("$res : HOME");
    mainAppPort = IsolateNameServer.lookupPortByName(_mainAppPort);
    _receivePort.listen((message) {
      print("message from Ui: $message");
      switch (message) {
        case "location-shared":
          print("received location is shared");
          setState(() {
            isActive = true;
            isDone = Icons.alarm;
            iconBc = Colors.red;
          });
          break;
        case "geofire-offline":
          setState(() {
            isActive = false;
          });
          break;
        case "geofire-online":
          setState(() {
            isActive = true;
          });
          break;
        case "location-unshared":
          setState(() {
            isActive = false;
            isDone = Icons.dangerous;
            iconBc = Colors.green;
          });
          break;
        default:
          setState(() {
            messageFromOverlay = 'message from UI: $message';
          });
          break;
      }
    });
  }

  getFloatingSize() {
    RenderObject? floatingObj = _floatingKey.currentContext!.findRenderObject();
    if (floatingObj is RenderBox) {
      floatingSize = floatingObj.size;

      setState(() {}); // Update UI
    } else {
      print("Nothing");
    }
  }

  void overlayCallback(String tag) {
    print("Got tag $tag");
    mainAppPort ??= IsolateNameServer.lookupPortByName(
      _mainAppPort,
    );
    mainAppPort?.send('Date: ${DateTime.now()}');
    mainAppPort?.send(tag);
  }

  onDragUpdate(BuildContext context, DragUpdateDetails dragUpdate) async {
    // //Gesture Location

    // final RenderObject? box = context.findRenderObject();
    // if (box == null || (box is! RenderBox)) {
    //   print("No render object found");
    //   return;
    // }
    // final Offset offset = box.globalToLocal(dragUpdate.globalPosition);
    // print("Current offset: ${offset.toString()}");

    // //Get screen area
    // const double startX = 0;
    // final double endX = context.size!.width - floatingSize!.width;

    // final double startY = MediaQuery.of(context).padding.top;
    // final double endY = context.size!.height - floatingSize!.height;

    // //Make sure the widget is inside the Screen area
    // if (startX < offset.dx && offset.dx < endX) {
    //   if (startY < offset.dy && offset.dy < endY) {
    //     //Update the location
    //     // await FlutterOverlayWindow.moveOverlay(
    //     //     OverlayPosition(offset.dx, offset.dy));
    //   }
    // }

    setState(() {
      showCancel = true;
    });
  }

  double shadowX = -2;

  onDragEnd(BuildContext context, DragEndDetails dragEnd) async {
    //Make sure the widget is positioned in left or right

    ///Check last location
    // Point of Half
    final double pointX = context.size!.width / 2;
    final position = await FlutterOverlayWindow.getOverlayPosition();
    double x = 0;

    OverlayPosition? overlayPosition;
    // if (position.x + (floatingSize!.width / 2) < pointX) {
    //   overlayPosition = OverlayPosition(0, position.y);
    //   x = -2;
    // }
    // // else if (position.x + (floatingSize!.width / 2) == pointX) {
    // //   overlayPosition = OverlayPosition(0, position.y);
    // //   x = -2;
    // // }
    // else {
    //   overlayPosition = OverlayPosition(
    //       context.size!.width - floatingSize!.width, position.y);
    //   x = 2;
    // }
    overlayPosition = OverlayPosition(0, position.y);

    print("Found position: ${overlayPosition.toString()}");
    await FlutterOverlayWindow.moveOverlay(overlayPosition);
    final positionAse = await FlutterOverlayWindow.getOverlayPosition();
    print("Final position: ${positionAse.toString()}");

    setState(() {
      showCancel = false;
      shadowX = x;
    });
  }

  onLongPress() {
    setState(() {
      _countdownValue = 0;
      _duration = const Duration(seconds: 5);
    });
    startTimer();
  }

  onLongPressEnd(BuildContext context, LongPressEndDetails details) {
    _timer?.cancel();
    setState(() {
      _countdownValue = 0;
      _duration = const Duration(seconds: 5);
    });
  }

  Widget overlay() {
    return GestureDetector(
      onVerticalDragUpdate: (DragUpdateDetails dragUpdate) =>
          onDragUpdate(context, dragUpdate),
      onHorizontalDragUpdate: (DragUpdateDetails dragUpdate) =>
          onDragUpdate(context, dragUpdate),
      onVerticalDragEnd: (DragEndDetails details) =>
          onDragEnd(context, details),
      onHorizontalDragEnd: (DragEndDetails details) =>
          onDragEnd(context, details),
      onLongPress: isActive ? onLongPress : null,
      onLongPressEnd: isActive
          ? (LongPressEndDetails details) => onLongPressEnd(context, details)
          : null,
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: showCancel
              ? null
              : [
                  BoxShadow(
                    offset: Offset(shadowX, 2),
                    blurRadius: 1,
                    spreadRadius: 1,
                  )
                ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: FloatingActionButton(
            backgroundColor: iconBc,
            onPressed: null,
            key: _floatingKey,
            child: InkWell(
              onDoubleTap: !isActive
                  ? () {
                      overlayCallback("DoubleTap");
                    }
                  : null,
              // onLongPress: isActive ? onLongPress : null,
              onTap: () async {},
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    isDone,
                    size: 30,
                    color: Colors.black,
                  ),
                  SizedBox(
                    height: 80,
                    width: 80,
                    child: CircularProgressIndicator(
                      color: Colors.blue[700],
                      strokeWidth: 12,
                      strokeCap: StrokeCap.round,
                      value: _countdownValue / 5,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: overlay(),
      ),
    );
  }
}
