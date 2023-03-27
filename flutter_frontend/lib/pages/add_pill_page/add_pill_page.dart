import 'package:flutter/material.dart';
import 'package:flutter_frontend/pages/main_page/widgets/toggle_button.dart';
import 'package:flutter_frontend/widgets/base_button.dart';
import 'package:flutter_frontend/widgets/base_widget.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AddPillPage extends HookWidget {
  const AddPillPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      body: Center(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(40, 40, 40, 0),
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
                const Text(
                  "먹고있는 약 추가하기",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            BaseButton(
              text: '여기를 눌러 복용하려는 약 찾기',
              icon: const Icon(Icons.search),
              onTap: () {
                Navigator.pushNamed(context, '/search');
              },
            ),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              width: 25,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 0.5),
                borderRadius: const BorderRadius.all(Radius.circular(15)),
              ),
              height: 100,
              child: const Center(
                  child: Text(
                "복용 하고자 하는 약을 스케쥴에 올려  편리하게 관리하세요!",
                style: TextStyle(
                    fontWeight: FontWeight.w700, color: Color(0xffd2d2d2)),
              )),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const Text(
                  "복용기간",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 50,
                  ),
                ),
                Expanded(
                    flex: 5,
                    child: Container(
                      height: 50,
                      color: Colors.grey,
                    )),
                const Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 50,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text(
                  "복용시간",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 50,
                  ),
                ),
                Expanded(
                    flex: 5,
                    child: Container(
                      height: 50,
                      color: Colors.grey,
                    )),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 50,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "복용 주기",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ToggleButton(
              width: 300,
              height: 75,
              firstName: "요일",
              secondName: "주기",
              onTapFirst: () {},
              onTapSecond: () {},
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              color: Colors.blueGrey,
              height: 100,
            )
          ],
        ),
      )),
    );
  }
}
