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
      body: ListView(
        children: [
          VanCell(
            title: "标题",
            value: "内容",
            label: "标签",
            size: 16,
            icon: Icons.access_alarm,
            url: "https://example.com",
            border: true,
            replace: false,
            clickable: true,
            isLink: true,
            required: false,
            center: false,
            arrowDirection: VanCellArrowDirection.right,
            onTap: () {
              print("Cell tapped");
            },
          ),
          VanCellGroup(
            title: "分组标题",
            selectable: true,
            multiple: true,
            children: const [
              VanCell(key: Key("微信"), title: "分组内单元格1"),
              VanCell(key: Key("支付宝"), title: "分组内单元格2"),
              VanCell(key: Key("楹联"), title: "分组内单元格3"),
            ],
            onChange: (selectedKeys) {
              debugPrint("Selected keys: $selectedKeys");
            },
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: VanCellExample()));
}
