import 'package:flutter/material.dart';
import 'package:vant/vant.dart';

class VanDatePickerExample extends StatelessWidget {
  const VanDatePickerExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DatePicker')),
      body: SingleChildScrollView(
        child: VanSpace(
          direction: Axis.vertical,
          children: [
            VanDatePicker(
              options: VanDatePickerOptions(
                columnsType: [ColumnsType.day],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: VanDatePickerExample(),
  ));
}
