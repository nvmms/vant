import 'package:flutter/material.dart';

enum VanCellArrowDirection {
  left,
  up,
  down,
  right,
}

class VanCell extends StatelessWidget {
  final String? title;
  final String? value;
  final String? label;

  final double? size;
  final IconData? icon;
  final String? url;
  final bool border;
  final bool replace;
  final bool clickable;
  final bool isLink;
  final bool required;
  final bool center;
  final VanCellArrowDirection arrowDirection;
  final VoidCallback? onTap;

  final Widget? titleWidget;
  final Widget? valueWidget;
  final Widget? labelWidget;
  final Widget? iconWidget;
  final Widget? rightIconWidget;
  final Widget? extraWidget;
  final bool? selectable;
  final bool? selected;

  const VanCell({
    super.key,
    this.title,
    this.titleWidget,
    this.value,
    this.valueWidget,
    this.label,
    this.labelWidget,
    this.size,
    this.icon,
    this.url,
    this.border = true,
    this.replace = false,
    this.clickable = true,
    this.isLink = false,
    this.required = false,
    this.center = false,
    this.arrowDirection = VanCellArrowDirection.right,
    this.onTap,
    this.iconWidget,
    this.rightIconWidget,
    this.extraWidget,
    this.selectable,
    this.selected,
  });

  IconData _getArrowIcon() {
    switch (arrowDirection) {
      case VanCellArrowDirection.left:
        return Icons.chevron_left;
      case VanCellArrowDirection.up:
        return Icons.expand_less;
      case VanCellArrowDirection.down:
        return Icons.expand_more;
      case VanCellArrowDirection.right:
      default:
        return Icons.chevron_right;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: clickable ? onTap : null,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          decoration: BoxDecoration(
            border: border
                ? const Border(
                    bottom: BorderSide(color: Color(0xFFEDEDED), width: 0.5),
                  )
                : null,
          ),
          child: Row(
            crossAxisAlignment: label != null && labelWidget != null
                ? CrossAxisAlignment.start
                : center
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
            children: [
              if (iconWidget != null)
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: iconWidget!,
                )
              else if (icon != null)
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Icon(icon, size: size ?? 20),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: center
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (titleWidget != null)
                          Expanded(child: titleWidget!)
                        else if (title != null)
                          Expanded(
                            child: Text(
                              title!,
                              style: textTheme.bodyLarge,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        if (required)
                          const Padding(
                            padding: EdgeInsets.only(left: 4.0),
                            child: Text(
                              '*',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                      ],
                    ),
                    if (labelWidget != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: labelWidget!,
                      )
                    else if (label != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          label!,
                          style:
                              textTheme.bodySmall?.copyWith(color: Colors.grey),
                        ),
                      ),
                  ],
                ),
              ),
              if (extraWidget != null)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: extraWidget!,
                ),
              if (valueWidget != null)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: valueWidget!,
                  ),
                )
              else if (value != null)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Text(
                      value!,
                      style: textTheme.bodyMedium
                          ?.copyWith(color: Colors.grey[600]),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
              if (selectable == true)
                (selected == true
                    ? Icon(
                        Icons.check,
                        color: Theme.of(context).primaryColor,
                      )
                    : const SizedBox.shrink())
              else if (rightIconWidget != null)
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: rightIconWidget!,
                )
              else if (isLink)
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Icon(
                    _getArrowIcon(),
                    size: 20,
                    color: Colors.grey,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  VanCell copyWith({
    String? title,
    String? value,
    String? label,
    double? size,
    IconData? icon,
    String? url,
    bool? border,
    bool? replace,
    bool? clickable,
    bool? isLink,
    bool? required,
    bool? center,
    VanCellArrowDirection? arrowDirection,
    VoidCallback? onTap,
    Widget? titleWidget,
    Widget? valueWidget,
    Widget? labelWidget,
    Widget? iconWidget,
    Widget? rightIconWidget,
    Widget? extraWidget,
    bool? selectable,
    bool? selected,
  }) {
    return VanCell(
      title: title ?? this.title,
      value: value ?? this.value,
      label: label ?? this.label,
      size: size ?? this.size,
      icon: icon ?? this.icon,
      url: url ?? this.url,
      border: border ?? this.border,
      replace: replace ?? this.replace,
      clickable: clickable ?? this.clickable,
      isLink: isLink ?? this.isLink,
      required: required ?? this.required,
      center: center ?? this.center,
      arrowDirection: arrowDirection ?? this.arrowDirection,
      onTap: onTap ?? this.onTap,
      titleWidget: titleWidget ?? this.titleWidget,
      valueWidget: valueWidget ?? this.valueWidget,
      labelWidget: labelWidget ?? this.labelWidget,
      iconWidget: iconWidget ?? this.iconWidget,
      rightIconWidget: rightIconWidget ?? this.rightIconWidget,
      extraWidget: extraWidget ?? this.extraWidget,
      selectable: selectable ?? this.selectable,
      selected: selected ?? this.selected,
    );
  }
}
