import 'package:flutter/material.dart';
import 'package:vant/src/index.dart';

class VanCellGroup extends StatefulWidget {
  final String? title;
  final List<VanCell> children;
  final bool inset;
  final bool selectable;
  final bool multiple;
  final ValueChanged<List<Key?>>? onChange;
  final List<Key?>? defaultSelectedKeys;

  const VanCellGroup({
    super.key,
    this.title,
    required this.children,
    this.inset = false,
    this.selectable = false,
    this.multiple = false,
    this.onChange,
    this.defaultSelectedKeys,
  });

  @override
  State createState() => _VanCellGroupState();
}

class _VanCellGroupState extends State<VanCellGroup> {
  List<Key?> selectedKeys = [];

  @override
  void initState() {
    super.initState();
    if (widget.defaultSelectedKeys != null) {
      selectedKeys = widget.defaultSelectedKeys!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final BorderRadius borderRadius = BorderRadius.circular(8.0);

    return Container(
      margin: widget.inset
          ? const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0)
          : EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null)
            Padding(
              padding: const EdgeInsets.only(left: 4.0, bottom: 6.0),
              child: Text(
                widget.title!,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ),
          ClipRRect(
            borderRadius: widget.inset ? borderRadius : BorderRadius.zero,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                border: Border.all(color: const Color(0xFFEDEDED), width: 0.5),
              ),
              child: Column(
                children: widget.children
                    .map((cell) => InkWell(
                          onTap: () {
                            if (widget.selectable) {
                              if (widget.multiple) {
                                setState(() {
                                  if (selectedKeys.contains(cell.key)) {
                                    selectedKeys.remove(cell.key);
                                  } else {
                                    selectedKeys.add(cell.key);
                                  }
                                });
                              } else {
                                setState(() {
                                  selectedKeys = [cell.key];
                                });
                              }
                              widget.onChange?.call(selectedKeys);
                            }
                          },
                          child: cell.copyWith(
                            selected: selectedKeys.contains(cell.key),
                            selectable: widget.selectable,
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
