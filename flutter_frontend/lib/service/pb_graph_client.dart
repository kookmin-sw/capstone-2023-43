import 'package:flutter_frontend/generated/graphql_api.graphql.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:gql/ast.dart';

class PbGraphQlClient {
  static String hostUrl =
      'https://g1rj1dd4j1.execute-api.ap-northeast-2.amazonaws.com/dev/graphql';
  final HttpLink httpLink = HttpLink(hostUrl);

  late GraphQLClient _client;
  GraphQLClient get client => _client;

  PbGraphQlClient() {
    _initClient();
  }

  void _initClient() async {
    _client = GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(),
    );
  }

  Future<dynamic> query(
    DocumentNode document, {
    Map<String, dynamic>? data,
  }) async {
    var result = await _client.query(QueryOptions(
      document: document,
      variables: data ?? {},
    ));

    if (result.hasException) {
      var message = result.exception!.graphqlErrors.first.message;
      throw GraphQLError(message: message);
    }

    return result;
  }
}
