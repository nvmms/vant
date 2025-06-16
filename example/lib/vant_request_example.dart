import 'package:flutter/material.dart';
import 'package:vant/vant.dart';

class VanRequestExample extends StatelessWidget {
  const VanRequestExample({super.key});

  @override
  Widget build(BuildContext context) {
    VanRequestProvider<String> provider = VanRequestProvider<String>();
    provider.onQuery = (page) {
      debugPrint("page $page");
      Future.delayed(const Duration(milliseconds: 50), () {
        provider.complete(
          data: [],
          totalRow: 0,
        );
      });
    };

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("VantRequestExample"),
        ),
        body: VanRequest(
          provider: provider,
          header: (context) {
            return Container(
              height: 200,
              color: Colors.red,
            );
          },
          footer: (context) {
            return Container(
              height: 200,
              color: Colors.red,
            );
          },
          itemBuilder: (context, item, index) => Container(
            padding: const EdgeInsets.all(10),
            child: Container(
              color: Colors.amber,
              child: Center(child: Text(item)),
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const VanRequestExample());
}
