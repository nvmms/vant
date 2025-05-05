import 'package:flutter/material.dart';
import 'package:vant/vant.dart';

class VanBadgeExample extends StatelessWidget {
  const VanBadgeExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const SingleChildScrollView(
        child: VanSpace(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VanCell(
              title: "aa",
              valueWidget: VanTag(
                text: "标签",
                closeable: true,
                type: VanType.danger,
              ),
            ),

            Wrap(
              // alignment: WrapAlignment.start,
              // crossAxisAlignment: WrapCrossAlignment.start,
              children: [
                VanTag(
                  text: "标签",
                  closeable: true,
                  type: VanType.danger,
                ),
              ],
            ),

            // VanTag(text: "标签", round: true),
            // VanTag(text: "标签", plain: true, type: VanType.primary),
            // VanTag(
            //   text: "标签",
            //   plain: true,
            //   size: VanTagSize.large,
            //   closeable: true,
            // ),
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
