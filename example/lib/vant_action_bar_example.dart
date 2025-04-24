import 'package:flutter/material.dart';
import 'package:vant/vant.dart';

class VantActionBarExample extends StatelessWidget {
  const VantActionBarExample({super.key});

  @override
  Widget build(Object context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("VantActionBar"),
      ),
      body: VantActionBar(
        icons: [
          VantActionBarIcon(
            icon: Icons.chat,
            text: "客服",
            onPressed: () => print('客服'),
            badge: VantActionBarBadge(dot: true),
          ),
          VantActionBarIcon(
            icon: Icons.shopping_cart,
            text: "购物车",
            onPressed: () => print('购物车'),
            badge: VantActionBarBadge(content: '5'),
          ),
          VantActionBarIcon(
            icon: Icons.star,
            text: "收藏",
            onPressed: () => print('收藏'),
          ),
        ],
        buttons: [
          VantActionBarButton(
            text: "加入购物车",
            type: VantActionBarButtonType.primary,
            onPressed: () => print('加入购物车'),
          ),
          VantActionBarButton(
            text: "立即购买",
            type: VantActionBarButtonType.danger,
            onPressed: () => print('立即购买'),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: VantActionBarExample()));
}
