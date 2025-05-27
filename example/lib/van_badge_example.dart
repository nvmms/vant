import 'package:flutter/material.dart';
import 'package:vant/vant.dart';

class VanBadgeExample extends StatelessWidget {
  const VanBadgeExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: VanSpace(
          direction: Axis.vertical,
          children: [
            Container(
              color: Colors.red,
              child: VanBadge(
                count: 2,
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.amber,
                ),
              ),
            ),
            VanBadge(
              dot: true,
              child: Container(
                width: 100,
                height: 100,
                color: Colors.amber,
              ),
            ),
            VanBadge(
              count: 2,
              position: VanBadgePosition.bottomLeft,
              child: Container(
                width: 100,
                height: 100,
                color: Colors.amber,
              ),
            ),
            VanBadge(
              count: 2,
              position: VanBadgePosition.bottomRight,
              child: Container(
                width: 100,
                height: 100,
                color: Colors.amber,
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
    home: VanBadgeExample(),
  ));
}
