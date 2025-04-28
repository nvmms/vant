import 'package:flutter/material.dart';
import 'package:vant/vant.dart';
import 'dart:async'; // 添加此行以使用 Timer

class VanStepper<T extends num> extends StatefulWidget {
  final T? min;
  final T? max;
  final bool autoFixed;
  final T? defaultValue;
  final T? step;
  final double? inputWidth;
  final double? buttonSize;
  final String? placeholder;
  final bool disabled;
  final bool disablePlus;
  final bool disableMinus;
  final bool disableInput;
  final bool showPlus;
  final bool showMinus;
  final bool showInput;
  final bool longPress;
  final bool allowEmpty;

  final ValueChanged<T>? onChanged;
  final VoidCallback? onMinus;
  final VoidCallback? onPlus;
  final VoidCallback? onFocus;
  final VoidCallback? onBlur;
  final Color bgColor;

  const VanStepper({
    super.key,
    this.min,
    this.max,
    this.autoFixed = false,
    this.defaultValue,
    this.step,
    this.inputWidth,
    this.buttonSize,
    this.placeholder,
    this.disabled = false,
    this.disablePlus = false,
    this.disableMinus = false,
    this.disableInput = false,
    this.showPlus = true,
    this.showMinus = true,
    this.showInput = true,
    this.longPress = true,
    this.allowEmpty = false,
    this.onChanged,
    this.onMinus,
    this.onPlus,
    this.onFocus,
    this.onBlur,
    this.bgColor = const Color(0xfff7f7f8),
  });

  @override
  State createState() => _VanStepperState();
}

class _VanStepperState<T extends num> extends State<VanStepper<T>> {
  late T currentValue;
  Radius radius = const Radius.circular(6);
  Timer? _longPressTimer; // 用于处理长按的计时器

  T get min {
    return widget.min ?? 1 as T; // 如果未传递min值，则默认使用1
  }

  T? get max {
    return widget.max; // 如果未传递max值，则返回null，表示不限制最大值
  }

  T get step {
    return widget.step ?? 1 as T;
  }

  double get height {
    return widget.buttonSize ?? 40;
  }

  @override
  void initState() {
    super.initState();
    currentValue = widget.defaultValue ?? 1 as T;
  }

  void _increaseValue() {
    if (widget.disabled || widget.disablePlus) return;

    final num newValue = (currentValue as num) + (step as num);
    if (max == null || newValue <= max!) {
      setState(() {
        currentValue = newValue as T;
      });
      widget.onPlus?.call();
      widget.onChanged?.call(currentValue);
    }
  }

  void _decreaseValue() {
    if (widget.disabled || widget.disableMinus) return;

    final num newValue = (currentValue as num) - (step as num);
    if (newValue >= min) {
      setState(() {
        currentValue = newValue as T;
      });
      widget.onMinus?.call();
      widget.onChanged?.call(currentValue);
    }
  }

  void _onInputChange(String value) {
    if (widget.disabled || widget.disableInput) return;

    final parsedValue = num.tryParse(value);
    if (parsedValue != null &&
        parsedValue >= min &&
        (max == null || parsedValue <= max!)) {
      setState(() {
        currentValue = parsedValue as T;
      });
      widget.onChanged?.call(currentValue);
    }
  }

  void _startLongPress(bool isIncrease) {
    _longPressTimer?.cancel(); // 确保之前的计时器被取消
    _longPressTimer = Timer.periodic(const Duration(milliseconds: 200), (_) {
      if (isIncrease) {
        _increaseValue();
      } else {
        _decreaseValue();
      }
    });
  }

  void _stopLongPress() {
    _longPressTimer?.cancel();
    _longPressTimer = null;
  }

  @override
  Widget build(BuildContext context) {
    return VantSpace(
      spacing: 4,
      children: [
        // 减少按钮
        if (widget.showMinus)
          Material(
            color: widget.bgColor,
            borderRadius: BorderRadius.only(
              topLeft: radius,
              bottomLeft: radius,
            ),
            child: InkWell(
              onTap: _decreaseValue,
              onTapDown: (_) {
                if (widget.longPress) {
                  Future.delayed(
                    const Duration(milliseconds: 1200),
                    () => _startLongPress(false),
                  );
                }
              },
              onTapCancel: _stopLongPress,
              onTapUp: (_) => _stopLongPress(),
              child: SizedBox(
                width: height,
                height: height,
                child: const Icon(Icons.remove, color: Color(0xff323232)),
              ),
            ),
          ),

        // 输入框
        if (widget.showInput)
          Container(
            height: height,
            width: widget.inputWidth ?? 60,
            color: widget.bgColor,
            child: Center(
              child: TextField(
                textAlign: TextAlign.center, // 水平居中
                controller:
                    TextEditingController(text: currentValue.toString()),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  hintText: widget.placeholder ?? '输入',
                  enabled: !widget.disabled && !widget.disableInput,
                  isCollapsed: true,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 0,
                  ),
                ),
                onChanged: _onInputChange,
                onTap: widget.onFocus,
                onEditingComplete: widget.onBlur,
              ),
            ),
          ),

        // 增加按钮
        if (widget.showPlus)
          Material(
            color: widget.bgColor,
            borderRadius: BorderRadius.only(
              topRight: radius,
              bottomRight: radius,
            ),
            child: InkWell(
              onTap: _increaseValue,
              onTapDown: (_) {
                if (widget.longPress) {
                  Future.delayed(
                    const Duration(milliseconds: 1200),
                    () => _startLongPress(true),
                  );
                }
              },
              onTapCancel: _stopLongPress,
              onTapUp: (_) => _stopLongPress(),
              child: SizedBox(
                width: height,
                height: height,
                child: const Icon(Icons.add, color: Color(0xff323232)),
              ),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _longPressTimer?.cancel(); // 确保计时器在组件销毁时被取消
    super.dispose();
  }
}
