import 'package:flutter/material.dart';
import 'package:vant/src/index.dart';

class VanCellGroup extends StatelessWidget {
  final String? title;
  final List<VanCell> children;
  final bool inset;

  const VanCellGroup({
    super.key,
    this.title,
    required this.children,
    this.inset = false,
  });

  @override
  Widget build(BuildContext context) {
    final BorderRadius borderRadius = BorderRadius.circular(8.0);

    return Container(
      margin: inset
          ? const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0)
          : EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.only(left: 4.0, bottom: 6.0),
              child: Text(
                title!,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ),
          ClipRRect(
            borderRadius: borderRadius,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFEDEDED), width: 0.5),
                borderRadius: borderRadius,
              ),
              child: Column(
                children: List.generate(children.length, (index) {
                  final isLast = index == children.length - 1;
                  final cell = children[index];
                  // 动态覆盖 border 属性
                  return cell;
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
