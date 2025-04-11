// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

enum VoteStatus { positive, negative }

class VoteModel {
  String? id;
  String? deviceUniqueId;
  String? troubleId;
  double? voterLat;
  double? voterLong;
  double? troubleLat;
  double? troubleLong;
  String? createdAt;
  VoteStatus? status;
  String? notCountingReason;
  double? voterDistanceTrouble;
  VoteModel({
    this.id,
    this.deviceUniqueId,
    this.troubleId,
    this.voterLat,
    this.voterLong,
    this.troubleLat,
    this.troubleLong,
    this.createdAt,
    this.status,
    this.notCountingReason,
    this.voterDistanceTrouble,
  });

  VoteModel copyWith({
    String? id,
    String? deviceUniqueId,
    String? troubleId,
    double? voterLat,
    double? voterLong,
    double? troubleLat,
    double? troubleLong,
    String? createdAt,
    VoteStatus? status,
    String? notCountingReason,
    double? voterDistanceTrouble,
  }) {
    return VoteModel(
      id: id ?? this.id,
      deviceUniqueId: deviceUniqueId ?? this.deviceUniqueId,
      troubleId: troubleId ?? this.troubleId,
      voterLat: voterLat ?? this.voterLat,
      voterLong: voterLong ?? this.voterLong,
      troubleLat: troubleLat ?? this.troubleLat,
      troubleLong: troubleLong ?? this.troubleLong,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      notCountingReason: notCountingReason ?? this.notCountingReason,
      voterDistanceTrouble: voterDistanceTrouble ?? this.voterDistanceTrouble,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'deviceUniqueId': deviceUniqueId,
      'troubleId': troubleId,
      'voterLat': voterLat,
      'voterLong': voterLong,
      'troubleLat': troubleLat,
      'troubleLong': troubleLong,
      'createdAt': createdAt,
      'status': status?.name,
      'notCountingReason': notCountingReason,
      'voterDistanceTrouble': voterDistanceTrouble,
    };
  }

  factory VoteModel.fromMap(Map<String, dynamic> map) {
    return VoteModel(
      id: map['id'] != null ? map['id'] as String : null,
      deviceUniqueId: map['deviceUniqueId'] != null
          ? map['deviceUniqueId'] as String
          : null,
      troubleId: map['troubleId'] != null ? map['troubleId'] as String : null,
      voterLat: map['voterLat'] != null ? map['voterLat'] as double : null,
      voterLong: map['voterLong'] != null ? map['voterLong'] as double : null,
      troubleLat:
          map['troubleLat'] != null ? map['troubleLat'] as double : null,
      troubleLong:
          map['troubleLong'] != null ? map['troubleLong'] as double : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      status: map['status'] != null
          ? VoteStatus.values.firstWhere((e) => e.name == map['status'])
          : null,
      notCountingReason: map['notCountingReason'] != null
          ? map['notCountingReason'] as String
          : null,
      voterDistanceTrouble: map['voterDistanceTrouble'] != null
          ? map['voterDistanceTrouble'] as double
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory VoteModel.fromJson(String source) =>
      VoteModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'VoteModel(id: $id, deviceUniqueId: $deviceUniqueId, troubleId: $troubleId, voterLat: $voterLat, voterLong: $voterLong, troubleLat: $troubleLat, troubleLong: $troubleLong, createdAt: $createdAt, status: $status, notCountingReason: $notCountingReason, voterDistanceTrouble: $voterDistanceTrouble)';
  }

  @override
  bool operator ==(covariant VoteModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.deviceUniqueId == deviceUniqueId &&
        other.troubleId == troubleId &&
        other.voterLat == voterLat &&
        other.voterLong == voterLong &&
        other.troubleLat == troubleLat &&
        other.troubleLong == troubleLong &&
        other.createdAt == createdAt &&
        other.status == status &&
        other.notCountingReason == notCountingReason &&
        other.voterDistanceTrouble == voterDistanceTrouble;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        deviceUniqueId.hashCode ^
        troubleId.hashCode ^
        voterLat.hashCode ^
        voterLong.hashCode ^
        troubleLat.hashCode ^
        troubleLong.hashCode ^
        createdAt.hashCode ^
        status.hashCode ^
        notCountingReason.hashCode ^
        voterDistanceTrouble.hashCode;
  }
}
