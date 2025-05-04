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
            VanCheckbox(
              shape: VanCheckboxShape.round,
              text: "sdfasdfasdfasdfasdf",
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
