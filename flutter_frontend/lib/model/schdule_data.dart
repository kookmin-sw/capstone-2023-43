import 'dart:convert';

import 'package:flutter/foundation.dart';

class SchduleData {
  DateTime startDate;
  DateTime endDate;
  String name;
  List<String> pills;

  SchduleData({
    required this.startDate,
    required this.endDate,
    required this.name,
    required this.pills,
  });

  SchduleData copyWith({
    DateTime? startDate,
    DateTime? endDate,
    String? name,
    List<String>? pills,
  }) {
    return SchduleData(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      name: name ?? this.name,
      pills: pills ?? this.pills,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'name': name,
      'pills': pills,
    };
  }

  factory SchduleData.fromMap(Map<String, dynamic> map) {
    return SchduleData(
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      name: map['name'] ?? '',
      pills: List<String>.from(map['pills']),
    );
  }

  String toJson() => json.encode(toMap());

  factory SchduleData.fromJson(String source) =>
      SchduleData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SchduleData(startDate: $startDate, endDate: $endDate, name: $name, pills: $pills)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SchduleData &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.name == name &&
        listEquals(other.pills, pills);
  }

  @override
  int get hashCode {
    return startDate.hashCode ^
        endDate.hashCode ^
        name.hashCode ^
        pills.hashCode;
  }
}
