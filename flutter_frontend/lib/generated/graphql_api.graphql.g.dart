// GENERATED CODE - DO NOT MODIFY BY HAND
// @dart=2.12

part of 'graphql_api.graphql.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchByKeyword$QueryRoot$PbPillInfo
    _$SearchByKeyword$QueryRoot$PbPillInfoFromJson(Map<String, dynamic> json) =>
        SearchByKeyword$QueryRoot$PbPillInfo()
          ..entpName = json['entp_name'] as String
          ..name = json['name'] as String;

Map<String, dynamic> _$SearchByKeyword$QueryRoot$PbPillInfoToJson(
        SearchByKeyword$QueryRoot$PbPillInfo instance) =>
    <String, dynamic>{
      'entp_name': instance.entpName,
      'name': instance.name,
    };

SearchByKeyword$QueryRoot _$SearchByKeyword$QueryRootFromJson(
        Map<String, dynamic> json) =>
    SearchByKeyword$QueryRoot()
      ..pbPillInfo = (json['pb_pill_info'] as List<dynamic>)
          .map((e) => SearchByKeyword$QueryRoot$PbPillInfo.fromJson(
              e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$SearchByKeyword$QueryRootToJson(
        SearchByKeyword$QueryRoot instance) =>
    <String, dynamic>{
      'pb_pill_info': instance.pbPillInfo.map((e) => e.toJson()).toList(),
    };

SearchPillList$QueryRoot$PbPillInfo
    _$SearchPillList$QueryRoot$PbPillInfoFromJson(Map<String, dynamic> json) =>
        SearchPillList$QueryRoot$PbPillInfo()
          ..itemSeq = json['item_seq'] as int
          ..name = json['name'] as String
          ..entpName = json['entp_name'] as String
          ..etcOtcCode = json['etc_otc_code'] as String
          ..className = json['class_name'] as String?
          ..imageUrl = json['image_url'] as String?;

Map<String, dynamic> _$SearchPillList$QueryRoot$PbPillInfoToJson(
        SearchPillList$QueryRoot$PbPillInfo instance) =>
    <String, dynamic>{
      'item_seq': instance.itemSeq,
      'name': instance.name,
      'entp_name': instance.entpName,
      'etc_otc_code': instance.etcOtcCode,
      'class_name': instance.className,
      'image_url': instance.imageUrl,
    };

SearchPillList$QueryRoot _$SearchPillList$QueryRootFromJson(
        Map<String, dynamic> json) =>
    SearchPillList$QueryRoot()
      ..pbPillInfo = (json['pb_pill_info'] as List<dynamic>)
          .map((e) => SearchPillList$QueryRoot$PbPillInfo.fromJson(
              e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$SearchPillList$QueryRootToJson(
        SearchPillList$QueryRoot instance) =>
    <String, dynamic>{
      'pb_pill_info': instance.pbPillInfo.map((e) => e.toJson()).toList(),
    };

PillInfomation$QueryRoot$PbPillInfo
    _$PillInfomation$QueryRoot$PbPillInfoFromJson(Map<String, dynamic> json) =>
        PillInfomation$QueryRoot$PbPillInfo()
          ..itemSeq = json['item_seq'] as int
          ..name = json['name'] as String
          ..entpName = json['entp_name'] as String
          ..etcOtcCode = json['etc_otc_code'] as String
          ..className = json['class_name'] as String?
          ..imageUrl = json['image_url'] as String?;

Map<String, dynamic> _$PillInfomation$QueryRoot$PbPillInfoToJson(
        PillInfomation$QueryRoot$PbPillInfo instance) =>
    <String, dynamic>{
      'item_seq': instance.itemSeq,
      'name': instance.name,
      'entp_name': instance.entpName,
      'etc_otc_code': instance.etcOtcCode,
      'class_name': instance.className,
      'image_url': instance.imageUrl,
    };

PillInfomation$QueryRoot _$PillInfomation$QueryRootFromJson(
        Map<String, dynamic> json) =>
    PillInfomation$QueryRoot()
      ..pbPillInfoByPk = json['pb_pill_info_by_pk'] == null
          ? null
          : PillInfomation$QueryRoot$PbPillInfo.fromJson(
              json['pb_pill_info_by_pk'] as Map<String, dynamic>);

Map<String, dynamic> _$PillInfomation$QueryRootToJson(
        PillInfomation$QueryRoot instance) =>
    <String, dynamic>{
      'pb_pill_info_by_pk': instance.pbPillInfoByPk?.toJson(),
    };

SearchPillListIds$QueryRoot$PbPillInfo
    _$SearchPillListIds$QueryRoot$PbPillInfoFromJson(
            Map<String, dynamic> json) =>
        SearchPillListIds$QueryRoot$PbPillInfo()
          ..itemSeq = json['item_seq'] as int
          ..name = json['name'] as String
          ..entpName = json['entp_name'] as String
          ..etcOtcCode = json['etc_otc_code'] as String
          ..className = json['class_name'] as String?
          ..imageUrl = json['image_url'] as String?;

Map<String, dynamic> _$SearchPillListIds$QueryRoot$PbPillInfoToJson(
        SearchPillListIds$QueryRoot$PbPillInfo instance) =>
    <String, dynamic>{
      'item_seq': instance.itemSeq,
      'name': instance.name,
      'entp_name': instance.entpName,
      'etc_otc_code': instance.etcOtcCode,
      'class_name': instance.className,
      'image_url': instance.imageUrl,
    };

SearchPillListIds$QueryRoot _$SearchPillListIds$QueryRootFromJson(
        Map<String, dynamic> json) =>
    SearchPillListIds$QueryRoot()
      ..pbPillInfo = (json['pb_pill_info'] as List<dynamic>)
          .map((e) => SearchPillListIds$QueryRoot$PbPillInfo.fromJson(
              e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$SearchPillListIds$QueryRootToJson(
        SearchPillListIds$QueryRoot instance) =>
    <String, dynamic>{
      'pb_pill_info': instance.pbPillInfo.map((e) => e.toJson()).toList(),
    };

SearchByKeywordArguments _$SearchByKeywordArgumentsFromJson(
        Map<String, dynamic> json) =>
    SearchByKeywordArguments(
      keyword: json['keyword'] as String,
    );

Map<String, dynamic> _$SearchByKeywordArgumentsToJson(
        SearchByKeywordArguments instance) =>
    <String, dynamic>{
      'keyword': instance.keyword,
    };

SearchPillListArguments _$SearchPillListArgumentsFromJson(
        Map<String, dynamic> json) =>
    SearchPillListArguments(
      searchName: json['searchName'] as String?,
    );

Map<String, dynamic> _$SearchPillListArgumentsToJson(
        SearchPillListArguments instance) =>
    <String, dynamic>{
      'searchName': instance.searchName,
    };

PillInfomationArguments _$PillInfomationArgumentsFromJson(
        Map<String, dynamic> json) =>
    PillInfomationArguments(
      itemSeq: json['itemSeq'] as int,
    );

Map<String, dynamic> _$PillInfomationArgumentsToJson(
        PillInfomationArguments instance) =>
    <String, dynamic>{
      'itemSeq': instance.itemSeq,
    };

SearchPillListIdsArguments _$SearchPillListIdsArgumentsFromJson(
        Map<String, dynamic> json) =>
    SearchPillListIdsArguments(
      item_seqs:
          (json['item_seqs'] as List<dynamic>?)?.map((e) => e as int).toList(),
    );

Map<String, dynamic> _$SearchPillListIdsArgumentsToJson(
        SearchPillListIdsArguments instance) =>
    <String, dynamic>{
      'item_seqs': instance.item_seqs,
    };
