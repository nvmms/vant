import 'package:flutter/material.dart';

class VanGridItem {
  final String? text;
  final IconData? icon;
  final Widget? child;
  final Color? iconColor;
  final bool? dot;
  final String? content;
  final int? count;

  const VanGridItem({
    this.text,
    this.icon,
    this.child,
    this.iconColor,
    this.dot = false,
    this.content,
    this.count,
  }) : assert(child != null || icon != null || text != null);
}
