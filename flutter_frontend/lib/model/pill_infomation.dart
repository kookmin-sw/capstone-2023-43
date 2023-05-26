import 'dart:convert';

import 'package:flutter/material.dart';

class PillInfomation {
  final int itemSeq;
  final String name;
  final String entpName;
  final String etcOtcCode;
  final String className;
  final String imageUrl;

  PillInfomation({
    required this.itemSeq,
    required this.name,
    required this.entpName,
    required this.etcOtcCode,
    required this.className,
    required this.imageUrl,
  });

  PillInfomation copyWith({
    int? itemSeq,
    String? name,
    String? entpName,
    String? etcOtcCode,
    String? className,
    String? imageUrl,
  }) {
    return PillInfomation(
      itemSeq: itemSeq ?? this.itemSeq,
      name: name ?? this.name,
      entpName: entpName ?? this.entpName,
      etcOtcCode: etcOtcCode ?? this.etcOtcCode,
      className: className ?? this.className,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'itemSeq': itemSeq,
      'name': name,
      'entpName': entpName,
      'etcOtcCode': etcOtcCode,
      'className': className,
      'imageUrl': imageUrl,
    };
  }

  factory PillInfomation.fromMap(Map<String, dynamic> map) {
    return PillInfomation(
      itemSeq: map['itemSeq'] ?? '',
      name: map['name'] ?? '',
      entpName: map['entpName'] ?? '',
      etcOtcCode: map['etcOtcCode'] ?? '',
      className: map['className'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PillInfomation.fromJson(String source) =>
      PillInfomation.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PillInfomation(itemSeq: $itemSeq, name: $name, entpName: $entpName, etcOtcCode: $etcOtcCode, className: $className, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PillInfomation &&
        other.itemSeq == itemSeq &&
        other.name == name &&
        other.entpName == entpName &&
        other.etcOtcCode == etcOtcCode &&
        other.className == className &&
        other.imageUrl == imageUrl;
  }

  @override
  int get hashCode {
    return itemSeq.hashCode ^
        name.hashCode ^
        entpName.hashCode ^
        etcOtcCode.hashCode ^
        className.hashCode ^
        imageUrl.hashCode;
  }
}
