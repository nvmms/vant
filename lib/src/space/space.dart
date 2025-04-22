import 'package:flutter/material.dart';

class VantSpace extends StatelessWidget {
  /// 主轴方向，默认为水平方向
  final Axis direction;

  /// 子组件之间的间距
  final double spacing;

  /// 是否自动换行，仅在水平方向时有效
  final bool wrap;

  /// 主轴对齐方式
  final MainAxisAlignment mainAxisAlignment;

  /// 交叉轴对齐方式
  final CrossAxisAlignment crossAxisAlignment;

  /// 子组件列表
  final List<Widget> children;

  const VantSpace({
    Key? key,
    this.direction = Axis.horizontal,
    this.spacing = 8.0,
    this.wrap = false,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (direction == Axis.vertical) {
      return Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: _buildChildrenWithSpacing(),
      );
    } else {
      if (wrap) {
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: children,
        );
      } else {
        return Row(
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
          children: _buildChildrenWithSpacing(),
        );
      }
    }
  }

  List<Widget> _buildChildrenWithSpacing() {
    if (children.isEmpty) return [];

    final List<Widget> spacedChildren = [];

    for (int i = 0; i < children.length; i++) {
      spacedChildren.add(children[i]);

      // 如果不是最后一个元素，添加间距
      if (i != children.length - 1) {
        if (direction == Axis.horizontal) {
          spacedChildren.add(SizedBox(width: spacing));
        } else {
          spacedChildren.add(SizedBox(height: spacing));
        }
      }
    }

    return spacedChildren;
  }
}
