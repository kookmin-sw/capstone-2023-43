import 'package:flutter/material.dart';

class BaseText extends StatelessWidget {
  final String text;
  final double size;
  final FontWeight? weight;
  final Color color;

  const BaseText({
    super.key,
    this.size = 16,
    this.weight,
    this.color = const Color.fromRGBO(0, 0, 0, 1),
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontWeight: weight,
        fontSize: size,
      ),
    );
  }
}
