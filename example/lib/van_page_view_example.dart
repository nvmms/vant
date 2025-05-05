import 'package:flutter/material.dart';
import 'package:vant/vant.dart';

class VanPageViewExample extends StatefulWidget {
  const VanPageViewExample({super.key});

  @override
  State<StatefulWidget> createState() => _VanPageViewExampleState();
}

class _VanPageViewExampleState extends State<VanPageViewExample> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('VanPageViewExample')),
      body: VanPageView.builder(
        itemCount: 10,
        onPageChanged: (value) {
          currentPageIndex = value;
          setState(() {});
        },
        itemBuilder: (context, index) {
          return Center(
            child: Text(
              "currentPageIndex -- $currentPageIndex, now index -- $index",
            ),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: VanPageViewExample(),
  ));
}
