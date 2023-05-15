import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BaseButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final Color? color;
  final bool hasShadow;
  final Icon? icon;
  final TextStyle? style;
  final TextAlign? textAlign;
  const BaseButton({
    super.key,
    this.onTap,
    this.color,
    this.hasShadow = true,
    required this.text,
    this.icon,
    this.style,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: color ?? const Color.fromRGBO(255, 255, 255, 1),
          boxShadow: hasShadow
              ? const <BoxShadow>[
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.1),
                    blurRadius: 20,
                    offset: Offset.zero,
                  ),
                ]
              : null,
        ),
        padding: EdgeInsets.fromLTRB(20.w, 22.h, 20.w, 22.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon ?? const Text(''),
            Text(
              text,
              textAlign: textAlign,
              style: style ??
                  TextStyle(fontWeight: FontWeight.w700, fontSize: 15.sp),
            ),
          ],
        ),
      ),
    );
  }
}
