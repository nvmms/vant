import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:vant/vant.dart';
import 'dart:async';

class VanStepper extends StatefulWidget {
  final double? doubleMin;
  final int? intMin;

  final double? doubleMax;
  final int? intMax;

  final bool autoFixed;

  final double? doubleDefaultValue;
  final int? intDefaultValue;

  final double? doubleStep;
  final int? intStep;

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

  final ValueChanged<double>? onDoubleChanged;
  final ValueChanged<int>? onIntChanged;

  final VoidCallback? onMinus;
  final VoidCallback? onPlus;
  final VoidCallback? onFocus;
  final VoidCallback? onBlur;
  final Color bgColor;

  const VanStepper.int({
    super.key,
    int min = 1,
    int? max,
    this.autoFixed = false,
    int defaultValue = 1,
    int step = 1,
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
    this.onMinus,
    this.onPlus,
    this.onFocus,
    this.onBlur,
    this.bgColor = const Color(0xfff7f7f8),
    ValueChanged<int>? onChanged,
  })  : intMin = min,
        intMax = max,
        intDefaultValue = defaultValue,
        intStep = step,
        onIntChanged = onChanged,
        doubleMin = null,
        doubleMax = null,
        doubleDefaultValue = null,
        doubleStep = null,
        onDoubleChanged = null;

  const VanStepper.double({
    super.key,
    double min = 1.0,
    double? max,
    this.autoFixed = false,
    double defaultValue = 1.0,
    double step = 1.0,
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
    this.onMinus,
    this.onPlus,
    this.onFocus,
    this.onBlur,
    this.bgColor = const Color(0xfff7f7f8),
    ValueChanged<double>? onChanged,
  })  : intMin = null,
        intMax = null,
        intDefaultValue = null,
        intStep = null,
        onIntChanged = null,
        doubleMin = min,
        doubleMax = max,
        doubleDefaultValue = defaultValue,
        doubleStep = step,
        onDoubleChanged = onChanged;

  @override
  State createState() => _VanStepperState();
}

class _VanStepperState extends State<VanStepper> {
  double? doubleCurrentValue;
  int? intCurrentValue;
  double normalHeight = 40;

  Radius radius = const Radius.circular(6);

  // Timer? _longPressTimer; // 用于处理长按的计时器

  String get currentValue {
    if (widget.onIntChanged != null) {
      return intCurrentValue.toString();
    } else if (widget.onDoubleChanged != null) {
      return doubleCurrentValue!.toStringAsFixed(decimalPlaces);
    } else {
      throw UnimplementedError('onChanged is not implemented');
    }
  }

  double get iconSize {
    return (height / normalHeight) * 30;
  }

  double get fontSize {
    return (height / normalHeight) * 20;
  }

  double get height {
    return widget.buttonSize ?? normalHeight;
  }

  int get decimalPlaces {
    if (widget.onDoubleChanged != null) {
      int stepDecimalPlaces = 2;
      int valueDecimalPlaces = 2;

      String str = doubleCurrentValue.toString();
      int decimalPointIndex = str.indexOf('.');
      if (decimalPointIndex > -1) {
        valueDecimalPlaces = str.length - decimalPointIndex - 1;
      }

      String str1 = widget.doubleStep.toString();
      int stepDecimalPointIndex = str1.indexOf('.');
      if (decimalPointIndex > -1) {
        stepDecimalPlaces = str1.length - stepDecimalPointIndex - 1;
      }

      return (stepDecimalPlaces > valueDecimalPlaces)
          ? stepDecimalPlaces
          : valueDecimalPlaces;
    } else {
      return 2;
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.onIntChanged != null) {
      intCurrentValue = widget.intDefaultValue ?? widget.intMin;
    } else if (widget.onDoubleChanged != null) {
      doubleCurrentValue = widget.doubleDefaultValue ?? widget.doubleMin;
    } else {
      throw UnimplementedError('onChanged is not implemented');
    }
  }

  double add(double x1, double x2) {
    return (Decimal.parse(x1.toString()) + Decimal.parse(x2.toString()))
        .toDouble();
  }

  double subtract(double x1, double x2) {
    return (Decimal.parse(x1.toString()) - Decimal.parse(x2.toString()))
        .toDouble();
  }

  void _increaseValue() {
    if (widget.disabled || widget.disablePlus) return;

    if (widget.onDoubleChanged != null) {
      double newValue = add(doubleCurrentValue!, widget.doubleStep!);
      if (widget.doubleMax == null || newValue <= widget.doubleMax!) {
        setState(() {
          doubleCurrentValue = newValue;
        });
        widget.onDoubleChanged?.call(doubleCurrentValue!);
        widget.onMinus?.call();
      }
    } else if (widget.onIntChanged != null) {
      int newValue = intCurrentValue! + widget.intStep!;
      if (widget.intMax == null || newValue <= widget.intMax!) {
        setState(() {
          intCurrentValue = newValue;
        });
        widget.onIntChanged?.call(intCurrentValue!);
        widget.onMinus?.call();
      }
    } else {
      throw UnimplementedError('onChanged is not implemented');
    }
  }

  void _decreaseValue() {
    if (widget.disabled || widget.disableMinus) return;

    if (widget.onDoubleChanged != null) {
      double newValue = subtract(doubleCurrentValue!, widget.doubleStep!);

      if (widget.doubleMin == null || newValue >= widget.doubleMin!) {
        setState(() {
          doubleCurrentValue = newValue;
        });
        widget.onDoubleChanged?.call(doubleCurrentValue!);
        widget.onMinus?.call();
      }
    } else if (widget.onIntChanged != null) {
      int newValue = intCurrentValue! - widget.intStep!;
      if (widget.intMin == null || newValue >= widget.intMin!) {
        setState(() {
          intCurrentValue = newValue;
        });
        widget.onIntChanged?.call(intCurrentValue!);
        widget.onMinus?.call();
      }
    } else {
      throw UnimplementedError('onChanged is not implemented');
    }
  }

  void _onInputChange(String value) {
    if (widget.disabled || widget.disableInput) return;

    if (intCurrentValue != null) {
      int parsedValue = int.tryParse(value) ?? 0;
      if (parsedValue >= widget.intMin! &&
          (widget.intMax == null || parsedValue <= widget.intMax!)) {
        setState(() {
          intCurrentValue = parsedValue;
        });
        widget.onIntChanged?.call(intCurrentValue!);
      }
    } else if (doubleCurrentValue != null) {
      double parsedValue = double.tryParse(value) ?? 0.0;
      if (parsedValue >= widget.doubleMin! &&
          (widget.doubleMax == null || parsedValue <= widget.doubleMax!)) {
        setState(() {
          doubleCurrentValue = parsedValue;
        });
        widget.onDoubleChanged?.call(doubleCurrentValue!);
      }
    } else {
      throw UnimplementedError('onChanged is not implemented');
    }
  }

  void _startLongPress(bool isIncrease) {
    // _longPressTimer?.cancel(); // 确保之前的计时器被取消
    // _longPressTimer = Timer.periodic(const Duration(milliseconds: 200), (_) {
    //   if (isIncrease) {
    //     _increaseValue();
    //   } else {
    //     _decreaseValue();
    //   }
    // });
  }

  void _stopLongPress() {
    // _longPressTimer?.cancel();
    // _longPressTimer = null;
  }

  @override
  Widget build(BuildContext context) {
    return VanSpace(
      spacing: 2,
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
                child: Icon(
                  Icons.remove,
                  size: iconSize,
                  color: Color(0xff323232),
                ),
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
                controller: TextEditingController(
                  text: currentValue.toString(),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                style: TextStyle(
                  fontSize: fontSize,
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
                child: Icon(
                  Icons.add,
                  size: iconSize,
                  color: Color(0xff323232),
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    // _longPressTimer?.cancel(); // 确保计时器在组件销毁时被取消
    super.dispose();
  }
}
