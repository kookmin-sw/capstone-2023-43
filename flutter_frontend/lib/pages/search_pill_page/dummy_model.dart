import 'dart:convert';

class DummyModel {
  String title;
  String subTitle;
  String company;

  DummyModel({
    required this.title,
    required this.subTitle,
    required this.company,
  });

  DummyModel copyWith({
    String? title,
    String? subTitle,
    String? company,
  }) {
    return DummyModel(
      title: title ?? this.title,
      subTitle: subTitle ?? this.subTitle,
      company: company ?? this.company,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subTitle': subTitle,
      'company': company,
    };
  }

  factory DummyModel.fromMap(Map<String, dynamic> map) {
    return DummyModel(
      title: map['title'] ?? '',
      subTitle: map['subTitle'] ?? '',
      company: map['company'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory DummyModel.fromJson(String source) =>
      DummyModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'DummyModel(title: $title, subTitle: $subTitle, company: $company)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DummyModel &&
        other.title == title &&
        other.subTitle == subTitle &&
        other.company == company;
  }

  @override
  int get hashCode => title.hashCode ^ subTitle.hashCode ^ company.hashCode;
}
