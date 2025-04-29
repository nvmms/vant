import 'package:flutter/material.dart';
import 'package:vant/vant.dart';

class VanActionSheetAction {
  final String name;
  final String? subname;
  final Color color;
  final IconData? icon;
  final bool loading;
  final bool disabled;
  final VoidCallback? callback;

  const VanActionSheetAction({
    required this.name,
    this.subname,
    this.icon,
    this.disabled = false,
    this.loading = false,
    this.color = const Color(0xff323233),
    this.callback,
  });
}

class _VanActionSheet extends StatelessWidget {
  final List<VanActionSheetAction> actions;
  final String? cancelText;
  final double normalHeight = 70;
  final bool? closeOnClickAction;

  const _VanActionSheet({
    required this.actions,
    this.cancelText,
    this.closeOnClickAction,
  });

  int get length => actions.length + (cancelText != null ? 1 : 0);

  double get height {
    double height = actions.fold(0.0, (value, element) {
      if (element.subname != null) {
        return value + 14 * 2 + (22.0) + 18 + 8.0;
      } else {
        return value + 14 * 2 + 22.0;
      }
    });
    if (cancelText != null) {
      height += 14 * 2 + 22.0 + 10;
    }
    return height;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.builder(
        itemCount: length,
        itemBuilder: (context, index) {
          if (cancelText != null && index == actions.length) {
            return Column(
              children: [
                Container(
                  height: 10,
                  color: const Color(0xfff7f8fa),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 16,
                    ),
                    child: SizedBox(
                      height: 22,
                      child: Center(
                        child: Text(
                          cancelText!,
                          style: const TextStyle(
                            color: Color(0xff646566),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          final action = actions[index];
          if (action.loading) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              child: Center(
                child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              ),
            );
          }
          return InkWell(
            onTap: action.disabled
                ? null
                : () {
                    action.callback?.call();
                    if (closeOnClickAction == true) {
                      Navigator.of(context).pop();
                    }
                  },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              child: VantSpace(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (action.icon != null) Icon(action.icon),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 22,
                        child: Center(
                          child: Text(
                            action.name,
                            style: TextStyle(
                              fontSize: 16,
                              color: action.disabled
                                  ? const Color(0xffc8c9cc)
                                  : action.color,
                            ),
                          ),
                        ),
                      ),
                      if (action.subname != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: SizedBox(
                            height: 18,
                            child: Text(
                              action.subname!,
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(
                                    action.disabled ? 0xffc8c9cc : 0xff969799),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _VanActionSheetHeader extends StatelessWidget {
  final bool closeable;
  final String? title;
  final String? description;
  final IconData closeIcon;

  const _VanActionSheetHeader({
    required this.closeable,
    this.title,
    this.description,
    this.closeIcon = Icons.close,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            if (closeable) const SizedBox(width: 42),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 9,
                  horizontal: 20,
                ),
                child: Column(
                  children: [
                    if (title != null)
                      Text(
                        title!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    if (description != null)
                      Text(
                        description!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xff969799),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            if (closeable)
              IconButton(
                icon: Icon(closeIcon, color: const Color(0xffc8c9cc)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
          ],
        ),
        const Divider(
          height: 1,
          thickness: 1,
          color: Color(0xffebedf0),
        ),
      ],
    );
  }
}

void showActionSheet(
  BuildContext context, {
  List<VanActionSheetAction> actions = const [],
  String? title,
  String? cancelText,
  String? description,
  bool closeable = true,
  IconData closeIcon = Icons.close,
  double duration = 0.3,
  bool round = true,
  bool overlay = true,
  bool closeOnClickAction = false,
  bool closeOnClickOverlay = true,
  bool safeAreaInsetBottom = true,
  VoidCallbackAction? beforeClose,
  Widget? child,
}) {
  Widget widget = Container();
  if (child != null) {
    widget = child;
  } else {
    widget = _VanActionSheet(
      actions: actions,
      cancelText: cancelText,
      closeOnClickAction: closeOnClickAction,
    );
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: closeOnClickOverlay,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(round ? 8 : 0),
        topRight: Radius.circular(round ? 8 : 0),
      ), // 去除圆角
    ),
    builder: (context) => Stack(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null || description != null)
              _VanActionSheetHeader(
                closeable: closeable,
                title: title,
                description: description,
                closeIcon: closeIcon,
              ),
            widget,
          ],
        ),
      ],
    ),
  );
}
