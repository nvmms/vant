import 'package:flutter/material.dart';
import 'package:vant/vant.dart';

class VanInputExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: VanInput(
              clearable: true,
              placeholder: "请输入验证码",
              disabled: false,
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: VanInputExample(),
  ));
}
