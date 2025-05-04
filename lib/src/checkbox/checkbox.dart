import 'package:flutter/material.dart';
import 'package:vant/src/checkbox/config.dart';
import 'package:vant/vant.dart';

enum VanCheckboxPosition {
  left,
  right,
}

enum VanCheckboxShape {
  square,
  round,
}

class VanCheckbox extends StatefulWidget {
  const VanCheckbox({
    super.key,
    this.shape = VanCheckboxShape.square,
    this.disabled = false,
    this.labelDisabled = false,
    this.labelPosition = VanCheckboxPosition.right,
    this.iconSize,
    this.checkedColor = vanCheckboxCheckedIconColor,
    this.bindGroup,
    this.indeterminate = false,
    this.text,
    this.checked = false,
    this.onToggle,
  });

  final VanCheckboxShape shape;
  final bool disabled;
  final bool labelDisabled;
  final VanCheckboxPosition labelPosition;
  final double? iconSize;
  final Color checkedColor;
  final String? bindGroup;
  final bool indeterminate;
  final String? text;
  final bool checked;
  final ValueChanged<bool>? onToggle;

  @override
  State<StatefulWidget> createState() => _VanCheckboxState();
}

class _VanCheckboxState extends State<VanCheckbox> {
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    isChecked = widget.checked;
  }

  void toggle() {
    isChecked = !isChecked;
    widget.onToggle?.call(isChecked);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return VanSpace(
      spacing: vanCheckboxLabelMargin,
      children: [
        Container(
          decoration: BoxDecoration(
            color: isChecked ? vanCheckboxCheckedIconColor : Colors.transparent,
            border: Border.all(width: 1, color: vanCheckboxBorderColor),
            borderRadius: BorderRadius.circular(
              widget.shape == VanCheckboxShape.square
                  ? vanCheckboxSize * 0.2
                  : vanCheckboxSize,
            ),
          ),
          child: InkWell(
            onTap: toggle,
            child: SizedBox(
              width: vanCheckboxSize,
              height: vanCheckboxSize,
              child: isChecked
                  ? Icon(Icons.check,
                      size: widget.iconSize ?? vanCheckboxSize * 0.8,
                      color: Colors.white)
                  : const SizedBox.shrink(),
            ),
          ),
        ),
        if (widget.text != null)
          GestureDetector(
            onTap: widget.labelDisabled ? null : toggle,
            child: Text(
              "${widget.text}",
              style: const TextStyle(
                color: vanCheckboxLabelColor,
                fontSize: vanCheckboxLabelFontSize,
              ),
            ),
          ),
      ],
    );
  }
}
