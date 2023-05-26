import 'dart:convert';

import 'package:flutter/foundation.dart';

class SchduleData {
  String id;
  DateTime startDate;
  DateTime endDate;
  String name;
  List<int> pills;
  List<String> presetTimes;
  Map<String, List<dynamic>> timeStamp;

  SchduleData({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.name,
    required this.pills,
    required this.presetTimes,
    required this.timeStamp,
  });

  SchduleData copyWith({
    String? id,
    DateTime? startDate,
    DateTime? endDate,
    String? name,
    List<int>? pills,
    List<String>? presetTimes,
    Map<String, List<dynamic>>? timeStamp,
  }) {
    return SchduleData(
      id: id ?? this.id,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      name: name ?? this.name,
      pills: pills ?? this.pills,
      presetTimes: presetTimes ?? this.presetTimes,
      timeStamp: timeStamp ?? this.timeStamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'name': name,
      'pills': pills,
      'preset_times': presetTimes,
      'timestamp': timeStamp,
    };
  }

  factory SchduleData.fromMap(Map<String, dynamic> map) {
    return SchduleData(
      id: map['id'],
      startDate: DateTime.parse(map['start_date']),
      endDate: DateTime.parse(map['end_date']),
      name: map['name'] ?? '',
      pills: List<int>.from(map['pills']),
      presetTimes: List<String>.from(map['preset_times']),
      timeStamp: Map<String, List<dynamic>>.from(map['timestamp']),
    );
  }

  String toJson() => json.encode(toMap());

  factory SchduleData.fromJson(String source) =>
      SchduleData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SchduleData(id: $id, startDate: $startDate, endDate: $endDate, name: $name, pills: $pills, presetTimes: $presetTimes, timestamp: $timeStamp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SchduleData &&
        other.id == id &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.name == name &&
        listEquals(other.pills, pills) &&
        listEquals(other.presetTimes, presetTimes) &&
        mapEquals(other.timeStamp, timeStamp);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        startDate.hashCode ^
        endDate.hashCode ^
        name.hashCode ^
        pills.hashCode ^
        presetTimes.hashCode ^
        timeStamp.hashCode;
  }
}
