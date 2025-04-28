import 'package:flutter/material.dart';
import 'package:vant/vant.dart';

class VanStepperExample extends StatelessWidget {
  const VanStepperExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const VanStepper(),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: VanStepperExample(),
  ));
}
