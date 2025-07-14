import 'package:flutter/material.dart';
import 'package:vant/vant.dart';

class VanActionBarExample extends StatelessWidget {
  const VanActionBarExample({super.key});

  @override
  Widget build(Object context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("VantActionBar"),
      ),
      body: VanActionBar(
        icons: [
          VanActionBarIcon(
            icon: Icons.chat,
            text: "客服",
            onPressed: () => print('客服'),
            count: 5,
          ),
          VanActionBarIcon(
            icon: Icons.shopping_cart,
            text: "购物车",
            onPressed: () => print('购物车'),
          ),
          VanActionBarIcon(
            icon: Icons.star,
            text: "收藏",
            onPressed: () => print('收藏'),
          ),
        ],
        buttons: [
          VanActionBarButton(
            text: "加入购物车",
            type: VantActionBarButtonType.primary,
            onPressed: () => print('加入购物车'),
          ),
          VanActionBarButton(
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
  runApp(MaterialApp(home: VanActionBarExample()));
}
