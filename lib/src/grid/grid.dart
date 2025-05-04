import 'package:flutter/material.dart';
import 'package:vant/src/grid/config.dart';
import 'package:vant/vant.dart';

class VanGrid extends StatelessWidget {
  final int columnNum;
  final double iconSize;
  final double gutter;
  final bool border;
  final bool center;
  final bool square;
  // final bool clickable;
  final String direction;
  final bool reverse;
  final List<VanGridItem> children;
  final ValueChanged<int>? onItemClick;

  const VanGrid({
    super.key,
    this.columnNum = 4,
    this.iconSize = 28.0,
    this.gutter = 0.0,
    this.border = true,
    this.center = true,
    this.square = false,
    // this.clickable = false,
    this.direction = 'vertical',
    this.reverse = false,
    required this.children,
    this.onItemClick,
  });

  TextStyle get style => const TextStyle(
        fontSize: 12,
      );

  double get borderWidth => border ? 1 : 0;

  BorderSide get borderSide => BorderSide(
      width: borderWidth, color: border ? vanBorderColor : Colors.transparent);

  bool isFirstRow(int index) {
    return index < columnNum;
  }

  bool isFirstColumn(int index) {
    return index % columnNum == 0;
  }

  List<Widget> buildChild(VanGridItem item) {
    if (item.child != null) return [item.child!];
    List<Widget> child = [
      if (item.icon != null) Icon(item.icon!, size: iconSize),
      if (item.text != null) Text(item.text!, style: style),
    ];
    if (reverse) {
      return child.reversed.toList();
    } else {
      return child;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double width = constraints.maxWidth - (gutter * (columnNum - 1));
      width = width / columnNum;
      return Wrap(
        spacing: gutter,
        runSpacing: gutter,
        children: List.generate(children.length, (index) {
          VanGridItem item = children[index];
          var child = Container(
            width: width,
            height: square ? width : null,
            padding: vanGridItemContentPadding,
            decoration: BoxDecoration(
              border: Border(
                left: isFirstColumn(index) ? borderSide : BorderSide.none,
                top: isFirstRow(index) ? borderSide : BorderSide.none,
                right: borderSide,
                bottom: borderSide,
              ),
            ),
            child: VanBadge(
              content: item.content,
              count: item.count,
              dot: item.dot,
              child: VanSpace(
                spacing: 4,
                direction: Axis.vertical,
                mainAxisAlignment:
                    center ? MainAxisAlignment.center : MainAxisAlignment.start,
                children: buildChild(item),
              ),
            ),
          );
          return Material(
            color: vanGridItemContentBackground, // 保持透明或你想要的背景色
            child: InkWell(
              onTap: onItemClick != null
                  ? () {
                      onItemClick?.call(index);
                    }
                  : null,
              child: child,
            ),
          );
        }),
      );
    });
  }
}
