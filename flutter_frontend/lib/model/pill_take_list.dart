import 'dart:convert';

class PillTakeList {
  String name;
  String historyId;
  String presetId;

  PillTakeList({
    required this.name,
    required this.historyId,
    required this.presetId,
  });

  PillTakeList copyWith({
    String? name,
    String? historyId,
    String? presetId,
  }) {
    return PillTakeList(
      name: name ?? this.name,
      historyId: historyId ?? this.historyId,
      presetId: presetId ?? this.presetId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'historyId': historyId,
      'presetId': presetId,
    };
  }

  factory PillTakeList.fromMap(Map<String, dynamic> map) {
    return PillTakeList(
      name: map['name'] ?? '',
      historyId: map['historyId'] ?? '',
      presetId: map['presetId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PillTakeList.fromJson(String source) =>
      PillTakeList.fromMap(json.decode(source));

  @override
  String toString() =>
      'PillTakeList(name: $name, historyId: $historyId, presetId: $presetId)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PillTakeList &&
        other.name == name &&
        other.historyId == historyId &&
        other.presetId == presetId;
  }

  @override
  int get hashCode => name.hashCode ^ historyId.hashCode ^ presetId.hashCode;
}
