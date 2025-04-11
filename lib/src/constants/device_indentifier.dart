import 'package:flutter_udid/flutter_udid.dart';

class DeviceIdentifier {
  static Future<String> getDeviceUniqueId() async {
    return await FlutterUdid.udid;
  }
}
