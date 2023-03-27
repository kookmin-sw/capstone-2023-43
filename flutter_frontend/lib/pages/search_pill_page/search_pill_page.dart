import 'package:flutter/material.dart';
import 'package:flutter_frontend/pages/search_pill_page/dummy_model.dart';
import 'package:flutter_frontend/pages/search_pill_page/widgets/search_item.dart';
import 'package:flutter_frontend/widgets/base_widget.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SearchPillPage extends HookWidget {
  const SearchPillPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isSearched = useState(false);
    final textController = useTextEditingController(text: '');
    final dummySearchItem = [
      for (int i = 0; i < 15; i++)
        DummyModel(
            title: 'title $i', subTitle: 'sub_title $i', company: 'company$i')
    ];

    return BaseWidget(
      body: BaseWidget(
        body: Padding(
          padding: const EdgeInsets.fromLTRB(40, 40, 40, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                    iconSize: 28,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 1,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        TextField(
                          controller: textController,
                          decoration: const InputDecoration(
                            hintText: '먹고있는 약을 입력하세요',
                          ),
                        ),
                        Align(
                          alignment: const Alignment(1, 0),
                          child: IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () {
                              isSearched.value = true;
                              print(textController.text);
                            },
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              isSearched.value
                  ? Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '검색결과',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Divider(
                            thickness: 1,
                            height: 1,
                          ),
                          Expanded(
                            child: ListView.builder(
                                itemCount: dummySearchItem.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return SearchItem(
                                    title: dummySearchItem[index].title,
                                    subTitle: dummySearchItem[index].subTitle,
                                    company: dummySearchItem[index].company,
                                  );
                                }),
                          ),
                        ],
                      ),
                    )
                  : const Text('not searched'),
            ],
          ),
        ),
      ),
    );
  }
}
