import 'package:flutter/material.dart';

class VanActionBar extends StatelessWidget {
  /// 安全区域适配
  final bool safeAreaInsetBottom;

  /// 背景颜色
  final Color? backgroundColor;

  /// 图标按钮列表
  final List<VanActionBarIcon>? icons;

  /// 普通按钮列表
  final List<VanActionBarButton>? buttons;

  const VanActionBar({
    super.key,
    this.safeAreaInsetBottom = true,
    this.backgroundColor,
    this.icons,
    this.buttons,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.surface,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 2,
            offset: Offset(0, -1),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        bottom: safeAreaInsetBottom ? MediaQuery.of(context).padding.bottom : 5,
        left: 5,
        top: 5,
        right: 5,
      ),
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Row(
      children: [
        if (icons != null && icons!.isNotEmpty) _buildIcons(context),
        if (buttons != null && buttons!.isNotEmpty)
          Expanded(child: _buildButtons(context)),
      ],
    );
  }

  Widget _buildIcons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: icons!.map((icon) {
        return _buildIcon(context, icon);
      }).toList(),
    );
  }

  Widget _buildIcon(BuildContext context, VanActionBarIcon icon) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24), // 可选：圆角水波纹
        onTap: () => icon.onPressed?.call(),
        child: SizedBox(
          width: 48,
          height: 48,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon.icon, size: 18, color: icon.color),
              Text(icon.text, style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(180)),
      child: SizedBox(
        height: 37,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: buttons!.map((button) {
            return _buildButton(context, button);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, VanActionBarButton button) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Expanded(
      flex: 1,
      child: ElevatedButton(
        onPressed: () {
          if (button.onPressed != null) {
            button.onPressed!();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: button._bgColor,
          padding: const EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0), // 圆角半径
          ),
        ),
        child: Text(
          button.text,
          maxLines: 1,
          style: const TextStyle(fontSize: 14, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator(
      VanActionBarButton button, BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(
          (button.type == VantActionBarButtonType.defaultType
              ? Colors.black87
              : Colors.white),
        ),
      ),
    );
  }

  Widget _buildBadge(VanActionBarBadge badge, BuildContext context) {
    return Container(
      padding: badge.padding ??
          EdgeInsets.symmetric(
            horizontal: badge.dot ? 3 : 4,
            vertical: badge.dot ? 3 : 1,
          ),
      constraints: BoxConstraints(
        minWidth: badge.dot ? 6 : 0,
        minHeight: badge.dot ? 6 : 0,
      ),
      decoration: BoxDecoration(
        color: badge.backgroundColor ?? Theme.of(context).colorScheme.error,
        borderRadius: BorderRadius.circular(badge.radius ?? 10),
      ),
      child: badge.dot
          ? null
          : Text(
              badge.content!,
              style: badge.textStyle ??
                  TextStyle(
                    color: badge.textColor ?? Colors.white,
                    fontSize: badge.fontSize ?? 10,
                  ),
            ),
    );
  }
}

/// 图标按钮组件 (对应 van-action-bar-icon)
class VanActionBarIcon {
  /// 图标组件
  final IconData icon;

  /// 点击回调
  final VoidCallback? onPressed;

  /// 图标下方文字
  final String text;

  /// 文字颜色
  final Color? textColor;

  /// 图标颜色
  final Color? color;

  /// 徽标
  final VanActionBarBadge? badge;

  const VanActionBarIcon({
    required this.icon,
    this.onPressed,
    this.text = "",
    this.textColor,
    this.color,
    this.badge,
  });
}

/// 普通按钮组件 (对应 van-action-bar-button)
class VanActionBarButton {
  /// 按钮文字
  final String text;

  /// 按钮类型
  final VantActionBarButtonType type;

  /// 点击回调
  final VoidCallback? onPressed;

  /// 左侧图标
  final Color? color;

  /// 左侧图标
  final Widget? icon;

  /// 是否禁用按钮
  final bool disabled;

  /// 是否显示为加载状态
  final bool loading;

  const VanActionBarButton({
    required this.text,
    this.type = VantActionBarButtonType.defaultType,
    this.onPressed,
    this.icon,
    this.disabled = false,
    this.loading = false,
    this.color,
  });

  Color get _bgColor {
    if (color != null) return color!;
    if (type == VantActionBarButtonType.danger) {
      return const Color(0xffee0a24);
    } else if (type == VantActionBarButtonType.primary) {
      return const Color(0xff1989fa);
    } else if (type == VantActionBarButtonType.warning) {
      return const Color(0xffff976a);
    }
    return Colors.red;
  }
}

/// 徽标组件
class VanActionBarBadge {
  /// 徽标内容
  final String? content;

  /// 是否为圆点
  final bool dot;

  /// 背景颜色
  final Color? backgroundColor;

  /// 文字颜色
  final Color? textColor;

  /// 文字样式
  final TextStyle? textStyle;

  /// 文字大小
  final double? fontSize;

  /// 圆角
  final double? radius;

  /// 内边距
  final EdgeInsets? padding;

  const VanActionBarBadge({
    this.content,
    this.dot = false,
    this.backgroundColor,
    this.textColor,
    this.textStyle,
    this.fontSize,
    this.radius,
    this.padding,
  }) : assert(content != null || dot, 'Either content or dot must be provided');
}

enum VantActionBarButtonType {
  defaultType,
  primary,
  danger,
  warning,
}
