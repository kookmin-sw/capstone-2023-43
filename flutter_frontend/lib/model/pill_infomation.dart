import 'dart:convert';

import 'package:flutter/material.dart';

class PillInfomation {
  final String name;
  final String entpName;
  final String etcOtcCode;
  final String className;
  final String imageUrl;

  PillInfomation({
    required this.name,
    required this.entpName,
    required this.etcOtcCode,
    required this.className,
    required this.imageUrl,
  });

  PillInfomation copyWith({
    String? name,
    String? entpName,
    String? etcOtcCode,
    String? className,
    String? imageUrl,
  }) {
    return PillInfomation(
      name: name ?? this.name,
      entpName: entpName ?? this.entpName,
      etcOtcCode: etcOtcCode ?? this.etcOtcCode,
      className: className ?? this.className,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'entpName': entpName,
      'etcOtcCode': etcOtcCode,
      'className': className,
      'imageUrl': imageUrl,
    };
  }

  factory PillInfomation.fromMap(Map<String, dynamic> map) {
    return PillInfomation(
      name: map['name'] ?? '',
      entpName: map['entpName'] ?? '',
      etcOtcCode: map['etcOtcCode'] ?? 0,
      className: map['className'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PillInfomation.fromJson(String source) =>
      PillInfomation.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PillInfomation(name: $name, entpName: $entpName, etcOtcCode: $etcOtcCode, className: $className, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PillInfomation &&
        other.name == name &&
        other.entpName == entpName &&
        other.etcOtcCode == etcOtcCode &&
        other.className == className &&
        other.imageUrl == imageUrl;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        entpName.hashCode ^
        etcOtcCode.hashCode ^
        className.hashCode ^
        imageUrl.hashCode;
  }
}
