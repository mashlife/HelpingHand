import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:helping_hand/src/screen/HomeScreen/viewmodel_home.dart';
import 'package:helping_hand/src/screen/Settings/overlay/overlay_settings_provider.dart';
import 'package:helping_hand/src/services/navigation_service.dart';
import 'package:helping_hand/src/utils/colors.dart';
import 'package:helping_hand/src/utils/loader-view.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeViewModel _homeViewModel = HomeViewModel();

  static const String _mainAppPort = 'MainApp';
  static const String _overlayAppPort = 'Overlay';

  final _receivePort = ReceivePort();
  SendPort? homePort;
  String? latestMessageFromOverlay;

  @override
  void initState() {
    super.initState();
    _homeViewModel.init(context);
    _initializeMapRenderer();
    _listenerFromOverlay();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _homeViewModel.timer?.cancel();
  }

  void _initializeMapRenderer() {
    final GoogleMapsFlutterPlatform mapsImplementation =
        GoogleMapsFlutterPlatform.instance;
    if (mapsImplementation is GoogleMapsFlutterAndroid) {
      mapsImplementation.useAndroidViewSurface = true;
    }
  }

  _listenerFromOverlay() {
    if (homePort != null) return;
    final res = IsolateNameServer.registerPortWithName(
      _receivePort.sendPort,
      _mainAppPort,
    );
    _receivePort.listen((message) async {
      print("message from Overlay: $message");

      switch (message) {
        case "Action":
          NavService.removeAllAndOpen(const HomeScreen());
          break;
        case "DoubleTap":
          Fluttertoast.showToast(
              msg: _homeViewModel.currentLocation.toString());
          _homeViewModel.changeOffline(false);
          callBackFunction("location-shared");

          // context.read<NativeMethods>().showToast(
          //     _homeViewModel.currentLocation.toString(),
          //     duration: "long");
          break;
        case "check-geofire":
          await _homeViewModel.checkOffline();
          if (_homeViewModel.isOffline) {
            callBackFunction("geofire-offline");
          } else {
            callBackFunction("geofire-online");
          }
          break;
        case "trouble-resolved":
          if (!_homeViewModel.isOffline) {
            _homeViewModel.changeOffline(true);
            callBackFunction("location-unshared");
          }
          break;
        default:
          print("message from OVERLAY: $message");
          break;
      }
    });
  }

  void callBackFunction(String tag) {
    print("Got tag $tag");
    homePort ??= IsolateNameServer.lookupPortByName(
      _overlayAppPort,
    );
    homePort?.send('Date: ${DateTime.now()}');
    homePort?.send(tag);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => _homeViewModel,
      child: Consumer<HomeViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
                backgroundColor: AppColors.secondary,
                foregroundColor: Colors.transparent,
                elevation: 0,
                leading: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(100),
                    onTap: () => viewModel.getUserLocation(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.creamWhite.withOpacity(0.8),
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        'media/image/refresh-position.png',
                        fit: BoxFit.contain,
                        height: 20,
                        width: 20,
                      ),
                    ),
                  ),
                ),
                actions: [
                  Consumer<OverlaySettingsProvider>(
                    builder: (context, overlayProvider, child) {
                      return Switch(
                        value: overlayProvider.isShowingWindow,
                        onChanged: (value) =>
                            overlayProvider.showOverlayWindow(context),
                      );
                    },
                  ),
                ]),
            body: Stack(
              children: [
                GoogleMap(
                  onMapCreated: viewModel.onMapCreated,
                  onCameraMove: viewModel.onCameraMove,
                  onCameraIdle: viewModel.onCameraIdle,
                  onCameraMoveStarted: viewModel.onCameraMoveStarted,
                  myLocationEnabled: false,
                  zoomGesturesEnabled: true,
                  zoomControlsEnabled: false,
                  compassEnabled: false,
                  initialCameraPosition: CameraPosition(
                    target: viewModel.currentLocation,
                    zoom: 18.0,
                  ),
                  mapType: MapType.normal,
                  markers: viewModel.getMarkers(),
                  // polylines: viewModel.polylines,
                ),
                // Visibility(
                //   // visible: viewModel.destinationAddress == null,
                //   visible: !viewModel.isMapLoading && viewModel.showClipper,
                //   child: Align(
                //     alignment: Alignment.center,
                //     child: Padding(
                //       padding: const EdgeInsets.all(8.0),
                //       child: Image.asset(
                //         'media/image/location.png',
                //         height: 30,
                //         width: 30,
                //       ),
                //     ),
                //   ),
                // ),
                Visibility(
                  visible: viewModel.isMapLoading,
                  child: const LoaderView(color: Colors.transparent),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
