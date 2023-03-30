// GENERATED CODE - DO NOT MODIFY BY HAND
// @dart = 2.12

import 'package:artemis/artemis.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'package:gql/ast.dart';
part 'graphql_api.graphql.g.dart';

@JsonSerializable(explicitToJson: true)
class SearchPillList$QueryRoot$PbPillInfo extends JsonSerializable
    with EquatableMixin {
  SearchPillList$QueryRoot$PbPillInfo();

  factory SearchPillList$QueryRoot$PbPillInfo.fromJson(
          Map<String, dynamic> json) =>
      _$SearchPillList$QueryRoot$PbPillInfoFromJson(json);

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
      _$SearchPillList$QueryRoot$PbPillInfoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SearchPillList$QueryRoot extends JsonSerializable with EquatableMixin {
  SearchPillList$QueryRoot();

  factory SearchPillList$QueryRoot.fromJson(Map<String, dynamic> json) =>
      _$SearchPillList$QueryRootFromJson(json);

  @JsonKey(name: 'pb_pill_info')
  late List<SearchPillList$QueryRoot$PbPillInfo> pbPillInfo;

  @override
  List<Object?> get props => [pbPillInfo];
  @override
  Map<String, dynamic> toJson() => _$SearchPillList$QueryRootToJson(this);
}

@JsonSerializable(explicitToJson: true)
class PillInfomation$QueryRoot$PbPillInfo extends JsonSerializable
    with EquatableMixin {
  PillInfomation$QueryRoot$PbPillInfo();

  factory PillInfomation$QueryRoot$PbPillInfo.fromJson(
          Map<String, dynamic> json) =>
      _$PillInfomation$QueryRoot$PbPillInfoFromJson(json);

  late String name;

  @JsonKey(name: 'entp_name')
  late String entpName;

  @JsonKey(name: 'etc_otc_code')
  late String etcOtcCode;

  @JsonKey(name: 'class_name')
  String? className;

  @JsonKey(name: 'image_url')
  String? imageUrl;

  @JsonKey(name: 'use_method')
  String? useMethod;

  @JsonKey(name: 'warning_message')
  String? warningMessage;

  late String effect;

  @override
  List<Object?> get props => [
        name,
        entpName,
        etcOtcCode,
        className,
        imageUrl,
        useMethod,
        warningMessage,
        effect
      ];
  @override
  Map<String, dynamic> toJson() =>
      _$PillInfomation$QueryRoot$PbPillInfoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class PillInfomation$QueryRoot extends JsonSerializable with EquatableMixin {
  PillInfomation$QueryRoot();

  factory PillInfomation$QueryRoot.fromJson(Map<String, dynamic> json) =>
      _$PillInfomation$QueryRootFromJson(json);

  @JsonKey(name: 'pb_pill_info')
  late List<PillInfomation$QueryRoot$PbPillInfo> pbPillInfo;

  @override
  List<Object?> get props => [pbPillInfo];
  @override
  Map<String, dynamic> toJson() => _$PillInfomation$QueryRootToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SearchPillListArguments extends JsonSerializable with EquatableMixin {
  SearchPillListArguments({this.searchName});

  @override
  factory SearchPillListArguments.fromJson(Map<String, dynamic> json) =>
      _$SearchPillListArgumentsFromJson(json);

  final String? searchName;

  @override
  List<Object?> get props => [searchName];
  @override
  Map<String, dynamic> toJson() => _$SearchPillListArgumentsToJson(this);
}

final SEARCH_PILL_LIST_QUERY_DOCUMENT_OPERATION_NAME = 'search_pill_list';
final SEARCH_PILL_LIST_QUERY_DOCUMENT = DocumentNode(definitions: [
  OperationDefinitionNode(
    type: OperationType.query,
    name: NameNode(value: 'search_pill_list'),
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

class SearchPillListQuery
    extends GraphQLQuery<SearchPillList$QueryRoot, SearchPillListArguments> {
  SearchPillListQuery({required this.variables});

  @override
  final DocumentNode document = SEARCH_PILL_LIST_QUERY_DOCUMENT;

  @override
  final String operationName = SEARCH_PILL_LIST_QUERY_DOCUMENT_OPERATION_NAME;

  @override
  final SearchPillListArguments variables;

  @override
  List<Object?> get props => [document, operationName, variables];
  @override
  SearchPillList$QueryRoot parse(Map<String, dynamic> json) =>
      SearchPillList$QueryRoot.fromJson(json);
}

@JsonSerializable(explicitToJson: true)
class PillInfomationArguments extends JsonSerializable with EquatableMixin {
  PillInfomationArguments({this.itemSeq});

  @override
  factory PillInfomationArguments.fromJson(Map<String, dynamic> json) =>
      _$PillInfomationArgumentsFromJson(json);

  final String? itemSeq;

  @override
  List<Object?> get props => [itemSeq];
  @override
  Map<String, dynamic> toJson() => _$PillInfomationArgumentsToJson(this);
}

final PILL_INFOMATION_QUERY_DOCUMENT_OPERATION_NAME = 'pill_infomation';
final PILL_INFOMATION_QUERY_DOCUMENT = DocumentNode(definitions: [
  OperationDefinitionNode(
    type: OperationType.query,
    name: NameNode(value: 'pill_infomation'),
    variableDefinitions: [
      VariableDefinitionNode(
        variable: VariableNode(name: NameNode(value: 'itemSeq')),
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
                name: NameNode(value: 'item_seq'),
                value: ObjectValueNode(fields: [
                  ObjectFieldNode(
                    name: NameNode(value: '_eq'),
                    value: VariableNode(name: NameNode(value: 'itemSeq')),
                  )
                ]),
              )
            ]),
          )
        ],
        directives: [],
        selectionSet: SelectionSetNode(selections: [
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
          FieldNode(
            name: NameNode(value: 'use_method'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'warning_message'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'effect'),
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

class PillInfomationQuery
    extends GraphQLQuery<PillInfomation$QueryRoot, PillInfomationArguments> {
  PillInfomationQuery({required this.variables});

  @override
  final DocumentNode document = PILL_INFOMATION_QUERY_DOCUMENT;

  @override
  final String operationName = PILL_INFOMATION_QUERY_DOCUMENT_OPERATION_NAME;

  @override
  final PillInfomationArguments variables;

  @override
  List<Object?> get props => [document, operationName, variables];
  @override
  PillInfomation$QueryRoot parse(Map<String, dynamic> json) =>
      PillInfomation$QueryRoot.fromJson(json);
}
