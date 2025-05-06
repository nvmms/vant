import 'package:flutter/material.dart';
import 'package:vant/vant.dart';

class VanActionSheet extends StatelessWidget {
  const VanActionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ActionSheet')),
      body: SingleChildScrollView(
        child: VanSpace(
          direction: Axis.vertical,
          children: [
            VanCellGroup(
              children: [
                VanCell(
                  title: "提示弹窗",
                  onTap: () {
                    showVanDialog(
                      context,
                      VanDialogOptions(
                        title: "标题",
                        message: "代码是写出来给人看的，附带能在机器上运行。",
                        showCancelButton: true,
                      ),
                    );
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: VanActionSheet(),
  ));
}
