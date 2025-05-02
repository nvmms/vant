import 'package:flutter/material.dart';

class VanInput extends StatefulWidget {
  const VanInput({
    super.key,
    this.showWordLimit = false,
    this.maxlength,
    this.placeholder,
    this.clearable = false,
    this.formatter,
    this.parser,
    this.showPassword = false,
    this.disabled = false,
    this.rows = 2,
    this.readonly = false,
    this.autofocus = false,
    this.suffix,
    this.controller,
    this.blur,
    this.change,
    this.clear,
    this.focus,
    this.input,
    this.keyboardType,
    this.textInputAction,
  });

  final bool showWordLimit;
  final int? maxlength;
  final String? placeholder;
  final bool clearable;
  final String Function(String)? formatter;
  final String Function(String)? parser;
  final bool showPassword;
  final bool disabled;
  final int rows;
  final bool readonly;
  final bool autofocus;
  final Widget? suffix;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  final VoidCallback? blur;
  final VoidCallback? focus;
  final ValueChanged<String>? change;
  final ValueChanged<String>? input;
  final VoidCallback? clear;

  @override
  State<StatefulWidget> createState() => _VanInputState();
}

class _VanInputState extends State<VanInput> {
  double radius = 4.0;
  double borderSizeWidth = 1.0;
  late BorderRadius borderRadius;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    borderRadius = BorderRadius.circular(radius);

    widget.controller?.addListener(() {
      widget.input?.call(widget.controller?.text ?? "");
    });

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        widget.focus?.call();
      } else {
        widget.blur?.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      controller: widget.controller,
      enabled: !widget.disabled,
      readOnly: widget.readonly,
      focusNode: _focusNode,
      onChanged: (value) {
        widget.change?.call(value);
      },
      decoration: InputDecoration(
        fillColor: widget.disabled ? const Color(0xfff5f7fa) : Colors.white,
        filled: true,
        labelText: widget.placeholder,
        enabledBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(
            width: borderSizeWidth,
            color: const Color(0xffdcdfe6),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(
            width: borderSizeWidth,
            color: Theme.of(context).primaryColor,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(
            width: borderSizeWidth,
            color: const Color(0xffe4e7ed),
          ),
        ),
        hintStyle: const TextStyle(
          fontSize: 14,
        ),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.clearable)
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {},
                padding: EdgeInsets.zero,
              ),
            if (widget.suffix != null) widget.suffix!,
          ],
        ),
        contentPadding: const EdgeInsets.only(left: 10),
        isDense: false,
      ),
      onSubmitted: (value) {
        // 执行搜索操作
      },
    );
  }
}
