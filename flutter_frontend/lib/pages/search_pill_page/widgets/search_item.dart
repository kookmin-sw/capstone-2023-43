import 'package:flutter/material.dart';

class SearchItem extends StatelessWidget {
  final String title;
  final String subTitle;
  final String company;
  const SearchItem(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.company});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 10),
      leading: const CircleAvatar(
        backgroundColor: Colors.grey,
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subTitle),
          Text(
            company,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
      trailing: Container(
        color: Colors.grey,
        child: const Padding(
          padding: EdgeInsets.all(4.0),
          child: Text(
            'pill',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
        ),
      ),
      onTap: () {},
    );
  }
}
