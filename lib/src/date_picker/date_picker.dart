import 'package:flutter/material.dart';
import 'package:vant/src/date_picker/config.dart';
import 'package:vant/src/index.dart';

enum ColumnsType { year, month, day }

typedef PickerOptionFilter = Function;
typedef PickerOptionFormatter = Function;
// typedef VanDatePickerConfirm = Function(List<>)

/// 时间选择器选项配置类
class VanDatePickerOptions {
  /// 列类型（年、月、日），默认 ['year', 'month', 'day']
  final List<ColumnsType> columnsType;

  /// 可选的最小日期（精确到日），默认十年前
  final DateTime? minDate;

  /// 可选的最大日期（精确到日），默认十年后
  final DateTime? maxDate;

  /// 顶部栏标题，默认空字符串
  final String? title;

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
  final double optionHeight;

  /// 可见的选项个数，默认 6
  final int visibleOptionNum;

  /// 快速滑动时惯性滚动的时长（ms），默认 1000
  final int swipeDuration;

  final ValueChanged<String>? onConfirm;
  final VoidCallback? onCancel;
  final ValueChanged<String>? onChange;

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
    this.title,
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
    this.onConfirm,
    this.onCancel,
    this.onChange,
  });

  /// 默认配置
  static const VanDatePickerOptions defaultOptions = VanDatePickerOptions();

  /// 创建一个新的实例，同时允许覆盖部分属性
  VanDatePickerOptions copyWith({
    List<ColumnsType>? columnsType,
    DateTime? minDate,
    DateTime? maxDate,
    String? title,
    String? confirmButtonText,
    String? cancelButtonText,
    bool? showToolbar,
    bool? loading,
    bool? readonly,
    PickerOptionFilter? filter,
    PickerOptionFormatter? formatter,
    double? optionHeight,
    int? visibleOptionNum,
    int? swipeDuration,
    ValueChanged<String>? onConfirm,
    VoidCallback? onCancel,
    ValueChanged<String>? onChange,
    Widget? toolbarWidget,
    Widget? titleWidget,
    Widget? confirmWidget,
    Widget? cancelWidget,
    Widget? columnsTopWidget,
    Widget? columnsBottomWidget,
  }) {
    return VanDatePickerOptions(
      columnsType: columnsType ?? this.columnsType,
      minDate: minDate ?? this.minDate,
      maxDate: maxDate ?? this.maxDate,
      title: title ?? this.title,
      confirmButtonText: confirmButtonText ?? this.confirmButtonText,
      cancelButtonText: cancelButtonText ?? this.cancelButtonText,
      showToolbar: showToolbar ?? this.showToolbar,
      loading: loading ?? this.loading,
      readonly: readonly ?? this.readonly,
      filter: filter ?? this.filter,
      formatter: formatter ?? this.formatter,
      optionHeight: optionHeight ?? this.optionHeight,
      visibleOptionNum: visibleOptionNum ?? this.visibleOptionNum,
      swipeDuration: swipeDuration ?? this.swipeDuration,
      onConfirm: onConfirm ?? this.onConfirm,
      onCancel: onCancel ?? this.onCancel,
      onChange: onChange ?? this.onChange,
      toolbarWidget: toolbarWidget ?? this.toolbarWidget,
      titleWidget: titleWidget ?? this.titleWidget,
      confirmWidget: confirmWidget ?? this.confirmWidget,
      cancelWidget: cancelWidget ?? this.cancelWidget,
      columnsTopWidget: columnsTopWidget ?? this.columnsTopWidget,
      columnsBottomWidget: columnsBottomWidget ?? this.columnsBottomWidget,
    );
  }
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
  late FixedExtentScrollController _yearScrollController;
  late FixedExtentScrollController _monthScrollController;
  late FixedExtentScrollController _dayScrollController;
  DateTime now = DateTime.now();

  List<int> year = [];
  List<int> month = List.generate(12, (index) => index + 1);
  int currentYear = 2025;
  int currentMonth = 0;
  int currentDay = 0;

  @override
  void initState() {
    super.initState();
    int startLength = 10;
    int endLength = 10;
    if (widget.options.minDate != null) {
      startLength = now.year - widget.options.minDate!.year;
    }
    if (widget.options.maxDate != null) {
      endLength = widget.options.minDate!.year - now.year;
    }
    int startYear = now.year - startLength;
    year = List.generate(
      startLength + endLength + 1,
      (index) => startYear + index,
    );

    currentYear = year.indexOf(now.year);
    _yearScrollController = FixedExtentScrollController(
      initialItem: currentYear,
    );
    _yearScrollController.addListener(() {
      currentYear = year.indexOf(_yearScrollController.selectedItem);
      setState(() {});
    });

    currentMonth = month.indexOf(now.month);
    _monthScrollController = FixedExtentScrollController(
      initialItem: currentMonth,
    );
    _monthScrollController.addListener(() {
      currentMonth = month.indexOf(_monthScrollController.selectedItem);
      setState(() {});
    });

    currentDay = day.indexOf(now.day);
    _dayScrollController = FixedExtentScrollController(
      initialItem: currentDay,
    );
    _dayScrollController.addListener(() {
      currentDay = day.indexOf(_dayScrollController.selectedItem);
      setState(() {});
    });
  }

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
      case 2: // 二月
        if (isLeapYear(currentYear)) {
          return List.generate(29, (index) => index + 1); // 1到29
        } else {
          return List.generate(28, (index) => index + 1); // 1到28
        }
      case 4: // 四月
      case 6: // 六月
      case 9: // 九月
      case 11: // 十一月
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
            onPressed: () {
              widget.options.onCancel?.call();
            },
            child: Text(
              widget.options.cancelButtonText,
              style: const TextStyle(color: vanPickerCancelActionColor),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                "${widget.options.title ?? ''}",
                style: const TextStyle(fontSize: vanPickerTitleFontSize),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              List<int> index = [
                _yearScrollController.selectedItem,
                _monthScrollController.selectedItem,
                _dayScrollController.selectedItem,
              ];
              List<int> value = [
                year[_yearScrollController.selectedItem],
                month[_monthScrollController.selectedItem],
                day[_dayScrollController.selectedItem],
              ];
              widget.options.onConfirm?.call(value.join("-"));
            },
            child: Text(
              widget.options.confirmButtonText,
              style: const TextStyle(color: vanPickerConfirmActionColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget createListWheel(List<int> value, int selectedIndex,
      FixedExtentScrollController controller) {
    return Expanded(
      child: ListWheelScrollView(
        itemExtent: widget.options.optionHeight, // 每项高度，和 optionHeight 对应
        useMagnifier: true,
        controller: controller,
        physics: const FixedExtentScrollPhysics(),
        children: value.map((key) {
          return Center(
            child: Text(
              "$key",
              style: const TextStyle(
                fontSize: vanPickerOptionFontSize,
                color: vanPickerOptionTextColor,
              ),
            ),
          );
        }).toList(),
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
            height:
                widget.options.visibleOptionNum * widget.options.optionHeight,
            child: Stack(
              children: [
                Row(
                  children: widget.options.columnsType.map((type) {
                    if (type == ColumnsType.year) {
                      return createListWheel(
                        year,
                        currentYear,
                        _yearScrollController,
                      );
                    } else if (type == ColumnsType.month) {
                      return createListWheel(
                        month,
                        currentMonth,
                        _monthScrollController,
                      );
                    } else if (type == ColumnsType.day) {
                      return createListWheel(
                        day,
                        currentDay,
                        _dayScrollController,
                      );
                    } else {
                      throw UnimplementedError();
                    }
                  }).toList(),
                ),
                IgnorePointer(
                  // 关键：让 Container 不拦截手势
                  child: Center(
                    child: Container(
                      height: widget.options.optionHeight,
                      decoration: const BoxDecoration(
                        border: Border.symmetric(
                          horizontal: BorderSide(
                            width: 1,
                            color: Color(0xffd3cdd4),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

showVanDatePicker(
  BuildContext context, {
  VanDatePickerOptions? options = VanDatePickerOptions.defaultOptions,
}) {
  var newOptions = options!.copyWith(
    onCancel: () {
      options.onCancel?.call();
      Navigator.of(context).pop();
    },
    onChange: (value) {
      print(value);
      options.onChange?.call(value);
      Navigator.of(context).pop();
    },
    onConfirm: (value) {
      options.onConfirm?.call(value);
      Navigator.of(context).pop();
    },
  );

  showModalBottomSheet(
    context: context,
    builder: (context) {
      return VanDatePicker(options: newOptions);
    },
  );
}
