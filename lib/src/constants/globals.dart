import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:helping_hand/src/models/trouble_data_model.dart';
import 'package:helping_hand/src/models/user_model.dart';

class AppGlobal {
  static StreamSubscription<Position>? streamSubscriptionPosition;
  static StreamSubscription<Position>? streamSubscriptionDriverRealtimePosition;
  static String? deviceUniqueId;
  static TroubleDataModel? inTrouble;
  static UserModel? user;
}
