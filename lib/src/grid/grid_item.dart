import 'package:flutter/material.dart';

class VanGridItem {
  final String? text;
  final IconData? icon;
  final Widget? child;
  final Color? iconColor;
  final bool dot;
  final dynamic badge;

  const VanGridItem({
    this.text,
    this.icon,
    this.child,
    this.iconColor,
    this.dot = false,
    this.badge,
  }) : assert(child != null || icon != null || text != null);
}
