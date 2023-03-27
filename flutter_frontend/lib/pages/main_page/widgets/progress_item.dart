import 'package:flutter/material.dart';
import 'package:flutter_frontend/widgets/base_item.dart';

class ProgressItem extends StatelessWidget {
  const ProgressItem({super.key});
  @override
  Widget build(BuildContext context) {
    return BaseItem(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '복약관리',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              Text('percent'),
              Text('복약완료'),
            ],
          ),
          const SizedBox(
            height: 10,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: LinearProgressIndicator(
                value: 0.7,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xff0B6AE3)),
                backgroundColor: Color(0xffD6D6D6),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: const [
              Text(
                'Time',
                style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff0B6AE3)),
              ),
              Text(
                '후 복약예정',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
