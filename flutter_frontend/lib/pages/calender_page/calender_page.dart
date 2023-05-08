import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../widgets/base_widget.dart';

class CalenderPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      body: Column(
        children: [
          // 프로그래스 바.
          // 앞으로 들어가야할 UI
          // 일일 복용 여부
          // 각각 날짜 선택시 먹을약 -> 처방전 리스트 출력.
          Text("hello"),
          TableCalendar(
            daysOfWeekHeight: 30,
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: DateTime.now(),
            calendarBuilders: CalendarBuilders(dowBuilder: (context, day) {
              switch (day.weekday) {
                case 1:
                  return const Center(child: Text('월'));
                case 2:
                  return const Center(child: Text('화'));
                case 3:
                  return const Center(child: Text('수'));
                case 4:
                  return const Center(child: Text('목'));
                case 5:
                  return const Center(child: Text('금'));
                case 6:
                  return const Center(
                      child: Text(
                    '토',
                    style: TextStyle(color: Colors.blue),
                  ));
                case 7:
                  return const Center(
                    child: Text(
                      '일',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
              }
            }),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              leftChevronVisible: false,
              rightChevronVisible: false,
            ),
          ),
        ],
      ),
    );
  }
}
