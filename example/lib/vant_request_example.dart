import 'package:flutter/material.dart';
import 'package:vant/vant.dart';

class VantRequestExample extends StatelessWidget {
  const VantRequestExample({super.key});

  @override
  Widget build(BuildContext context) {
    VantRequestProvider<String> provider = VantRequestProvider<String>();
    provider.onQuery = (page, pageSize) {
      print("onQuery $page $pageSize");
      Future.delayed(const Duration(milliseconds: 200), () {
        provider.complete(
          data: List.generate(20, (index) => "$index"),
          totalRow: 100,
          error: "asdfasdfasdf",
        );
      });
    };

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("VantRequestExample"),
        ),
        body: VantRequest(
          provider: provider,
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
  runApp(const VantRequestExample());
}
