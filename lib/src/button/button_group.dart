import 'package:flutter/material.dart';
import 'package:vant/vant.dart';

class VanButtonGroup extends StatelessWidget {
  final List<VanButton> children;
  final double radius;

  const VanButtonGroup({
    super.key,
    required this.children,
    this.radius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: children
          .map((button) => button.copyWith(
                borderRadius: BorderRadius.only(
                  topLeft: button == children.first
                      ? Radius.circular(radius)
                      : Radius.zero,
                  bottomLeft: button == children.first
                      ? Radius.circular(radius)
                      : Radius.zero,
                  topRight: button == children.last
                      ? Radius.circular(radius)
                      : Radius.zero,
                  bottomRight: button == children.last
                      ? Radius.circular(radius)
                      : Radius.zero,
                ),
              ))
          .toList(),
    );
  }
}
