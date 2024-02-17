import 'dart:convert';

import 'package:flutter/foundation.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class HoaDon {
  final String? id;
  final String? customerName;
  final String? customerCode;
  final String? branchCode;
  final String? branchAddress;
  final String? phone;
  final double? billCode;
  final String? startTime;
  final String? doctor;
  final String? serviceName;
  final int? amount;
  final double? unitPrice;
  final int? level;
  final String? levelName;
  final Map<String, String>? comment;
  final String? otherComment;
  HoaDon({
    this.id,
    this.customerName,
    this.customerCode,
    this.branchCode,
    this.branchAddress,
    this.phone,
    this.billCode,
    this.startTime,
    this.doctor,
    this.serviceName,
    this.amount,
    this.unitPrice,
    this.level,
    this.levelName,
    this.comment,
    this.otherComment,
  });

  HoaDon copyWith({
    String? id,
    String? customerName,
    String? customerCode,
    String? branchCode,
    String? branchAddress,
    String? phone,
    double? billCode,
    String? startTime,
    String? doctor,
    String? serviceName,
    int? amount,
    double? unitPrice,
    int? level,
    String? levelName,
    Map<String, String>? comment,
    String? otherComment,
  }) {
    return HoaDon(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      customerCode: customerCode ?? this.customerCode,
      branchCode: branchCode ?? this.branchCode,
      branchAddress: branchAddress ?? this.branchAddress,
      phone: phone ?? this.phone,
      billCode: billCode ?? this.billCode,
      startTime: startTime ?? this.startTime,
      doctor: doctor ?? this.doctor,
      serviceName: serviceName ?? this.serviceName,
      amount: amount ?? this.amount,
      unitPrice: unitPrice ?? this.unitPrice,
      level: level ?? this.level,
      levelName: levelName ?? this.levelName,
      comment: comment ?? this.comment,
      otherComment: otherComment ?? this.otherComment,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'customerName': customerName,
      'customerCode': customerCode,
      'branchCode': branchCode,
      'branchAddress': branchAddress,
      'phone': phone,
      'billCode': billCode,
      'startTime': startTime,
      'doctor': doctor,
      'serviceName': serviceName,
      'amount': amount,
      'unitPrice': unitPrice,
      'level': level,
      'levelName': levelName,
      'comment': comment,
      'otherComment': otherComment,
    };
  }

  factory HoaDon.fromMap(Map<String, dynamic> map) {
    return HoaDon(
      id: map['id'] != null ? map['id'] as String : null,
      customerName:
          map['customerName'] != null ? map['customerName'] as String : null,
      customerCode:
          map['customerCode'] != null ? map['customerCode'] as String : null,
      branchCode:
          map['branchCode'] != null ? map['branchCode'] as String : null,
      branchAddress:
          map['branchAddress'] != null ? map['branchAddress'] as String : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      billCode: map['billCode'] != null ? map['billCode'] as double : null,
      startTime: map['startTime'] != null ? map['startTime'] as String : null,
      doctor: map['doctor'] != null ? map['doctor'] as String : null,
      serviceName:
          map['serviceName'] != null ? map['serviceName'] as String : null,
      amount: map['amount'] != null ? map['amount'] as int : null,
      unitPrice: map['unitPrice'] != null ? map['unitPrice'] as double : null,
      level: map['level'] != null ? map['level'] as int : null,
      levelName: map['levelName'] != null ? map['levelName'] as String : null,
      comment: map['comment'] != null
          ? Map<String, String>.from((map['comment'] as Map<String, String>))
          : null,
      otherComment:
          map['otherComment'] != null ? map['otherComment'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory HoaDon.fromJson(Map<String, dynamic> json) {
    return HoaDon(
      id: json['id'],
      customerName: json['customerName'],
      customerCode: json['customerCode'],
      branchCode: json['branchCode'],
      branchAddress: json['branchAddress'],
      phone: json['phone'],
      billCode: json['billCode'],
      startTime: json['startTime'],
      doctor: json['doctor'],
      serviceName: json['serviceName'],
      amount: json['amount'],
      unitPrice: json['unitPrice'],
      level: json['level'],
      levelName: json['levelName'],
      comment: json['comment'],
      otherComment: json['otherComment'],
    );
  }

  @override
  String toString() {
    return 'HoaDon(id: $id, customerName: $customerName, customerCode: $customerCode, branchCode: $branchCode, branchAddress: $branchAddress, phone: $phone, billCode: $billCode, startTime: $startTime, doctor: $doctor, serviceName: $serviceName, amount: $amount, unitPrice: $unitPrice, level: $level, levelName: $levelName, comment: $comment, otherComment: $otherComment)';
  }

  @override
  bool operator ==(covariant HoaDon other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.customerName == customerName &&
        other.customerCode == customerCode &&
        other.branchCode == branchCode &&
        other.branchAddress == branchAddress &&
        other.phone == phone &&
        other.billCode == billCode &&
        other.startTime == startTime &&
        other.doctor == doctor &&
        other.serviceName == serviceName &&
        other.amount == amount &&
        other.unitPrice == unitPrice &&
        other.level == level &&
        other.levelName == levelName &&
        mapEquals(other.comment, comment) &&
        other.otherComment == otherComment;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        customerName.hashCode ^
        customerCode.hashCode ^
        branchCode.hashCode ^
        branchAddress.hashCode ^
        phone.hashCode ^
        billCode.hashCode ^
        startTime.hashCode ^
        doctor.hashCode ^
        serviceName.hashCode ^
        amount.hashCode ^
        unitPrice.hashCode ^
        level.hashCode ^
        levelName.hashCode ^
        comment.hashCode ^
        otherComment.hashCode;
  }
}
