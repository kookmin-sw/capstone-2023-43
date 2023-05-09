//gql 서비스 - 아마 안쓰지 않을까...

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:gql/ast.dart';

enum QlLoadState { notReady, ready, loading, finish, error }

class PbGraphQlClient extends ChangeNotifier {
  static String hostUrl =
      'https://g1rj1dd4j1.execute-api.ap-northeast-2.amazonaws.com/dev/graphql';
  final HttpLink httpLink = HttpLink(hostUrl);
  late GraphQLClient _client;
  QlLoadState state = QlLoadState.notReady;
  GraphQLClient get client => _client;

  PbGraphQlClient() {
    _initClient();
  }

  void _initClient() async {
    _client = GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(),
    );
    state = QlLoadState.ready;
    notifyListeners();
  }

  // 쿼리를 두가지 state를 change 할 수 있도록 만든다.
  // 로딩중 -> QlLoadState.loading
  // 호출 완료 -> QlLoadState.finish

  Future<dynamic> query(
    DocumentNode document, {
    Map<String, dynamic>? data,
  }) async {
    state = QlLoadState.loading;
    notifyListeners();

    var result = await _client.query(QueryOptions(
      document: document,
      variables: data ?? {},
    ));

    if (result.hasException) {
      var message = result.exception!.graphqlErrors.first.message;
      state = QlLoadState.error;
      throw GraphQLError(message: message);
    }

    state = QlLoadState.finish;
    notifyListeners();

    return result;
  }
}
