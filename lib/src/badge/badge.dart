import 'package:flutter/material.dart';
import 'package:vant/src/badge/config.dart';

enum VanBadgePosition {
  topRight,
  topLeft,
  bottomLeft,
  bottomRight,
}

class VanBadge extends StatelessWidget {
  const VanBadge({
    super.key,
    this.content,
    this.dot,
    this.count,
    this.color = vanBadgeBackground,
    this.max = 99,
    this.showZero = false,
    this.position = VanBadgePosition.topRight,
    this.offset,
    required this.child,
  })  : assert(offset == null || offset.length == 2),
        assert(count != null || content != null || dot != null);

  final String? content;
  final bool? dot;
  final int? count;
  final Color color;
  final int max;
  final bool showZero;
  final VanBadgePosition position;
  final List<double>? offset;
  final Widget child;

  double? get left {
    if (offset != null) return offset![0];
    if (position == VanBadgePosition.topLeft ||
        position == VanBadgePosition.bottomLeft) {
      return 0 - 4;
    } else {
      return null;
    }
  }

  double? get top {
    if (offset != null) return offset![0];
    if (position == VanBadgePosition.topLeft ||
        position == VanBadgePosition.topRight) {
      return 0 - 4;
    } else {
      return null;
    }
  }

  double? get right {
    if (position == VanBadgePosition.topRight ||
        position == VanBadgePosition.bottomRight) {
      return 0 - 4;
    } else {
      return null;
    }
  }

  double? get bottom {
    if (offset != null) return offset![1];
    if (position == VanBadgePosition.bottomLeft ||
        position == VanBadgePosition.bottomRight) {
      return 0 - 4;
    } else {
      return null;
    }
  }

  String get text {
    if (count != null) {
      if (count! > max) {
        return "$max+";
      }
      return "$count";
    } else if (content != null) {
      return content!;
    } else {
      return "";
    }
  }

  Widget get childContainer {
    if (text.isNotEmpty) {
      return Container(
        padding: vanBadgePadding,
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(
            Radius.circular(999),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: vanBadgeColor,
            fontSize: vanBadgeFontSize,
          ),
        ),
      );
    } else if (dot == true) {
      return Container(
        width: vanBadgeDotSize,
        height: vanBadgeDotSize,
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(
            Radius.circular(vanBadgeDotSize),
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Center(child: child),
        Positioned(
          top: top,
          left: left,
          right: right,
          bottom: bottom,
          child: childContainer,
        ),
      ],
    );
  }
}
