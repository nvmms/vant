import 'package:flutter/material.dart';
import 'package:vant/src/submit_bar/config.dart';
import 'package:vant/vant.dart';

class VanSubmitBar extends StatelessWidget {
  const VanSubmitBar({
    super.key,
    required this.price,
    this.decimalLength = 2,
    this.label = '合计：',
    this.suffixLabel,
    this.textAlign = TextAlign.right,
    this.buttonText = "提交订单",
    this.buttonType = VanType.danger,
    this.buttonColor,
    this.tip,
    this.tipIcon,
    this.currency = '¥',
    this.disabled = false,
    this.loading = false,
    this.child,
    this.button,
    this.top,
    this.tipWidget,
    this.onSubmit,
    // this.safeAreaInsetBottom = true,
    // this.placeholder = false,
  });

  final int price; // 金额（单位分）
  final int decimalLength; // 金额小数点位数
  final String label; // 金额左侧文案
  final String? suffixLabel; // 金额右侧文案
  final TextAlign textAlign; // 金额文案对齐方向
  final String? buttonText; // 按钮文字
  final VanType buttonType; // 按钮类型
  final String? buttonColor; // 自定义按钮颜色
  final String? tip; // 提示文案
  final IconData? tipIcon; // 提示文案左侧的图标名称或图片链接
  final String currency; // 货币符号
  final bool disabled; // 是否禁用按钮
  final bool loading; // 是否显示加载中状态

  final Widget? child; //	自定义订单栏左侧内容
  final Widget? button; //	自定义按钮
  final Widget? top; //  自定义订单栏上方内容
  final Widget? tipWidget; //	提示文案中的额外内容

  final VoidCallback? onSubmit;

  String get priceString => price.toString();

  String get priceInteger {
    if (priceString.length > 2) {
      return priceString.substring(0, priceString.length - 2);
    } else {
      return '0';
    }
  }

  String get priceDecimal {
    var c = '';
    if (priceString.length > 2) {
      c = priceString.substring(priceString.length - 2);
    } else {
      c = priceString;
    }
    if (c.length == decimalLength) {
      return c;
    } else if (c.length > decimalLength) {
      return c.substring(0, decimalLength);
    } else {
      return c +
          List.generate(decimalLength - c.length, (index) => "0").join("");
    }
  }

  Widget? get getTip {
    if (top != null) {
      return top;
    } else if (tip != null || tipWidget != null) {
      Widget child = VanSpace(children: [
        if (tipIcon != null)
          Icon(
            tipIcon,
            size: vanSubmitBarTipIconSize,
            color: vanSubmitBarTipColor,
          ),
        Text(
          "$tip",
          style: const TextStyle(
            fontSize: vanSubmitBarTipFontSize,
            color: vanSubmitBarTipColor,
            height: vanSubmitBarTipLineHeight,
          ),
        ),
      ]);
      if (tipWidget != null) {
        child = tipWidget!;
      }

      return Container(
        width: double.infinity,
        padding: vanSubmitBarTipPadding,
        decoration: const BoxDecoration(
          color: vanSubmitBarTipBackground,
        ),
        child: child,
      );
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (getTip != null) getTip!,
        Container(
          height: vanSubmitBarHeight,
          padding: vanSubmitBarPadding,
          decoration: const BoxDecoration(
            color: vanSubmitBarBackground,
          ),
          child: VanSpace(
            children: [
              if (child != null) child!,
              Expanded(
                child: Text.rich(
                  TextSpan(
                    style: const TextStyle(
                      color: vanSubmitBarTextColor,
                      fontSize: vanSubmitBarTextFontSize,
                    ),
                    children: [
                      TextSpan(text: label),
                      TextSpan(
                        style: const TextStyle(
                          color: vanSubmitBarPriceColor,
                          fontSize: vanSubmitBarPriceFontSize,
                        ),
                        children: [
                          TextSpan(text: currency),
                          TextSpan(
                            text: priceInteger,
                            style: const TextStyle(
                              fontSize: vanSubmitBarPriceIntegerFontSize,
                              color: vanSubmitBarPriceColor,
                            ),
                          ),
                          TextSpan(text: '.$priceDecimal'),
                        ],
                      ),
                      TextSpan(text: suffixLabel),
                    ],
                  ),
                  textAlign: textAlign,
                ),
              ),
              if (button != null) button!,
              if (button == null)
                SizedBox(
                  width: vanSubmitBarButtonWidth,
                  height: vanSubmitBarButtonHeight,
                  child: VanButton(
                    type: buttonType,
                    text: buttonText,
                    round: true,
                    onPressed: onSubmit,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
