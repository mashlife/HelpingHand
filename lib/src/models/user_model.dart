// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

enum UserStatus { safe, unsafe }

class UserModel {
  String? id;
  String? deviceUniqueId;
  String? name;
  UserStatus? currentStatus;
  UserModel({
    this.id,
    this.deviceUniqueId,
    this.name,
    this.currentStatus,
  });

  UserModel copyWith({
    String? id,
    String? deviceUniqueId,
    String? name,
    UserStatus? currentStatus,
  }) {
    return UserModel(
      id: id ?? this.id,
      deviceUniqueId: deviceUniqueId ?? this.deviceUniqueId,
      name: name ?? this.name,
      currentStatus: currentStatus ?? this.currentStatus,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'deviceUniqueId': deviceUniqueId,
      'name': name,
      'currentStatus': currentStatus?.name,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] != null ? map['id'] as String : null,
      deviceUniqueId: map['deviceUniqueId'] != null
          ? map['deviceUniqueId'] as String
          : null,
      name: map['name'] != null ? map['name'] as String : null,
      currentStatus: map['currentStatus'] != null
          ? UserStatus.values
              .firstWhere((e) => e.name == (map['currentStatus']))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(id: $id, deviceUniqueId: $deviceUniqueId, name: $name, currentStatus: $currentStatus)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.deviceUniqueId == deviceUniqueId &&
        other.name == name &&
        other.currentStatus == currentStatus;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        deviceUniqueId.hashCode ^
        name.hashCode ^
        currentStatus.hashCode;
  }
}
