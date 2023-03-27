import 'package:flutter/material.dart';
import 'package:flutter_frontend/widgets/base_widget.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PillInfomation extends HookWidget {
  const PillInfomation({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      body: Center(
        child: Text('pill_infomation'),
      ),
    );
  }
}
