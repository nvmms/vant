import 'package:flutter/material.dart';
import 'package:vant/vant.dart';

class VanActionSheet extends StatelessWidget {
  const VanActionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ActionSheet')),
      body: Container(
        child: Column(
          children: [
            VanCellGroup(
              title: "基础用法",
              children: [
                VanCell(
                  title: "基础用法",
                  isLink: true,
                  onTap: () {
                    showActionSheet(
                      context,
                      actions: const [
                        VanActionSheetAction(name: "选项1"),
                        VanActionSheetAction(name: "选项2"),
                        VanActionSheetAction(name: "选项3"),
                      ],
                    );
                  },
                ),
                VanCell(
                  title: "展示图标",
                  isLink: true,
                  onTap: () {
                    showActionSheet(
                      context,
                      actions: const [
                        VanActionSheetAction(name: "选项1", icon: Icons.abc),
                        VanActionSheetAction(
                            name: "选项2", icon: Icons.abc_sharp),
                        VanActionSheetAction(
                            name: "选项3", icon: Icons.add_alarm),
                      ],
                    );
                  },
                ),
                VanCell(
                  title: "展示取消按钮",
                  isLink: true,
                  onTap: () {
                    showActionSheet(
                      context,
                      cancelText: "取消",
                      actions: const [
                        VanActionSheetAction(name: "选项1"),
                        VanActionSheetAction(name: "选项2"),
                        VanActionSheetAction(name: "选项3"),
                      ],
                    );
                  },
                ),
                VanCell(
                  title: "展示描述信息",
                  isLink: true,
                  onTap: () {
                    showActionSheet(
                      context,
                      description: "这是一段描述信息",
                      actions: const [
                        VanActionSheetAction(name: "选项1"),
                        VanActionSheetAction(name: "选项2"),
                        VanActionSheetAction(name: "选项3", subname: "描述信息"),
                      ],
                    );
                  },
                ),
              ],
            ),
            VanCellGroup(
              title: "选项状态",
              children: [
                VanCell(
                  title: "选项状态",
                  isLink: true,
                  onTap: () {
                    showActionSheet(
                      context,
                      cancelText: "取消",
                      closeOnClickOverlay: true,
                      actions: const [
                        VanActionSheetAction(name: "选项1", color: Colors.red),
                        VanActionSheetAction(name: "选项2", disabled: true),
                        VanActionSheetAction(name: "选项3", loading: true),
                      ],
                    );
                  },
                ),
              ],
            ),
            VanCellGroup(
              title: "自定义面板",
              children: [
                VanCell(
                  title: "自定义面板",
                  onTap: () {
                    showActionSheet(
                      context,
                      title: "标题",
                      child: Container(
                        height: 300,
                        color: Colors.red,
                        child: const Center(
                          child: Text("自定义面板"),
                        ),
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
