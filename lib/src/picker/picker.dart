import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vant/src/picker/config.dart';
import 'package:vant/vant.dart';

class VanPickerOptions {
  // final List<List<VanPickerColumn>> columns;

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

  // /// 选项过滤函数（type: 列类型，options: 可选选项列表）
  // final PickerOptionFilter? filter;

  // /// 选项格式化函数（type: 列类型，option: 当前选项）
  // final PickerOptionFormatter? formatter;

  /// 选项高度（支持 px/vw/vh/rem 单位），默认 44
  final double optionHeight;

  /// 可见的选项个数，默认 6
  final int visibleOptionNum;

  /// 快速滑动时惯性滚动的时长（ms），默认 1000
  final int swipeDuration;

  final ValueChanged<List<int>>? onConfirm;
  final VoidCallback? onCancel;
  final ValueChanged<List<int>>? onChange;

  final Widget? toolbarWidget;
  final Widget? titleWidget;
  final Widget? confirmWidget;
  final Widget? cancelWidget;
  final Widget? columnsTopWidget;
  final Widget? columnsBottomWidget;

  const VanPickerOptions({
    // required this.columns,
    this.title,
    this.confirmButtonText = '确认',
    this.cancelButtonText = '取消',
    this.showToolbar = true,
    this.loading = false,
    this.readonly = false,
    // this.filter,
    // this.formatter,
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

  /// 创建一个新的实例，同时允许覆盖部分属性
  VanPickerOptions copyWith({
    List<List<VanPickerColumn>>? columns,
    String? title,
    String? confirmButtonText,
    String? cancelButtonText,
    bool? showToolbar,
    bool? loading,
    bool? readonly,
    // PickerOptionFilter? filter,
    // PickerOptionFormatter? formatter,
    double? optionHeight,
    int? visibleOptionNum,
    int? swipeDuration,
    ValueChanged<List<int>>? onConfirm,
    VoidCallback? onCancel,
    ValueChanged<List<int>>? onChange,
    Widget? toolbarWidget,
    Widget? titleWidget,
    Widget? confirmWidget,
    Widget? cancelWidget,
    Widget? columnsTopWidget,
    Widget? columnsBottomWidget,
  }) {
    return VanPickerOptions(
      // columns: columns ?? this.columns,
      title: title ?? this.title,
      confirmButtonText: confirmButtonText ?? this.confirmButtonText,
      cancelButtonText: cancelButtonText ?? this.cancelButtonText,
      showToolbar: showToolbar ?? this.showToolbar,
      loading: loading ?? this.loading,
      readonly: readonly ?? this.readonly,
      // filter: filter ?? this.filter,
      // formatter: formatter ?? this.formatter,
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

class VanPickerColumn {
  final String text;
  final String value;
  final bool disabled;
  final List<VanPickerColumn>? children;

  VanPickerColumn({
    required this.text,
    required this.value,
    this.disabled = false,
    this.children,
  });
}

class VanPicker extends StatefulWidget {
  final VanPickerOptions options;
  final List<Widget> Function(
      BuildContext context, int columnIndex, List<int> selectedItem) itemBuild;
  final int columnCount;

  const VanPicker({
    super.key,
    required this.columnCount,
    required this.itemBuild,
    required this.options,
  });

  @override
  State<StatefulWidget> createState() => _VanPickerState();
}

class _VanPickerState extends State<VanPicker> {
  late List<int> currentSelectedItem;

  @override
  void initState() {
    super.initState();
    currentSelectedItem = List.filled(widget.columnCount, 0);
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
              widget.options.onConfirm?.call(currentSelectedItem);
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

  @override
  Widget build(BuildContext context) {
    return VanSpace(
      direction: Axis.vertical,
      children: [
        if (widget.options.showToolbar) _toolbarWidget,
        Container(
          height: widget.options.visibleOptionNum * widget.options.optionHeight,
          child: Stack(
            children: [
              Row(
                children: List.generate(widget.columnCount, (columnIndex) {
                  return Expanded(
                    child: CupertinoPicker(
                      selectionOverlay: null,
                      itemExtent: widget.options.optionHeight,
                      onSelectedItemChanged: (int index) {
                        currentSelectedItem[columnIndex] = index;
                        setState(() {});
                      },
                      children: widget
                          .itemBuild(
                            context,
                            columnIndex,
                            currentSelectedItem,
                          )
                          .map((w) => Center(child: w))
                          .toList(),
                    ),
                  );
                }),
              ),
              IgnorePointer(
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
    );
  }
}

showVanPicker(
  BuildContext context, {
  VanPickerOptions? options,
  required List<Widget> Function(
    BuildContext context,
    int columnIndex,
    List<int> selectedItem,
  ) itemBuild,
  required int columnCount,
}) {
  options ??= const VanPickerOptions();
  var newOptions = options.copyWith(
    onCancel: () {
      options!.onCancel?.call();
      Navigator.of(context).pop();
    },
    onChange: (value) {
      options!.onChange?.call(value);
      Navigator.of(context).pop();
    },
    onConfirm: (value) {
      options!.onConfirm?.call(value);
      Navigator.of(context).pop();
    },
  );

  showModalBottomSheet(
    context: context,
    builder: (context) {
      return VanPicker(
        options: newOptions,
        itemBuild: itemBuild,
        columnCount: columnCount,
      );
    },
  );
}
