import 'package:flutter/material.dart';
import 'package:vant/vant.dart';

class VanSubmitBarExample extends StatelessWidget {
  const VanSubmitBarExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("购物车"),
      ),
      body: Column(
        children: [
          Text("data"),
          Text("data"),
          Text("data"),
          Text("data"),
          Text("data"),
          Text("data"),
          Text("data"),
          Text("data"),
        ],
      ),
      bottomNavigationBar: VanSubmitBar(price: 1000),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: VanSubmitBarExample(),
  ));
}
