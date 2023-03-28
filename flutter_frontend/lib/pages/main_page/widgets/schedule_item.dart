import 'package:flutter/material.dart';
import 'package:flutter_frontend/widgets/base_item.dart';

class ScheduleItem extends StatelessWidget {
  final String time;
  final String status;
  const ScheduleItem({super.key, required this.time, required this.status});
  @override
  Widget build(BuildContext context) {
    return BaseItem(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                time,
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                status,
                style: const TextStyle(
                  color: Color.fromRGBO(11, 106, 227, 1),
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            itemBuilder: (BuildContext context, int index) {
              return Text('Row $index');
            },
          )
        ],
      ),
    );
  }
}
