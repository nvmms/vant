import 'package:flutter/material.dart';

class VantSearch extends StatefulWidget {
  /// 输入框的值
  final String value;

  /// 输入框提示文本
  final String? hint;

  /// 输入框标签
  final String? label;

  /// 是否显示清除按钮
  final bool clearable;

  /// 清除按钮图标
  final IconData clearIcon;

  /// 是否禁用输入框
  final bool disabled;

  /// 是否只读
  final bool readonly;

  /// 输入框最大长度
  final int? maxLength;

  /// 是否显示字数统计
  final bool showWordLimit;

  /// 输入框形状
  final ShapeBorder? shape;

  /// 背景颜色
  final Color? background;

  /// 输入框背景颜色
  final Color? fieldBackground;

  /// 搜索图标
  final IconData searchIcon;

  /// 左侧图标
  final Widget? leftIcon;

  /// 右侧自定义按钮
  final Widget? rightAction;

  /// 输入框内容变化回调
  final ValueChanged<String>? onChanged;

  /// 搜索回调（点击键盘搜索按钮时触发）
  final ValueChanged<String>? onSearch;

  /// 输入框获取焦点回调
  final VoidCallback? onFocus;

  /// 输入框失去焦点回调
  final VoidCallback? onBlur;

  /// 点击清除按钮回调
  final VoidCallback? onClear;

  const VantSearch({
    Key? key,
    this.value = '',
    this.hint,
    this.label,
    this.clearable = true,
    this.clearIcon = Icons.clear,
    this.disabled = false,
    this.readonly = false,
    this.maxLength,
    this.showWordLimit = false,
    this.shape,
    this.background,
    this.fieldBackground,
    this.searchIcon = Icons.search,
    this.leftIcon,
    this.rightAction,
    this.onChanged,
    this.onSearch,
    this.onFocus,
    this.onBlur,
    this.onClear,
  }) : super(key: key);

  @override
  _VantSearchState createState() => _VantSearchState();
}

class _VantSearchState extends State<VantSearch> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus && widget.onFocus != null) {
        widget.onFocus!();
      } else if (!_focusNode.hasFocus && widget.onBlur != null) {
        widget.onBlur!();
      }
    });
  }

  @override
  void didUpdateWidget(VantSearch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != _controller.text) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      color: widget.background ?? (isDark ? Colors.grey[900] : Colors.white),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          if (widget.leftIcon != null) ...[
            widget.leftIcon!,
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Container(
              decoration: ShapeDecoration(
                color: widget.fieldBackground ??
                    (isDark ? Colors.grey[800] : Colors.grey[100]),
                shape: widget.shape ??
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  Icon(
                    widget.searchIcon,
                    size: 20,
                    color: isDark ? Colors.grey[500] : Colors.grey[600],
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      enabled: !widget.disabled,
                      readOnly: widget.readonly,
                      maxLength: widget.maxLength,
                      decoration: InputDecoration(
                        hintText: widget.hint,
                        labelText: widget.label,
                        border: InputBorder.none,
                        counterText: widget.showWordLimit ? null : '',
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onChanged: widget.onChanged,
                      onSubmitted: widget.onSearch,
                    ),
                  ),
                  if (widget.clearable && _controller.text.isNotEmpty)
                    IconButton(
                      icon: Icon(widget.clearIcon, size: 20),
                      onPressed: () {
                        _controller.clear();
                        widget.onChanged?.call('');
                        widget.onClear?.call();
                      },
                      splashRadius: 20,
                    ),
                ],
              ),
            ),
          ),
          if (widget.rightAction != null) ...[
            const SizedBox(width: 8),
            widget.rightAction!,
          ],
        ],
      ),
    );
  }
}
