import 'package:flutter/material.dart';
import 'package:flutter_frontend/widgets/base_button.dart';
import 'package:flutter_frontend/widgets/base_item.dart';
import 'package:flutter_frontend/widgets/base_widget.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class MyHookPage extends HookWidget {
  const MyHookPage({super.key});

  @override
  Widget build(BuildContext context) {
    final counter = useState(0);

    return BaseWidget(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            BaseItem(
                child: Column(
              children: [
                const Text("데모파일. 하지만 flutterHook을 적용한: "),
                Text(
                  '${counter.value}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            )),
            const SizedBox(height: 20),
            BaseButton(
              text: '하나 더하기',
              onTap: () => counter.value++,
            ),
            const SizedBox(height: 20),
            const BaseItem(
              child: Text(
                'hello world!',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
            )
          ],
        ),
      ),
    );
  }
}
