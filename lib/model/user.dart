// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class User {
  String? userId;
  String? displayName;
  String? branchCode;
  String? branchAddress;
  int? role;
  String? accessToken;
  String? refreshToken;
  User({
    this.userId,
    this.displayName,
    this.branchCode,
    this.branchAddress,
    this.role,
    this.accessToken,
    this.refreshToken,
  });

  User copyWith({
    String? userId,
    String? displayName,
    String? branchCode,
    String? branchAddress,
    int? role,
    String? accessToken,
    String? refreshToken,
  }) {
    return User(
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      branchCode: branchCode ?? this.branchCode,
      branchAddress: branchAddress ?? this.branchAddress,
      role: role ?? this.role,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'displayName': displayName,
      'branchCode': branchCode,
      'branchAddress': branchAddress,
      'role': role,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userId: map['userId'] != null ? map['userId'] as String : null,
      displayName:
          map['displayName'] != null ? map['displayName'] as String : null,
      branchCode:
          map['branchCode'] != null ? map['branchCode'] as String : null,
      branchAddress:
          map['branchAddress'] != null ? map['branchAddress'] as String : null,
      role: map['role'] != null ? map['role'] as int : null,
      accessToken:
          map['accessToken'] != null ? map['accessToken'] as String : null,
      refreshToken:
          map['refreshToken'] != null ? map['refreshToken'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(Map<String,dynamic> source) =>
     User.fromMap(source);


  @override
  String toString() {
    return 'User(userId: $userId, displayName: $displayName, branchCode: $branchCode, branchAddress: $branchAddress, role: $role, accessToken: $accessToken, refreshToken: $refreshToken)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.userId == userId &&
        other.displayName == displayName &&
        other.branchCode == branchCode &&
        other.branchAddress == branchAddress &&
        other.role == role &&
        other.accessToken == accessToken &&
        other.refreshToken == refreshToken;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        displayName.hashCode ^
        branchCode.hashCode ^
        branchAddress.hashCode ^
        role.hashCode ^
        accessToken.hashCode ^
        refreshToken.hashCode;
  }
}
