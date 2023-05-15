import 'dart:convert';

class User {
  String name;
  String gender;
  DateTime birthday;
  int bloodPressure;
  bool isDiabetes;
  bool isPregnancy;
  User({
    required this.name,
    required this.gender,
    required this.birthday,
    required this.bloodPressure,
    required this.isDiabetes,
    required this.isPregnancy,
  });

  User copyWith({
    String? name,
    String? gender,
    DateTime? birthday,
    int? bloodPressure,
    bool? isDiabetes,
    bool? isPregnancy,
  }) {
    return User(
      name: name ?? this.name,
      gender: gender ?? this.gender,
      birthday: birthday ?? this.birthday,
      bloodPressure: bloodPressure ?? this.bloodPressure,
      isDiabetes: isDiabetes ?? this.isDiabetes,
      isPregnancy: isPregnancy ?? this.isPregnancy,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'gender': gender,
      'birthday': birthday.toIso8601String(),
      'blood_pressure': bloodPressure,
      'is_diabetes': isDiabetes,
      'is_pregnancy': isPregnancy,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'] ?? '',
      gender: map['gender'] ?? '',
      birthday: DateTime.parse(map['birthday']),
      bloodPressure: map['blood_pressure']?.toInt() ?? 0,
      isDiabetes: map['is_diabetes'] ?? false,
      isPregnancy: map['is_pregnancy'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(name: $name, gender: $gender, birthDay: $birthday, bloodPressure: $bloodPressure, isDiabetes: $isDiabetes, isPregnancy: $isPregnancy)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.name == name &&
        other.gender == gender &&
        other.birthday == birthday &&
        other.bloodPressure == bloodPressure &&
        other.isDiabetes == isDiabetes &&
        other.isPregnancy == isPregnancy;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        gender.hashCode ^
        birthday.hashCode ^
        bloodPressure.hashCode ^
        isDiabetes.hashCode ^
        isPregnancy.hashCode;
  }
}
