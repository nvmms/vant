import 'package:flutter/material.dart';
import 'package:vant/src/config.dart';

// 背景颜色
const Color vanPickerBackground = vanBackground2; // 示例颜色，请根据实际变量值调整

// 工具栏高度
const vanPickerToolbarHeight = 44.0;

// 标题字体大小
const vanPickerTitleFontSize =
    vanFontSizeLg; // 示例值，请根据 --van-font-size-lg 的实际值调整

// 标题行高
const vanPickerTitleLineHeight =
    vanLineHeightMd; // 示例值，请根据 --van-line-height-md 的实际值调整

// 操作按钮内边距
const vanPickerActionPadding = EdgeInsets.symmetric(
  horizontal: 0,
  vertical: vanPaddingMd,
); // 示例值，请根据 --van-padding-md 的实际值调整

// 操作按钮字体大小
const vanPickerActionFontSize =
    vanFontSizeMd; // 示例值，请根据 --van-font-size-md 的实际值调整

// 确认操作按钮颜色
const vanPickerConfirmActionColor =
    vanPrimaryColor; // 示例颜色，请根据 --van-primary-color 的实际值调整

// 取消操作按钮颜色
const Color vanPickerCancelActionColor =
    vanTextColor2; // 示例颜色，请根据 --van-text-color-2 的实际值调整

// 选项字体大小
const vanPickerOptionFontSize =
    vanFontSizeLg; // 示例值，请根据 --van-font-size-lg 的实际值调整

// 选项内边距
const vanPickerOptionPadding = EdgeInsets.symmetric(
  horizontal: 0,
  vertical: vanPaddingBase,
); // 示例值，请根据 --van-padding-base 的实际值调整

// 选项文本颜色
const vanPickerOptionTextColor =
    vanTextColor; // 示例颜色，请根据 --van-text-color 的实际值调整

// 禁用选项的不透明度
const vanPickerOptionDisabledOpacity = 0.3;

// 加载图标颜色
const vanPickerLoadingIconColor = vanTextColor;

// 加载遮罩颜色
const vanPickerLoadingMaskColor = Color.fromRGBO(255, 255, 255, 0.9);

// 遮罩颜色（渐变色）
// 注意：Dart 中没有直接的 CSS 渐变色表示方式，通常需要使用 BoxDecoration 或 ShaderMask 来实现
// 这里提供一个示例，实际使用时需要根据需求调整
const vanPickerMaskColors = [
  Color.fromRGBO(255, 255, 255, 0.9),
  Color.fromRGBO(255, 255, 255, 0.4),
  Color.fromRGBO(255, 255, 255, 0.9),
  Color.fromRGBO(255, 255, 255, 0.4),
];
