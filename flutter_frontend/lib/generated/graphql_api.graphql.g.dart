// GENERATED CODE - DO NOT MODIFY BY HAND
// @dart=2.12

part of 'graphql_api.graphql.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PbPillInfo$QueryRoot$PbPillInfo _$PbPillInfo$QueryRoot$PbPillInfoFromJson(
        Map<String, dynamic> json) =>
    PbPillInfo$QueryRoot$PbPillInfo()
      ..itemSeq = json['item_seq'] as int
      ..name = json['name'] as String
      ..entpName = json['entp_name'] as String
      ..etcOtcCode = json['etc_otc_code'] as String
      ..className = json['class_name'] as String?
      ..imageUrl = json['image_url'] as String?;

Map<String, dynamic> _$PbPillInfo$QueryRoot$PbPillInfoToJson(
        PbPillInfo$QueryRoot$PbPillInfo instance) =>
    <String, dynamic>{
      'item_seq': instance.itemSeq,
      'name': instance.name,
      'entp_name': instance.entpName,
      'etc_otc_code': instance.etcOtcCode,
      'class_name': instance.className,
      'image_url': instance.imageUrl,
    };

PbPillInfo$QueryRoot _$PbPillInfo$QueryRootFromJson(
        Map<String, dynamic> json) =>
    PbPillInfo$QueryRoot()
      ..pbPillInfo = (json['pb_pill_info'] as List<dynamic>)
          .map((e) => PbPillInfo$QueryRoot$PbPillInfo.fromJson(
              e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$PbPillInfo$QueryRootToJson(
        PbPillInfo$QueryRoot instance) =>
    <String, dynamic>{
      'pb_pill_info': instance.pbPillInfo.map((e) => e.toJson()).toList(),
    };

PbPillInfoArguments _$PbPillInfoArgumentsFromJson(Map<String, dynamic> json) =>
    PbPillInfoArguments(
      searchName: json['searchName'] as String?,
    );

Map<String, dynamic> _$PbPillInfoArgumentsToJson(
        PbPillInfoArguments instance) =>
    <String, dynamic>{
      'searchName': instance.searchName,
    };
