import 'package:flutter/material.dart';
import 'package:vant/vant.dart';

class VanButtonExample extends StatelessWidget {
  const VanButtonExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Van Button Example'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              VanButton(
                text: '主要按钮',
                type: VanType.primary,
                onPressed: () {},
              ),
              VanButton(
                text: '成功按钮',
                type: VanType.success,
                onPressed: () {},
              ),
              VanButton(
                text: '默认按钮',
                type: VanType.normal,
                onPressed: () {},
              ),
              VanButton(
                text: '微信按钮',
                type: VanType.danger,
                onPressed: () {},
              ),
              VanButton(
                text: '警告按钮',
                type: VanType.warning,
                onPressed: () {},
              ),
            ],
          ),
          SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              VanButton(
                text: '朴素按钮',
                plain: true,
                type: VanType.primary,
                onPressed: () {},
              ),
              VanButton(
                text: '朴素按钮',
                plain: true,
                type: VanType.success,
                onPressed: () {},
              ),
            ],
          ),
          SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              VanButton(
                text: '细边框按钮',
                disabled: true,
                type: VanType.primary,
                onPressed: () {},
              ),
              VanButton(
                text: '细边框按钮',
                disabled: true,
                type: VanType.success,
                onPressed: () {},
              ),
            ],
          ),
          SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              VanButton(
                type: VanType.primary,
                loading: true,
                onPressed: () {},
              ),
              VanButton(
                loading: true,
                type: VanType.success,
                onPressed: () {},
              ),
              VanButton(
                text: '加载中...',
                loading: true,
                type: VanType.success,
                onPressed: () {},
              ),
            ],
          ),
          SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              VanButton(
                text: "方形按钮",
                type: VanType.primary,
                square: true,
                onPressed: () {},
              ),
              VanButton(
                text: "圆形按钮",
                round: true,
                type: VanType.success,
                onPressed: () {},
              ),
            ],
          ),
          SizedBox(height: 20),
          VanButtonGroup(
            radius: 32,
            children: [
              VanButton(
                width: 120,
                text: '按钮1',
                type: VanType.primary,
                onPressed: () {},
              ),
              VanButton(
                text: '按钮2',
                type: VanType.success,
                onPressed: () {},
              ),
              VanButton(
                width: 80,
                text: '按钮312341234',
                type: VanType.warning,
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: VanButtonExample(),
  ));
}
