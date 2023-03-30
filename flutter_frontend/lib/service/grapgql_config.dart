import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:gql/ast.dart';

class GraphQLConfig {
  static final _httpLink = HttpLink(
      'https://g1rj1dd4j1.execute-api.ap-northeast-2.amazonaws.com/dev/graphql');

  static ValueNotifier<GraphQLClient> initCLient() {
    ValueNotifier<GraphQLClient> client = ValueNotifier(GraphQLClient(
      link: _httpLink,
      cache: GraphQLCache(),
    ));

    return client;
  }
}
