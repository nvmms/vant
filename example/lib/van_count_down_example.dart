import 'package:flutter/material.dart';
import 'package:vant/vant.dart';

class VanCountDownExample extends StatelessWidget {
  const VanCountDownExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('倒计时')),
      body: SingleChildScrollView(
        child: VanSpace(
          children: [
            VanCountDown(
              time: Duration(hours: 10),
              format: "mm分ss秒",
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: VanCountDownExample(),
  ));
}
