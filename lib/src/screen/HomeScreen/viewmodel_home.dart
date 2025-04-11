import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:helping_hand/src/constants/device_indentifier.dart';
import 'package:helping_hand/src/constants/globals.dart';
import 'package:helping_hand/src/controllers/firebase_controllers.dart';
import 'package:helping_hand/src/controllers/geofire_controller.dart';
import 'package:helping_hand/src/models/trouble_data_model.dart';
import 'package:helping_hand/src/models/trouble_geofire_model.dart';
import 'package:helping_hand/src/screen/TroubleDetails/trouble_details_sheet.dart';
import 'package:helping_hand/src/services/notification_service.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeViewModel extends ChangeNotifier {
  late BuildContext context;
  late GoogleMapController googleMapController;

  bool isMapLoading = false;
  bool showClipper = false;
  bool activeNearbyDriverKeyLoaded = false;
  bool isOffline = false;

  final String _maps_api = "AIzaSyB4OJRICr-sWsToQ5wlVwCJKNgcNzRYuVE";

  Completer<GoogleMapController> completerGoogleMap = Completer();

  LatLng? pickedLocation;
  LatLng currentLocation = const LatLng(0, 0);
  Position? _currentPosition;

  Marker? userMarker;
  Set<Marker> troubleMarkers = {};
  Timer? timer;

  Set<Marker> getMarkers() {
    return {
      ...troubleMarkers, // Spread troubleMarkers Set
      if (userMarker != null) userMarker!, // Add userMarker if it's not null
    };
  }

  init(BuildContext context) {
    this.context = context;
    timer = Timer.periodic(const Duration(minutes: 3), _refreshData);
    notifyListeners();

    getUserLocation();
  }

  _refreshData(Timer? timer) async {
    FirebaseControllers.allTroubles.clear();
    for (TroubleGeofireData eachTrouble in GeofireController.troublesNearby) {
      await FirebaseControllers.getTroubleDataFromFirestore(
        eachTrouble.deviceUniqueId!,
      );
    }
  }

  //location
  getUserLocation() async {
    bool serviceEnabled;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    _checkForPermission();
    _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(_currentPosition);
    if (_currentPosition?.latitude != 0 && _currentPosition?.longitude != 0) {
      //   pickupAddress = await searchAddressForGeographicCoOrdinates(
      //     _currentPosition!,
      //     Provider.of<AppInfoHelper>(context, listen: false),
      //   );

      currentLocation =
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude);

      setUserMarkerOnMap(currentLocation);
      initializeGeoFireListeners();

      // getAddressFromLatLng();
      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: currentLocation, zoom: 18.0),
        ),
      );

      // SharedPref.saveUserPosition(_currentPosition!);
    }

    notifyListeners();
  }

  //complete trouble
  iAmInTrouble() async {
    userMarker = null;
    Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    AppGlobal.deviceUniqueId ??= await DeviceIdentifier.getDeviceUniqueId();
    _currentPosition = pos;
    Geofire.setLocation(AppGlobal.deviceUniqueId!, pos.latitude, pos.longitude);
    final troubleData = TroubleDataModel(
      deviceUniqueId: AppGlobal.deviceUniqueId,
      userName: AppGlobal.user?.name,
      currentStatus: "uploaded",
      createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
      geofireData: TroubleGeofireData(
        deviceUniqueId: AppGlobal.deviceUniqueId,
        locationLat: pos.latitude,
        locationLong: pos.longitude,
      ),
    );
    await FirebaseControllers.sendTroubleData(troubleData);
    notifyListeners();
  }

  victimLocationLive() {
    AppGlobal.streamSubscriptionPosition =
        Geolocator.getPositionStream().listen((position) {
      if (!isOffline && AppGlobal.deviceUniqueId != null) {
        Geofire.setLocation(
            AppGlobal.deviceUniqueId!, position.latitude, position.longitude);
      }

      LatLng latLng = LatLng(position.latitude, position.longitude);
      currentLocation = latLng;

      googleMapController.animateCamera(CameraUpdate.newLatLng(latLng));
    });
    notifyListeners();
  }

  troubleResponseComplete() async {
    if (isOffline) {
      return;
    }
    final done = await Geofire.removeLocation(AppGlobal.deviceUniqueId!);
    if (done == true) {
      AppGlobal.streamSubscriptionPosition!.cancel();
      setUserMarkerOnMap(currentLocation);
      notifyListeners();
      isOffline = true;
    }
  }

  Future<void> checkOffline() async {
    AppGlobal.deviceUniqueId = await DeviceIdentifier.getDeviceUniqueId();
    final location = await Geofire.getLocation(AppGlobal.deviceUniqueId!);
    if (location["error"] == null &&
        location["lng"] != null &&
        location["lat"] != null) {
      isOffline = false;
    } else {
      isOffline = true;
    }
    notifyListeners();
  }

  changeOffline(bool value) async {
    if (value == false) {
      iAmInTrouble();
      victimLocationLive();
    } else if (value == true) {
      troubleResponseComplete();
    }

    notifyListeners();
  }

  //display troubles
  void initializeGeoFireListeners() {
    showClipper = true;
    Geofire.initialize("activeTroubles");
    Geofire.queryAtLocation(
            _currentPosition!.latitude, _currentPosition!.longitude, 15)!
        .listen((map) {
      print("GeoFire Map: $map");

      if (map != null) {
        var callBack = map['callBack'];
        switch (callBack) {
          case Geofire.onKeyEntered:
            GeofireController.addTrouble(map);
            if (activeNearbyDriverKeyLoaded == true) {
              displayTroublesOnMap();
            }
            notifyListeners();
            break;
          case Geofire.onKeyExited:
            GeofireController.troubleResponseComplete(map['key']);
            displayTroublesOnMap();
            notifyListeners();
            break;
          case Geofire.onKeyMoved:
            GeofireController.updateActiveTroubleLocation(map);
            displayTroublesOnMap();
            notifyListeners();
            break;
          case Geofire.onGeoQueryReady:
            activeNearbyDriverKeyLoaded = true;
            displayTroublesOnMap();
            notifyListeners();
            break;

          default:
            return;
        }
      }
    });
  }

  setUserMarkerOnMap(LatLng position) async {
    final Uint8List userIcon =
        await getImages("media/image/current-location.png", 30);

    userMarker = Marker(
      markerId: const MarkerId("userMarker"),
      position: position,
      icon: BitmapDescriptor.fromBytes(userIcon, size: const Size(15, 15)),
      rotation: 0,
    );
    notifyListeners();
  }

  displayTroublesOnMap() async {
    troubleMarkers.clear();

    final Uint8List confirmedIcons =
        await getImages('media/image/trouble.png', 60);
    final Uint8List notConfirmedIcon =
        await getImages('media/image/not-confirmed.png', 40);

    Set<Marker> troubleMarkerSet = <Marker>{};
    for (TroubleGeofireData eachTrouble in GeofireController.troublesNearby) {
      TroubleDataModel? trouble =
          FirebaseControllers.getTroubleFromList(eachTrouble.deviceUniqueId!);
      trouble ??= await FirebaseControllers.getTroubleDataFromFirestore(
          eachTrouble.deviceUniqueId!);
      if (trouble != null) {
        LatLng eachTroubleLatLng =
            LatLng(eachTrouble.locationLat!, eachTrouble.locationLong!);

        Marker marker = Marker(
            markerId: MarkerId(eachTrouble.deviceUniqueId!),
            position: eachTroubleLatLng,
            icon: BitmapDescriptor.fromBytes(
              trouble.currentStatus == "uploaded"
                  ? notConfirmedIcon
                  : confirmedIcons,
              size: const Size(48, 48),
            ),
            rotation: 360,
            onTap: () {
              _onMarkerTapped(eachTrouble.deviceUniqueId!, eachTroubleLatLng);
            });
        troubleMarkerSet.add(marker);
      } else {
        print("Details about travel not found");
      }
    }

    troubleMarkers = troubleMarkerSet;
    notifyListeners();
  }

  void _onMarkerTapped(String key, LatLng position) async {
    googleMapController.animateCamera(
      CameraUpdate.newLatLngZoom(position, 18.0), // Zoom to marker
    );

    // Show Bottom Sheet
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          width: double.infinity,
          child: TroubleDetailsSheet(
            geoKey: key,
            position: position,
          ),
        );
      },
    );
  }

  Future<Uint8List> getImages(String path, int width) async {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetHeight: pixelRatio.round() * width,
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  ///GOOGLE MAPS

  void onMapCreated(GoogleMapController controller) {
    completerGoogleMap.complete(controller);
    googleMapController = controller;
    // getUserLocation();
    isMapLoading = false;
    notifyListeners();
  }

  void disposeView() {
    googleMapController.dispose();

    super.dispose();
  }

  void onCameraMove(CameraPosition? position) {
    if (pickedLocation != position!.target) {
      pickedLocation = position.target;
    }
    notifyListeners();
  }

  onCameraIdle() {
    showClipper = true;
    notifyListeners();
  }

  onCameraMoveStarted() {
    showClipper = false;
    notifyListeners();
  }

  _checkForPermission() async {
    final PermissionStatus locationPermission =
        await Permission.location.status;
    final PermissionStatus notificationPermission =
        await Permission.notification.status;

    if (locationPermission == PermissionStatus.granted &&
        notificationPermission == PermissionStatus.granted) {
      // final notification = await NotificationHelper.getFcmToken();
      // AppGlobal.notificationToken = notification;
      // if (AppGlobal.user!.fcmToken == null || AppGlobal.user!.fcmToken == "") {
      //   await sendFcm(notification!);
      // }
      return;
    } else {
      await Permission.location.request();
      await NotificationHelper().initNotification();
    }
  }
}
