import 'package:flutter/material.dart';
import 'package:vant/vant.dart';

class VantEmptyExample extends StatelessWidget {
  const VantEmptyExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Vant Empty Example'),
        ),
        body: const VantEmpty(
          description: "暂无更多数据",
        ),
      ),
    );
  }
}

void main() {
  runApp(const VantEmptyExample());
}
