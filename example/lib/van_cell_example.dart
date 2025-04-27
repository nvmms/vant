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
        title: "asfasdf",
        inset: true,
        children: [
          VanCell(
            titleWidget: Text("data11111"),
            labelWidget: Text("data11111"),
            valueWidget: Text("data11111"),
            title: "AAA",
            icon: Icons.abc,
            center: true,
            onTap: () {
              print("object");
            },
          ),
          VanCell(
            titleWidget: Text("data11111"),
          ),
          VanCell(title: "title", label: "哇哈哈", value: "123"),
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
