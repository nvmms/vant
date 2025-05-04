import 'package:flutter/material.dart';
import 'package:vant/vant.dart';

class VanSubmitBarExample extends StatelessWidget {
  const VanSubmitBarExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            VanSubmitBar(
              price: 100523,
              button: VanButton(
                text: "取消订单",
                type: VanType.warning,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: VanSubmitBarExample(),
  ));
}
