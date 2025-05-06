import 'package:flutter/material.dart';
import 'package:vant/src/date_picker/config.dart';
import 'package:vant/src/index.dart';

enum ColumnsType { year, month, day }

typedef PickerOptionFilter = Function;
typedef PickerOptionFormatter = Function;

/// 时间选择器选项配置类
class VanDatePickerOptions {
  /// 列类型（年、月、日），默认 ['year', 'month', 'day']
  final List<ColumnsType> columnsType;

  /// 可选的最小日期（精确到日），默认十年前
  final DateTime? minDate;

  /// 可选的最大日期（精确到日），默认十年后
  final DateTime? maxDate;

  /// 顶部栏标题，默认空字符串
  final String title;

  /// 确认按钮文字，默认 '确认'
  final String confirmButtonText;

  /// 取消按钮文字，默认 '取消'
  final String cancelButtonText;

  /// 是否显示顶部栏，默认 true
  final bool showToolbar;

  /// 是否显示加载状态，默认 false
  final bool loading;

  /// 是否为只读状态（无法切换选项），默认 false
  final bool readonly;

  /// 选项过滤函数（type: 列类型，options: 可选选项列表）
  final PickerOptionFilter? filter;

  /// 选项格式化函数（type: 列类型，option: 当前选项）
  final PickerOptionFormatter? formatter;

  /// 选项高度（支持 px/vw/vh/rem 单位），默认 44
  final dynamic optionHeight;

  /// 可见的选项个数，默认 6
  final int visibleOptionNum;

  /// 快速滑动时惯性滚动的时长（ms），默认 1000
  final int swipeDuration;

  final Widget? toolbarWidget;
  final Widget? titleWidget;
  final Widget? confirmWidget;
  final Widget? cancelWidget;
  final Widget? columnsTopWidget;
  final Widget? columnsBottomWidget;

  const VanDatePickerOptions({
    this.columnsType = const [
      ColumnsType.year,
      ColumnsType.month,
      ColumnsType.day
    ],
    this.minDate,
    this.maxDate,
    this.title = '',
    this.confirmButtonText = '确认',
    this.cancelButtonText = '取消',
    this.showToolbar = true,
    this.loading = false,
    this.readonly = false,
    this.filter,
    this.formatter,
    this.optionHeight = 44,
    this.visibleOptionNum = 6,
    this.swipeDuration = 1000,
    this.toolbarWidget,
    this.titleWidget,
    this.confirmWidget,
    this.cancelWidget,
    this.columnsTopWidget,
    this.columnsBottomWidget,
  });

  /// 默认配置
  static const VanDatePickerOptions defaultOptions = VanDatePickerOptions();
}

class VanDatePicker extends StatefulWidget {
  final VanDatePickerOptions options;

  const VanDatePicker({
    super.key,
    this.options = VanDatePickerOptions.defaultOptions,
  });

  @override
  State<StatefulWidget> createState() => _VanDatePickerState();
}

class _VanDatePickerState extends State<VanDatePicker> {
  List<int> year = [];
  List<int> month = List.generate(12, (index) => index);
  int currentYear = 2025;
  int currentMonth = 0;

  // 判断是否为闰年
  bool isLeapYear(int year) {
    if (year % 4 != 0) {
      return false;
    } else if (year % 100 != 0) {
      return true;
    } else {
      return year % 400 == 0;
    }
  }

  List<int> get day {
    switch (currentMonth) {
      case 1: // 二月
        if (isLeapYear(currentYear)) {
          return List.generate(29, (index) => index + 1); // 1到29
        } else {
          return List.generate(28, (index) => index + 1); // 1到28
        }
      case 3: // 四月
      case 5: // 六月
      case 8: // 九月
      case 10: // 十一月
        return List.generate(30, (index) => index + 1); // 1到30
      default:
        return List.generate(31, (index) => index + 1); // 1到31
    }
  }

  Widget get _toolbarWidget {
    if (widget.options.toolbarWidget != null) {
      return widget.options.toolbarWidget!;
    }
    return SizedBox(
      height: vanPickerToolbarHeight,
      child: Row(
        children: [
          TextButton(
            onPressed: () {},
            child: Text(widget.options.cancelButtonText),
          ),
          Expanded(child: Text("${widget.options.title}")),
          TextButton(
            onPressed: () {},
            child: Text(widget.options.confirmButtonText),
          ),
        ],
      ),
    );
  }

  Widget getDelegate(List<int> value) {
    return Container(
      width: 100,
      color: Colors.amber,
      child: ListWheelScrollView(
        itemExtent: 44, // 每项高度，和 optionHeight 对应
        magnification: 1.5,
        useMagnifier: true,
        onSelectedItemChanged: (index) {
          setState(() {
            // 更新当前值
            currentYear = year[index];
          });
        },
        children: value
            .map((key) => Text("$key", style: TextStyle(color: Colors.red)))
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: VanSpace(
        direction: Axis.vertical,
        children: [
          if (widget.options.showToolbar) _toolbarWidget,
          SizedBox(
            height: 500,
            child: Row(
              children: widget.options.columnsType.map((type) {
                if (type == ColumnsType.year) {
                  return getDelegate(year);
                } else if (type == ColumnsType.month) {
                  return getDelegate(month);
                } else if (type == ColumnsType.day) {
                  return getDelegate(day);
                } else {
                  throw UnimplementedError();
                }
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}

showVanDatePicker(
  BuildContext context, {
  VanDatePickerOptions? options = VanDatePickerOptions.defaultOptions,
}) {}
