import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_frontend/widgets/base_widget.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Test extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return const BaseWidget(
      body: Center(
        child: Text('test Widget'),
      ),
    );
  }
}
