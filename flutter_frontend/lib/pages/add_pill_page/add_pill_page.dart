import 'package:flutter/material.dart';
import 'package:flutter_frontend/model/pill_infomation.dart';
import 'package:flutter_frontend/model/schdule_data.dart';
import 'package:flutter_frontend/pages/add_pill_page/widget/button_toggleable.dart';
import 'package:flutter_frontend/pages/add_pill_page/widget/list_tile/pill_group_list_tile.dart';
import 'package:flutter_frontend/pages/search_pill_page/search_pill_page.dart';
import 'package:flutter_frontend/service/add_pill_service.dart';
import 'package:flutter_frontend/service/http_response_service.dart';
import 'package:flutter_frontend/widgets/base_button.dart';
import 'package:flutter_frontend/widgets/base_widget.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddPillPage extends HookConsumerWidget {
  const AddPillPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late List<PillInfomation> pills = ref.watch(AddPillServiceProvider).pills;
    var stage = ref.watch(AddPillServiceProvider).stage;
    final groupTexController = useTextEditingController(text: '');
    final dayTexController = useTextEditingController(text: '');
    var PresetToggle = useState([false, false, false, false]);

    var checkDay = useState(true);
    var checkName = useState(true);
    var checkPreset = useState(true);
    var checkPill = useState(true);

    return WillPopScope(
      onWillPop: () async {
        ref.read(AddPillServiceProvider).initState();
        return true;
      },
      child: BaseWidget(
        body: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.fromLTRB(40.w, 40.h, 40.w, 0),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ref.read(AddPillServiceProvider).initState();
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        size: 28.w,
                      )),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "먹고있는 약 추가하기",
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              BaseButton(
                text: '여기를 눌러 복용하려는 약 찾기',
                icon: const Icon(Icons.search),
                onTap: () {
                  ref.read(AddPillServiceProvider).changeSelectState();
                  checkPill.value = true;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SearchPillPage()));
                },
              ),
              SizedBox(
                height: 20.h,
              ),
              SizedBox(
                width: 25.w,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1.h,
                    color: checkPill.value
                        ? Color.fromRGBO(11, 106, 227, 1)
                        : Colors.red,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(15.h)),
                ),
                child: (stage == AddPillState.addPill ||
                            stage == AddPillState.selectPill) &&
                        pills.isNotEmpty
                    ? Center(
                        child: ListView.builder(
                          padding: EdgeInsets.all(10),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: pills.length,
                          itemBuilder: (context, index) {
                            return PillGroupListItem(
                              title: pills[index].name,
                              subTitle: pills[index].className,
                              company: pills[index].entpName,
                              index: index + 1,
                            );
                          },
                        ),
                      )
                    : SizedBox(
                        height: 75.h,
                        child: Center(
                          child: Text(
                            "복용 하고자 하는 약을 스케쥴에 올려\n편리하게 관리하세요!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Color.fromRGBO(11, 106, 227, 0.5),
                              fontSize: 20.sp,
                            ),
                          ),
                        )),
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 20,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: checkName.value
                                  ? Color.fromRGBO(11, 106, 227, 1)
                                  : Colors.red),
                          borderRadius: BorderRadius.circular(15.0.h)),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.h, vertical: 3.h),
                        child: TextField(
                          controller: groupTexController,
                          onChanged: (value) => checkName.value = true,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            color: Color.fromRGBO(11, 106, 227, 1),
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "약 그룹 이름",
                            hintStyle: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                              color: Color.fromRGBO(11, 106, 227, 0.5),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(flex: 1, child: SizedBox()),
                  Expanded(
                    flex: 9,
                    child: AnimatedContainer(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: checkDay.value
                                ? Color.fromRGBO(11, 106, 227, 1)
                                : Colors.red),
                        borderRadius: BorderRadius.circular(15.0.h),
                      ),
                      duration: Duration(milliseconds: 250),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.h, vertical: 3.h),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            TextField(
                              controller: dayTexController,
                              keyboardType: TextInputType.numberWithOptions(
                                  signed: false, decimal: true),
                              onChanged: (value) => checkDay.value = true,
                              style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromRGBO(11, 106, 227, 1)),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "day",
                                hintStyle: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromRGBO(11, 106, 227, 0.5),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment(1, 0),
                              child: Text(
                                '일',
                                style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Color.fromRGBO(11, 106, 227, 0.5)),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 15,
                    child: ButtonToggleable(60.0, () {
                      PresetToggle.value[0] = !PresetToggle.value[0];
                      checkPreset.value = true;
                    }, "아침에 먹어요", checkPreset.value),
                  ),
                  const Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 60,
                    ),
                  ),
                  Expanded(
                    flex: 15,
                    child: ButtonToggleable(60.0, () {
                      PresetToggle.value[1] = !PresetToggle.value[1];
                      checkPreset.value = true;
                    }, "점심에 먹어요", checkPreset.value),
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 15,
                    child: ButtonToggleable(60.0, () {
                      PresetToggle.value[2] = !PresetToggle.value[2];
                      checkPreset.value = true;
                    }, "저녁에 먹어요", checkPreset.value),
                  ),
                  const Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 60,
                    ),
                  ),
                  Expanded(
                    flex: 15,
                    child: ButtonToggleable(60.0, () {
                      PresetToggle.value[3] = !PresetToggle.value[3];
                      checkPreset.value = true;
                    }, "자기전에 먹어요", checkPreset.value),
                  ),
                ],
              ),
              SizedBox(
                height: 30.h,
              ),
              BaseButton(
                text: "일정 등록하기",
                color: Color.fromRGBO(11, 106, 227, 1),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 20.sp,
                ),
                onTap: () async {
                  List<int> pillIds = [];
                  List<String> presetIds = [];

                  for (var pill in pills) {
                    pillIds.add(pill.itemSeq);
                  }

                  for (int i = 0; i < 4; i++) {
                    if (PresetToggle.value[i]) {
                      presetIds.add(ref
                          .read(HttpResponseServiceProvider)
                          .presetTime[i]
                          .id);
                    }
                  }

                  if (int.tryParse(dayTexController.text) == null) {
                    checkDay.value = false;
                    return;
                  }

                  var startDate = DateTime.now();
                  var endDate = startDate.add(
                    Duration(
                      days: int.parse(dayTexController.text),
                    ),
                  );

                  await ref.read(HttpResponseServiceProvider).postData(
                        SchduleData(
                            id: '',
                            startDate: startDate,
                            endDate: endDate,
                            name: groupTexController.text,
                            pills: pillIds,
                            presetTimes: presetIds,
                            timeStamp: {}),
                      );

                  if (ref.read(HttpResponseServiceProvider).stage ==
                      ResposeStage.ready) {
                    Navigator.pop(context);
                    ref.read(AddPillServiceProvider).initState();
                  } else if (ref.read(HttpResponseServiceProvider).stage ==
                      ResposeStage.error) {
                    if (ref.read(HttpResponseServiceProvider).errMsg ==
                        "Need pill list") {
                      checkPill.value = false;
                    } else if (ref.read(HttpResponseServiceProvider).errMsg ==
                        "preset_time_id not exist") {
                      checkPreset.value = false;
                    } else if (ref.read(HttpResponseServiceProvider).errMsg ==
                        "Need history name") {
                      checkName.value = false;
                    }
                  }
                },
              ),
            ],
          ),
        )),
      ),
    );
  }
}
