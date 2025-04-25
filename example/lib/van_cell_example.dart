import 'package:flutter/material.dart';
import 'package:vant/vant.dart';

class VanCellExample extends StatelessWidget {
  const VanCellExample({super.key});

  @override
  Widget build(Object context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("VantActionBar"),
      ),
      body: VanCellGroup(
        title: "afasdf",
        children: [
          VanCell(title: "title", value: "123"),
          VanCell(title: "title", value: "123"),
          VanCell(title: "title", value: "123"),
          VanCell(title: "title", value: "123"),
          VanCell(title: "title", value: "123"),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: VanCellExample()));
}
