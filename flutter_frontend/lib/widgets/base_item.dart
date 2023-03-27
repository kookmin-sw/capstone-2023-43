//위젯에 들어가는 아이템의 기반.
import 'package:flutter/material.dart';

class BaseItem extends StatelessWidget {
  final Widget child;
  final Color color;
  final double? width;
  final double? height;

  const BaseItem({
    Key? key,
    this.color = Colors.white,
    this.width,
    this.height,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: color ?? const Color.fromRGBO(255, 255, 255, 1),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              offset: Offset.zero,
              color: Color.fromRGBO(0, 0, 0, 0.1),
              blurRadius: 20,
            ),
          ]),
      // margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 15, 25, 15), child: child),
    );
  }
}
