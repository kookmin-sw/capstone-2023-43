import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ButtonToggleable extends HookWidget {
  final double height;
  final Function() onTap;
  final String text;

  const ButtonToggleable(this.height, this.onTap, this.text, {super.key});
  @override
  Widget build(BuildContext context) {
    var isSelect = useState(false);
    return GestureDetector(
      onTap: () {
        isSelect.value = !isSelect.value;
        onTap();
      },
      child: AnimatedContainer(
        height: height.h,
        duration: Duration(milliseconds: 250),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          border: isSelect.value
              ? Border.all(color: const Color.fromRGBO(11, 106, 227, 1))
              : Border.all(color: const Color.fromRGBO(11, 106, 227, 1)),
          borderRadius: BorderRadius.circular(15.0.h),
          color: isSelect.value
              ? const Color.fromRGBO(11, 106, 227, 1)
              : const Color.fromRGBO(255, 255, 255, 1),
        ),
        child: AnimatedDefaultTextStyle(
          child: Center(child: Text(text)),
          style: TextStyle(
            fontFamily: 'NoToSansKR',
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: isSelect.value
                ? Colors.white
                : const Color.fromRGBO(11, 106, 227, 1),
          ),
          duration: Duration(milliseconds: 250),
          curve: Curves.easeOut,
        ),
      ),
    );
  }
}
