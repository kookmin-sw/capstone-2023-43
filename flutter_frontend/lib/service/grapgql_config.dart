import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:gql/ast.dart';

class GraphQLConfig {
  static final _httpLink = HttpLink('http://64.110.79.49:8080/v1/graphql');

  static ValueNotifier<GraphQLClient> initCLient() {
    ValueNotifier<GraphQLClient> client = ValueNotifier(GraphQLClient(
      link: _httpLink,
      cache: GraphQLCache(),
    ));

    return client;
  }
}
