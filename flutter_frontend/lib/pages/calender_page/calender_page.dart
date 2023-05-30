import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/model/pill_take_list.dart';
import 'package:flutter_frontend/model/schdule_data.dart';
import 'package:flutter_frontend/service/http_response_service.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../widgets/base_widget.dart';

class CalenderPage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _focusedDay = useState(DateTime.now());
    final _selectedDay = useState(DateTime.now());
    final time = ref.read(HttpResponseServiceProvider).presetTime;
    final data = ref.read(HttpResponseServiceProvider).wholedata;
    final list = ref.watch(HttpResponseServiceProvider).daylist;
    return BaseWidget(
      body: Padding(
        padding: EdgeInsets.fromLTRB(40.w, 40.h, 40.w, 0),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 28,
                    )),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "복용기록 달력보기",
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w700,
                  ),
                )
              ],
            ),
            TableCalendar(
              daysOfWeekHeight: 30,
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2050, 3, 14),
              focusedDay: _focusedDay.value,
              onDaySelected: (selectedDay, focusedDay) {
                _selectedDay.value = selectedDay;
                _focusedDay.value = focusedDay;
                ref
                    .read(HttpResponseServiceProvider)
                    .generateListbyDay(selectedDay);
              },
              onPageChanged: (focusedDay) {
                _focusedDay.value = focusedDay;
              },
              selectedDayPredicate: (day) => isSameDay(day, _selectedDay.value),
              calendarBuilders: CalendarBuilders(
                selectedBuilder: (context, day, focusedDay) {
                  return Padding(
                    padding: EdgeInsets.all(10.h),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(11, 106, 227, 1),
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                        child: Text(
                          day.day.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
                dowBuilder: (context, day) {
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
                },
                markerBuilder: (context, day, events) {
                  int status = ref
                      .read(HttpResponseServiceProvider)
                      .checkpillConsume(day);
                  if (status == 0) {
                    return const SizedBox();
                  } else {
                    return Container(
                      width: 8.w,
                      height: 8.h,
                      decoration: BoxDecoration(
                          color: status == 2 ? Colors.green : Colors.red,
                          borderRadius: BorderRadius.circular(4)),
                    );
                  }
                },
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                leftChevronVisible: false,
                rightChevronVisible: false,
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            Row(
              children: [
                Text(
                  "미복약 리스트",
                  style: TextStyle(fontSize: 28.sp),
                )
              ],
            ),
            Divider(
              thickness: 1,
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  String t = formatDate(
                      time
                          .where(
                              (element) => element.id == list[index].presetId)
                          .first
                          .time,
                      [HH, ":", nn]);
                  var iter = data
                      .where((element) => element.id == list[index].historyId);
                  SchduleData d = iter.first;
                  return ListTile(
                    title: Row(children: [
                      Text(t + " "),
                      Text(
                        d.name,
                        style: TextStyle(fontWeight: FontWeight.w700),
                      )
                    ]),
                    subtitle: Row(
                      children: [Text("${d.pills.length}"), Text("개의 복용약 포함")],
                    ),
                  );
                },
                itemCount: list.length,
              ),
            )
          ],
        ),
      ),
    );
  }
}
