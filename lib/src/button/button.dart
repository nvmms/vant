import 'package:flutter/material.dart';
import 'package:vant/vant.dart';

/// Button尺寸
enum VanButtonSize {
  large,
  normal,
  small,
  mini,
}

/// Van风格的Button组件
class VanButton extends StatelessWidget {
  /// 按钮文字
  final String? text;

  /// 按钮子组件
  final Widget? child;

  /// 按钮类型
  final VanType type;

  /// 按钮尺寸
  final VanButtonSize size;

  /// 是否禁用按钮
  final bool disabled;

  /// 是否显示为块级元素
  final bool block;

  /// 是否为朴素按钮
  final bool plain;

  /// 是否为圆角按钮
  final bool round;

  /// 是否为方形按钮
  final bool square;

  /// 是否显示加载状态
  final bool loading;

  /// 自定义图标
  final Widget? icon;

  /// 点击回调
  final VoidCallback? onPressed;

  /// 自定义按钮颜色
  final Color? color;

  /// 按钮内边距
  final EdgeInsetsGeometry? padding;

  final BorderRadius? borderRadius;

  const VanButton({
    super.key,
    this.text,
    this.child,
    this.type = VanType.normal,
    this.size = VanButtonSize.normal,
    this.disabled = false,
    this.block = false,
    this.plain = false,
    this.round = false,
    this.square = false,
    this.loading = false,
    this.icon,
    this.onPressed,
    this.color,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    // 根据类型设置颜色
    final buttonColors = _getButtonColors();
    final backgroundColor = plain ? Colors.transparent : buttonColors.first;
    final textColor = plain ? buttonColors.first : buttonColors.last;
    final borderColor = buttonColors.first;

    // 根据尺寸设置高度和字体大小
    final height = _getHeightBySize();
    final fontSize = _getFontSizeBySize();

    // 构建按钮内容
    final buttonContent = _buildButtonContent(textColor, fontSize);

    // 构建按钮组件
    return SizedBox(
      width: block ? double.infinity : null,
      height: height,
      child: Material(
        color: disabled ? Colors.grey.shade300 : color ?? backgroundColor,
        borderRadius: _getBorderRadius(),
        child: InkWell(
          onTap: (disabled || loading) ? null : onPressed,
          borderRadius: _getBorderRadius(),
          child: Container(
            padding: padding ?? _getPaddingBySize(),
            decoration: BoxDecoration(
              border: Border.all(
                color: disabled ? Colors.grey.shade300 : borderColor,
                width: 1,
              ),
              borderRadius: _getBorderRadius(),
            ),
            child: buttonContent,
          ),
        ),
      ),
    );
  }

  // 获取按钮颜色
  List<Color> _getButtonColors() {
    switch (type) {
      case VanType.primary:
        return [Colors.blue, Colors.white];
      case VanType.success:
        return [Colors.green, Colors.white];
      case VanType.warning:
        return [Colors.orange, Colors.white];
      case VanType.danger:
        return [Colors.red, Colors.white];
      case VanType.normal:
      default:
        return [Colors.white, Colors.black87];
    }
  }

  // 获取按钮高度
  double _getHeightBySize() {
    switch (size) {
      case VanButtonSize.large:
        return 50.0;
      case VanButtonSize.normal:
        return 44.0;
      case VanButtonSize.small:
        return 32.0;
      case VanButtonSize.mini:
        return 24.0;
    }
  }

  // 获取字体大小
  double _getFontSizeBySize() {
    switch (size) {
      case VanButtonSize.large:
        return 16.0;
      case VanButtonSize.normal:
        return 14.0;
      case VanButtonSize.small:
        return 12.0;
      case VanButtonSize.mini:
        return 10.0;
    }
  }

  // 获取按钮内边距
  EdgeInsetsGeometry _getPaddingBySize() {
    switch (size) {
      case VanButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 16);
      case VanButtonSize.normal:
        return const EdgeInsets.symmetric(horizontal: 14);
      case VanButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 8);
      case VanButtonSize.mini:
        return const EdgeInsets.symmetric(horizontal: 4);
    }
  }

  // 获取边框圆角
  BorderRadius _getBorderRadius() {
    if (borderRadius != null) {
      return borderRadius!;
    }
    if (square) {
      return BorderRadius.zero;
    }
    if (round) {
      return BorderRadius.circular(999);
    }
    return BorderRadius.circular(2);
  }

  // 构建按钮内容
  Widget _buildButtonContent(Color textColor, double fontSize) {
    List<Widget> children = [];

    // 添加加载图标
    if (loading) {
      children.add(
        SizedBox(
          width: 14,
          height: 14,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(textColor),
          ),
        ),
      );
      children.add(const SizedBox(width: 4));
    }
    // 添加自定义图标
    else if (icon != null) {
      children.add(icon!);
      children.add(const SizedBox(width: 4));
    }

    // 添加文本
    if (child != null) {
      children.add(child!);
    } else if (text != null) {
      children.add(
        Text(
          text!,
          style: TextStyle(
            color: disabled ? Colors.grey : textColor,
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  /// 创建一个新的 VanButton 实例，基于当前实例的属性，并允许覆盖部分属性
  VanButton copyWith({
    String? text,
    Widget? child,
    VanType? type,
    VanButtonSize? size,
    bool? disabled,
    bool? block,
    bool? plain,
    bool? round,
    bool? square,
    bool? loading,
    Widget? icon,
    VoidCallback? onPressed,
    Color? color,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
  }) {
    return VanButton(
      text: text ?? this.text,
      type: type ?? this.type,
      size: size ?? this.size,
      disabled: disabled ?? this.disabled,
      block: block ?? this.block,
      plain: plain ?? this.plain,
      round: round ?? this.round,
      square: square ?? this.square,
      loading: loading ?? this.loading,
      icon: icon ?? this.icon,
      onPressed: onPressed ?? this.onPressed,
      color: color ?? this.color,
      padding: padding ?? this.padding,
      borderRadius: borderRadius ?? this.borderRadius,
      child: child ?? this.child,
    );
  }
}
