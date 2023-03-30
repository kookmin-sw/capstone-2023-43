// GENERATED CODE - DO NOT MODIFY BY HAND
// @dart = 2.12

import 'package:artemis/artemis.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'package:gql/ast.dart';
part 'graphql_api.graphql.g.dart';

@JsonSerializable(explicitToJson: true)
class PbPillInfo$QueryRoot$PbPillInfo extends JsonSerializable
    with EquatableMixin {
  PbPillInfo$QueryRoot$PbPillInfo();

  factory PbPillInfo$QueryRoot$PbPillInfo.fromJson(Map<String, dynamic> json) =>
      _$PbPillInfo$QueryRoot$PbPillInfoFromJson(json);

  @JsonKey(name: 'item_seq')
  late int itemSeq;

  late String name;

  @JsonKey(name: 'entp_name')
  late String entpName;

  @JsonKey(name: 'etc_otc_code')
  late String etcOtcCode;

  @JsonKey(name: 'class_name')
  String? className;

  @JsonKey(name: 'image_url')
  String? imageUrl;

  @override
  List<Object?> get props =>
      [itemSeq, name, entpName, etcOtcCode, className, imageUrl];
  @override
  Map<String, dynamic> toJson() =>
      _$PbPillInfo$QueryRoot$PbPillInfoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class PbPillInfo$QueryRoot extends JsonSerializable with EquatableMixin {
  PbPillInfo$QueryRoot();

  factory PbPillInfo$QueryRoot.fromJson(Map<String, dynamic> json) =>
      _$PbPillInfo$QueryRootFromJson(json);

  @JsonKey(name: 'pb_pill_info')
  late List<PbPillInfo$QueryRoot$PbPillInfo> pbPillInfo;

  @override
  List<Object?> get props => [pbPillInfo];
  @override
  Map<String, dynamic> toJson() => _$PbPillInfo$QueryRootToJson(this);
}

@JsonSerializable(explicitToJson: true)
class PbPillInfoArguments extends JsonSerializable with EquatableMixin {
  PbPillInfoArguments({this.searchName});

  @override
  factory PbPillInfoArguments.fromJson(Map<String, dynamic> json) =>
      _$PbPillInfoArgumentsFromJson(json);

  final String? searchName;

  @override
  List<Object?> get props => [searchName];
  @override
  Map<String, dynamic> toJson() => _$PbPillInfoArgumentsToJson(this);
}

final PB_PILL_INFO_QUERY_DOCUMENT_OPERATION_NAME = 'pb_pill_info';
final PB_PILL_INFO_QUERY_DOCUMENT = DocumentNode(definitions: [
  OperationDefinitionNode(
    type: OperationType.query,
    name: NameNode(value: 'pb_pill_info'),
    variableDefinitions: [
      VariableDefinitionNode(
        variable: VariableNode(name: NameNode(value: 'searchName')),
        type: NamedTypeNode(
          name: NameNode(value: 'String'),
          isNonNull: false,
        ),
        defaultValue: DefaultValueNode(value: null),
        directives: [],
      )
    ],
    directives: [],
    selectionSet: SelectionSetNode(selections: [
      FieldNode(
        name: NameNode(value: 'pb_pill_info'),
        alias: null,
        arguments: [
          ArgumentNode(
            name: NameNode(value: 'where'),
            value: ObjectValueNode(fields: [
              ObjectFieldNode(
                name: NameNode(value: 'name'),
                value: ObjectValueNode(fields: [
                  ObjectFieldNode(
                    name: NameNode(value: '_like'),
                    value: VariableNode(name: NameNode(value: 'searchName')),
                  )
                ]),
              )
            ]),
          )
        ],
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
            name: NameNode(value: 'item_seq'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'name'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'entp_name'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'etc_otc_code'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'class_name'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'image_url'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
        ]),
      )
    ]),
  )
]);

class PbPillInfoQuery
    extends GraphQLQuery<PbPillInfo$QueryRoot, PbPillInfoArguments> {
  PbPillInfoQuery({required this.variables});

  @override
  final DocumentNode document = PB_PILL_INFO_QUERY_DOCUMENT;

  @override
  final String operationName = PB_PILL_INFO_QUERY_DOCUMENT_OPERATION_NAME;

  @override
  final PbPillInfoArguments variables;

  @override
  List<Object?> get props => [document, operationName, variables];
  @override
  PbPillInfo$QueryRoot parse(Map<String, dynamic> json) =>
      PbPillInfo$QueryRoot.fromJson(json);
}
