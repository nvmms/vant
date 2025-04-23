import 'package:flutter/material.dart';

class VantSearch extends StatefulWidget {
  /// 当前输入的值
  final String value;

  /// 搜索框左侧文本
  final String? label;

  /// 名称，作为提交表单时的标识符
  final String? name;

  /// 搜索框形状，可选值为 round
  final String shape;

  /// 搜索框 id
  final String? id;

  /// 搜索框外部背景色
  final Color background;

  /// 输入的最大字符数
  final int? maxLength;

  /// 占位提示文字
  final String? placeholder;

  /// 是否启用清除图标
  final bool clearable;

  /// 清除图标
  final IconData clearIcon;

  /// 显示清除图标的时机
  final ClearTrigger clearTrigger;

  /// 是否自动聚焦
  final bool autoFocus;

  /// 是否在搜索框右侧显示取消按钮
  final bool showAction;

  /// 取消按钮文字
  final String actionText;

  /// 是否禁用输入框
  final bool disabled;

  /// 是否只读
  final bool readonly;

  /// 是否将输入内容标红
  final bool error;

  /// 底部错误提示文案
  final String? errorMessage;

  /// 输入内容格式化函数
  final String Function(String)? formatter;

  /// 格式化函数触发的时机
  final FormatTrigger formatTrigger;

  /// 输入框内容对齐方式
  final TextAlign inputAlign;

  /// 输入框左侧图标
  final IconData leftIcon;

  /// 输入框右侧图标
  final IconData? rightIcon;

  /// 自动完成属性
  final String? autocomplete;

  /// 输入变化回调
  final ValueChanged<String>? onChange;

  /// 搜索回调
  final ValueChanged<String>? onSearch;

  /// 取消回调
  final VoidCallback? onCancel;

  /// 清除回调
  final VoidCallback? onClear;

  /// 聚焦回调
  final VoidCallback? onFocus;

  /// 失焦回调
  final VoidCallback? onBlur;

  const VantSearch({
    Key? key,
    this.value = '',
    this.label,
    this.name,
    this.shape = 'square',
    this.id,
    this.background = const Color(0xFFF2F2F2),
    this.maxLength,
    this.placeholder,
    this.clearable = true,
    this.clearIcon = Icons.clear,
    this.clearTrigger = ClearTrigger.focus,
    this.autoFocus = false,
    this.showAction = false,
    this.actionText = '取消',
    this.disabled = false,
    this.readonly = false,
    this.error = false,
    this.errorMessage,
    this.formatter,
    this.formatTrigger = FormatTrigger.onChange,
    this.inputAlign = TextAlign.left,
    this.leftIcon = Icons.search,
    this.rightIcon,
    this.autocomplete,
    this.onChange,
    this.onSearch,
    this.onCancel,
    this.onClear,
    this.onFocus,
    this.onBlur,
  }) : super(key: key);

  @override
  _VantSearchState createState() => _VantSearchState();
}

enum ClearTrigger {
  always,
  focus,
}

enum FormatTrigger {
  onChange,
  onBlur,
}

class _VantSearchState extends State<VantSearch> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _showClear = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
    _updateClearVisibility();
  }

  @override
  void didUpdateWidget(VantSearch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != _controller.text) {
      _controller.text = widget.value;
    }
    _updateClearVisibility();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus) {
      widget.onFocus?.call();
    } else {
      widget.onBlur?.call();
      if (widget.formatTrigger == FormatTrigger.onBlur &&
          widget.formatter != null) {
        _formatValue();
      }
    }
    _updateClearVisibility();
  }

  void _formatValue() {
    if (widget.formatter == null) return;
    final formatted = widget.formatter!(_controller.text);
    if (formatted != _controller.text) {
      _controller.text = formatted;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: formatted.length),
      );
      widget.onChange?.call(formatted);
    }
  }

  void _updateClearVisibility() {
    final hasText = _controller.text.isNotEmpty;
    final shouldShow = widget.clearable &&
        hasText &&
        (widget.clearTrigger == ClearTrigger.always ||
            (widget.clearTrigger == ClearTrigger.focus && _focusNode.hasFocus));

    if (_showClear != shouldShow) {
      setState(() {
        _showClear = shouldShow;
      });
    }
  }

  void _handleChanged(String value) {
    if (widget.formatTrigger == FormatTrigger.onChange &&
        widget.formatter != null) {
      final formatted = widget.formatter!(value);
      if (formatted != value) {
        _controller.text = formatted;
        _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: formatted.length),
        );
        widget.onChange?.call(formatted);
        return;
      }
    }
    widget.onChange?.call(value);
    _updateClearVisibility();
  }

  void _handleClear() {
    _controller.clear();
    widget.onChange?.call('');
    widget.onClear?.call();
    _updateClearVisibility();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderRadius = widget.shape == 'round'
        ? BorderRadius.circular(100)
        : BorderRadius.circular(4);

    return LayoutBuilder(builder: (context, constraints) {
      // MediaQuery.of()
      final hasExplicitHeight = constraints.hasBoundedHeight &&
          constraints.maxHeight !=
              MediaQuery.of(context).size.height - kToolbarHeight;
      double height = hasExplicitHeight ? constraints.maxHeight : 54;

      return Container(
        height: height,
        color: widget.background,
        padding: const EdgeInsets.only(top: 10, left: 16, bottom: 10, right: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                if (widget.label != null) ...[
                  Text(
                    widget.label!,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Container(
                    height: height - 20,
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: borderRadius,
                    ),
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                    child: Row(
                      children: [
                        Icon(
                          widget.leftIcon,
                          size: 20,
                          color: theme.hintColor,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            focusNode: _focusNode,
                            cursorHeight: 16,
                            textAlignVertical: TextAlignVertical.center,
                            enabled: !widget.disabled,
                            readOnly: widget.readonly,
                            maxLength: widget.maxLength,
                            textAlign: widget.inputAlign,
                            autofocus: widget.autoFocus,
                            decoration: InputDecoration(
                              hintText: widget.placeholder,
                              border: InputBorder.none,
                              counterText: '',
                              errorText: null,
                              contentPadding: const EdgeInsets.only(bottom: 3),
                              isDense: true,
                              suffixIconConstraints: const BoxConstraints(
                                minWidth: 24,
                                maxWidth: 24,
                                minHeight: 18,
                                maxHeight: 18,
                              ),
                              suffixIcon: _showClear
                                  ? GestureDetector(
                                      onTap: () {
                                        _controller.clear();
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(left: 6),
                                        decoration: BoxDecoration(
                                          color: const Color(0xffc8c9cc),
                                          borderRadius:
                                              BorderRadius.circular(18),
                                        ),
                                        child:
                                            const Icon(Icons.close, size: 12),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                            style: widget.error
                                ? TextStyle(color: theme.colorScheme.error)
                                : null,
                            onChanged: _handleChanged,
                            onSubmitted: widget.onSearch,
                          ),
                        ),
                        if (widget.rightIcon != null) ...[
                          const SizedBox(width: 8),
                          Icon(widget.rightIcon, size: 20),
                        ],
                      ],
                    ),
                  ),
                ),
                if (widget.showAction) ...[
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () {
                      _focusNode.unfocus();
                      widget.onCancel?.call();
                    },
                    child: Text(widget.actionText),
                  ),
                ] else
                  const SizedBox(width: 16),
              ],
            ),
            if (widget.errorMessage != null && widget.errorMessage!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 12),
                child: Text(
                  widget.errorMessage!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}
