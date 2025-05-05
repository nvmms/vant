import 'package:flutter/material.dart';
import 'package:vant/src/config.dart';
import 'package:vant/src/tag/config.dart';
import 'package:vant/vant.dart';

enum VanTagSize {
  large,
  medium,
}

class VanTag extends StatelessWidget {
  // 类型，可选值为 primary success danger warning
  final VanType? type;

  // 大小, 可选值为 large medium
  final VanTagSize? size;

  // 标签颜色
  final Color? color;

  // 是否展示标签
  final bool show;

  // 是否为空心样式
  final bool plain;

  // 是否为圆角样式
  final bool round;

  // 是否为标记样式
  final bool mark;

  // 文本颜色，优先级高于 color 属性
  final Color? textColor;

  // 是否为可关闭标签
  final bool closeable;

  final String text;

  final VoidCallback? onClick;

  final VoidCallback? onClose;

  const VanTag({
    super.key,
    this.type,
    this.size,
    this.color,
    this.show = true,
    this.plain = false,
    this.round = false,
    this.mark = false,
    this.textColor,
    this.closeable = false,
    required this.text,
    this.onClick,
    this.onClose,
  });

  Color get _getBackgroundColor {
    if (color != null) return color!;
    if (type == null) return Colors.grey[300]!; // 默认颜色
    if (plain) return vanTagPlainBackground;

    switch (type) {
      case VanType.primary:
        return vanTagPrimaryColor;
      case VanType.success:
        return vanTagSuccessColor;
      case VanType.danger:
        return vanDangerColor;
      case VanType.warning:
        return vanWarningColor;
      default:
        return Colors.white;
    }
  }

  Color get _getBorderColor {
    if (color != null) return color!;
    if (type == null) return Colors.grey[300]!; // 默认颜色
    // if (plain) return vanTagPlainBackground;

    switch (type) {
      case VanType.primary:
        return vanTagPrimaryColor;
      case VanType.success:
        return vanTagSuccessColor;
      case VanType.danger:
        return vanDangerColor;
      case VanType.warning:
        return vanWarningColor;
      default:
        return Colors.white;
    }
  }

  Color get _getTextColor {
    if (textColor != null) return textColor!;
    if (plain) {
      switch (type) {
        case VanType.primary:
          return vanTagPrimaryColor;
        case VanType.success:
          return vanTagSuccessColor;
        case VanType.danger:
          return vanDangerColor;
        case VanType.warning:
          return vanWarningColor;
        default:
          return Colors.white;
      }
    }

    return vanTagTextColor;
  }

  EdgeInsets get _getPadding {
    if (size == null) {
      return vanTagPadding;
    } else if (size == VanTagSize.medium) {
      return vanTagMediumPadding;
    } else if (size == VanTagSize.large) {
      return vanTagLargePadding;
    } else {
      throw UnimplementedError();
    }
  }

  double get _getRadius {
    if (size == null) {
      return vanTagRadius;
    } else if (size == VanTagSize.medium) {
      return vanTagMediumRadius;
    } else if (size == VanTagSize.large) {
      return vanTagLargeRadius;
    } else {
      throw UnimplementedError();
    }
  }

  double get _getFontSize {
    if (size == null) {
      return vanTagFontSize;
    } else if (size == VanTagSize.medium) {
      return vanTagMediumFontSize;
    } else if (size == VanTagSize.large) {
      return vanTagLargeFontSize;
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: _getBorderColor),
        color: _getBackgroundColor,
        borderRadius: BorderRadius.circular(
          round ? vanTagRoundRadius : _getRadius,
        ),
      ),
      child: InkWell(
        onTap: () {
          onClick?.call();
        },
        child: Container(
          constraints: const BoxConstraints(
            // 可选：设置最小宽度（如果需要）
            minWidth: 40, // 防止标签太窄
          ),
          padding: _getPadding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                text,
                style: TextStyle(
                  color: _getTextColor,
                  fontSize: _getFontSize,
                  height: 1.6,
                ),
              ),
              if (closeable)
                InkWell(
                  onTap: () {
                    onClose?.call();
                  },
                  child: Icon(
                    Icons.close,
                    color: _getTextColor,
                    size: _getFontSize,
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
