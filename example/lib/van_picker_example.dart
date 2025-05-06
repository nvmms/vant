import 'package:flutter/material.dart';
import 'package:vant/vant.dart';

class VanPickerExample extends StatelessWidget {
  const VanPickerExample({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> a = ["1", "2", "3"];
    final List<String> b = ["4", "5", "6"];
    final List<String> c = ["7", "8", "9"];
    return Scaffold(
      appBar: AppBar(title: const Text('ActionSheet')),
      body: SingleChildScrollView(
        child: VanSpace(
          direction: Axis.vertical,
          children: [
            VanPicker(
              options: VanPickerOptions(),
              columnCount: 3,
              itemBuild: (BuildContext context, int columnIndex,
                  List<int> selectedItem) {
                if (columnIndex == 0) {
                  return a
                      .map((e) => Center(
                            child: Text("$e"),
                          ))
                      .toList();
                } else if (columnIndex == 1) {
                  return b
                      .map((e) => Center(
                            child: Text("$e"),
                          ))
                      .toList();
                } else if (columnIndex == 2) {
                  return c
                      .map((e) => Center(
                            child: Text("$e"),
                          ))
                      .toList();
                } else {
                  throw UnimplementedError();
                }
              },
              // itemCount: 10,
            ),
            Builder(builder: (context) {
              return VanButton(
                text: "显示",
                onPressed: () {
                  showVanPicker(context, columnCount: 1,
                      itemBuild: (context, columnIndex, selectedItem) {
                    return List.generate(10, (index) => Text("$index"));
                  }, options: VanPickerOptions(
                    onConfirm: (value) {
                      print(value);
                    },
                  ));
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: VanPickerExample(),
  ));
}
