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
            VanTag(text: "标签", closeable: true),
            VanTag(text: "标签", round: true),
            VanTag(text: "标签", plain: true, type: VanType.primary),
            VanTag(
              text: "标签",
              plain: true,
              size: VanTagSize.large,
              closeable: true,
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
