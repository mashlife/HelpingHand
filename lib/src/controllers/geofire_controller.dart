import 'package:helping_hand/src/controllers/firebase_controllers.dart';
import 'package:helping_hand/src/models/trouble_geofire_model.dart';

class GeofireController {
  static List<TroubleGeofireData> troublesNearby = [];

  static void addTrouble(dynamic map) {
    TroubleGeofireData troubleNearby = TroubleGeofireData();
    troubleNearby.deviceUniqueId = map["key"];
    troubleNearby.locationLat = map["latitude"];
    troubleNearby.locationLong = map["longitude"];
    troublesNearby.add(troubleNearby);
  }

  static void troubleResponseComplete(String userId) {
    int indexNumber = troublesNearby
        .indexWhere((element) => element.deviceUniqueId == userId);
    troublesNearby.removeAt(indexNumber);
    FirebaseControllers.deleteTroubleData(userId);
  }

  static void updateActiveTroubleLocation(dynamic map) {
    TroubleGeofireData troublesMoved = TroubleGeofireData(
      deviceUniqueId: map["key"],
      locationLat: map["latitude"],
      locationLong: map["longitude"],
    );

    int indexNumber = troublesNearby.indexWhere(
        (element) => element.deviceUniqueId == troublesMoved.deviceUniqueId);

    if (indexNumber != -1) {
      troublesNearby[indexNumber].locationLat = troublesMoved.locationLat;
      troublesNearby[indexNumber].locationLong = troublesMoved.locationLong;
    } else {
      troublesNearby.add(troublesMoved);
      print(
          "Warning: Could not find trouble to update with ID: ${troublesMoved.deviceUniqueId}");
    }
  }
}
