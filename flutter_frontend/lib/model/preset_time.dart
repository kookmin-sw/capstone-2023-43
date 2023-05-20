import 'dart:convert';
import 'package:date_format/date_format.dart';

class PresetTime {
  String id;
  String name;
  DateTime time;
  PresetTime({
    required this.id,
    required this.name,
    required this.time,
  });

  PresetTime copyWith({
    String? id,
    String? name,
    DateTime? time,
  }) {
    return PresetTime(
      id: id ?? this.id,
      name: name ?? this.name,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    var format = formatDate(time, [HH, ":", nn, ":", ss]);
    return {
      'id': id,
      'name': name,
      'time': format,
    };
  }

  factory PresetTime.fromMap(Map<String, dynamic> map) {
    var time = map['time'] as String;
    var parsed = time.split(":");
    return PresetTime(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      time: DateTime(
        0,
        0,
        0,
        int.parse(parsed[0]),
        int.parse(parsed[1]),
        int.parse(parsed[2]),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory PresetTime.fromJson(String source) =>
      PresetTime.fromMap(json.decode(source));

  @override
  String toString() => 'PresetTime(id: $id, name: $name, time: $time)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PresetTime &&
        other.id == id &&
        other.name == name &&
        other.time == time;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ time.hashCode;
}
