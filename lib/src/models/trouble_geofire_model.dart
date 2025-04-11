// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TroubleGeofireData {
  String? deviceUniqueId;
  double? locationLat;
  double? locationLong;

  TroubleGeofireData({
    this.deviceUniqueId,
    this.locationLat,
    this.locationLong,
  });

  TroubleGeofireData copyWith({
    String? deviceUniqueId,
    double? locationLat,
    double? locationLong,
  }) {
    return TroubleGeofireData(
      deviceUniqueId: deviceUniqueId ?? this.deviceUniqueId,
      locationLat: locationLat ?? this.locationLat,
      locationLong: locationLong ?? this.locationLong,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'deviceUniqueId': deviceUniqueId,
      'locationLat': locationLat,
      'locationLong': locationLong,
    };
  }

  factory TroubleGeofireData.fromMap(Map<String, dynamic> map) {
    return TroubleGeofireData(
      deviceUniqueId: map['deviceUniqueId'] != null
          ? map['deviceUniqueId'] as String
          : null,
      locationLat:
          map['locationLat'] != null ? map['locationLat'] as double : null,
      locationLong:
          map['locationLong'] != null ? map['locationLong'] as double : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TroubleGeofireData.fromJson(String source) =>
      TroubleGeofireData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'TroubleGeofireData(deviceUniqueId: $deviceUniqueId, locationLat: $locationLat, locationLong: $locationLong)';

  @override
  bool operator ==(covariant TroubleGeofireData other) {
    if (identical(this, other)) return true;

    return other.deviceUniqueId == deviceUniqueId &&
        other.locationLat == locationLat &&
        other.locationLong == locationLong;
  }

  @override
  int get hashCode =>
      deviceUniqueId.hashCode ^ locationLat.hashCode ^ locationLong.hashCode;
}
