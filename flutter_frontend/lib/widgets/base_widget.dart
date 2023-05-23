//페이지의 기본이 되는 위젯
import 'package:flutter/material.dart';

class BaseWidget extends StatelessWidget {
  final Widget? body;
  final Color? color;
  const BaseWidget({super.key, this.body, this.color});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: color,
      body: body ??
          const Center(
            child: Text('body is empty!'),
          ),
    );
  }
}
