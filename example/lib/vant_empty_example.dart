import 'package:flutter/material.dart';
import 'package:vant/vant.dart';

class VanEmptyExample extends StatelessWidget {
  const VanEmptyExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Vant Empty Example'),
        ),
        body: const VanEmpty(
          description: "暂无更多数据",
        ),
      ),
    );
  }
}

void main() {
  runApp(const VanEmptyExample());
}
