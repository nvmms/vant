import 'package:flutter/material.dart';
import 'package:vant/vant.dart';

class VanGridExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const SingleChildScrollView(
        child: VantSpace(
          direction: Axis.vertical,
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: VanGrid(
                square: true,
                // border: false,
                children: [
                  VanGridItem(
                    icon: Icons.apple,
                    text: "A",
                  ),
                  VanGridItem(
                    text: "A",
                  ),
                  VanGridItem(
                    text: "C",
                  ),
                  VanGridItem(
                    text: "D",
                  ),
                ],
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
    home: VanGridExample(),
  ));
}
