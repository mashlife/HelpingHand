// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:helping_hand/src/models/trouble_geofire_model.dart';

enum TroubleStatus { uploaded, voteComplete, resolved }

class TroubleDataModel {
  String? id;
  String? deviceUniqueId;
  String? userName;
  String? currentStatus;
  String? createdAt;
  String? resolvedAt;
  int? positiveVotes;
  int? negativeVotes;
  bool? isResolved;
  TroubleGeofireData? geofireData;
  TroubleDataModel({
    this.id,
    this.deviceUniqueId,
    this.userName,
    this.currentStatus,
    this.createdAt,
    this.resolvedAt,
    this.positiveVotes,
    this.negativeVotes,
    this.isResolved,
    this.geofireData,
  });

  TroubleDataModel copyWith({
    String? id,
    String? deviceUniqueId,
    String? userName,
    String? currentStatus,
    String? createdAt,
    String? resolvedAt,
    int? positiveVotes,
    int? negativeVotes,
    bool? isResolved,
    TroubleGeofireData? geofireData,
  }) {
    return TroubleDataModel(
      id: id ?? this.id,
      deviceUniqueId: deviceUniqueId ?? this.deviceUniqueId,
      userName: userName ?? this.userName,
      currentStatus: currentStatus ?? this.currentStatus,
      createdAt: createdAt ?? this.createdAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      positiveVotes: positiveVotes ?? this.positiveVotes,
      negativeVotes: negativeVotes ?? this.negativeVotes,
      isResolved: isResolved ?? this.isResolved,
      geofireData: geofireData ?? this.geofireData,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'deviceUniqueId': deviceUniqueId,
      'userName': userName,
      'currentStatus': currentStatus,
      'createdAt': createdAt,
      'resolvedAt': resolvedAt,
      'positiveVotes': positiveVotes,
      'negativeVotes': negativeVotes,
      'isResolved': isResolved,
      'geofireData': geofireData?.toMap(),
    };
  }

  factory TroubleDataModel.fromMap(Map<String, dynamic> map) {
    return TroubleDataModel(
      id: map['id'] != null ? map['id'] as String : null,
      deviceUniqueId: map['deviceUniqueId'] != null
          ? map['deviceUniqueId'] as String
          : null,
      userName: map['userName'] != null ? map['userName'] as String : null,
      currentStatus:
          map['currentStatus'] != null ? map['currentStatus'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      resolvedAt:
          map['resolvedAt'] != null ? map['resolvedAt'] as String : null,
      positiveVotes:
          map['positiveVotes'] != null ? map['positiveVotes'] as int : null,
      negativeVotes:
          map['negativeVotes'] != null ? map['negativeVotes'] as int : null,
      isResolved: map['isResolved'] != null ? map['isResolved'] as bool : null,
      geofireData: map['geofireData'] != null
          ? TroubleGeofireData.fromMap(
              map['geofireData'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TroubleDataModel.fromJson(String source) =>
      TroubleDataModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TroubleDataModel(id: $id, deviceUniqueId: $deviceUniqueId, userName: $userName, currentStatus: $currentStatus, createdAt: $createdAt, resolvedAt: $resolvedAt, positiveVotes: $positiveVotes, negativeVotes: $negativeVotes, isResolved: $isResolved, geofireData: $geofireData)';
  }

  @override
  bool operator ==(covariant TroubleDataModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.deviceUniqueId == deviceUniqueId &&
        other.userName == userName &&
        other.currentStatus == currentStatus &&
        other.createdAt == createdAt &&
        other.resolvedAt == resolvedAt &&
        other.positiveVotes == positiveVotes &&
        other.negativeVotes == negativeVotes &&
        other.isResolved == isResolved &&
        other.geofireData == geofireData;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        deviceUniqueId.hashCode ^
        userName.hashCode ^
        currentStatus.hashCode ^
        createdAt.hashCode ^
        resolvedAt.hashCode ^
        positiveVotes.hashCode ^
        negativeVotes.hashCode ^
        isResolved.hashCode ^
        geofireData.hashCode;
  }
}
