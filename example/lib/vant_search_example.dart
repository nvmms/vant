import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vant/vant.dart';

class VanSearchExample extends StatelessWidget {
  const VanSearchExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: SizedBox(
          height: 54,
          child: const VanSearch(
            background: Colors.amber,
            showAction: true,
            actionText: "取消",
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const VanSearchExample());
}
