import 'package:flutter/material.dart';
import 'package:vant/src/dialog/config.dart';

class VanDialogOptions {
  final String? title;
  final double? width; // 默认单位为逻辑像素（与 Flutter 的尺寸单位一致）
  final String message;
  final MainAxisAlignment messageAlign; // 使用 MainAxisAlignment 来对齐内容
  final String theme; // 样式风格，可以根据需要自定义处理
  final bool showConfirmButton;
  final bool showCancelButton;
  final String confirmButtonText;
  final Color confirmButtonColor;
  final bool confirmButtonDisabled;
  final String cancelButtonText;
  final Color cancelButtonColor;
  final bool cancelButtonDisabled;
  final bool overlay;
  final String? overlayClass; // 在 Flutter 中通常通过 BoxDecoration 或其他方式自定义样式
  final TextStyle? overlayStyle; // 可以通过 BoxDecoration 的 color 和其他属性实现
  final bool closeOnClickOverlay;
  final bool allowHtml; // Flutter 中可以使用 Html 或 RichText 来渲染 HTML 内容
  final Future<bool> Function(String action)? beforeClose; // 关闭前的回调函数
  final String transition; // 动画类名，可以通过 TransitionBuilder 或其他方式实现

  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final VoidCallback? onOpen;
  final VoidCallback? onClose;
  // final VoidCallback onConfirm;

  final Widget? child;
  final Widget? titleWidget;
  final Widget? footerWidget;

  const VanDialogOptions({
    this.title,
    this.width = vanDialogWidth, // 默认宽度
    required this.message,
    this.messageAlign = MainAxisAlignment.center,
    this.theme = 'default',
    this.showConfirmButton = true,
    this.showCancelButton = false,
    this.confirmButtonText = '确认',
    this.confirmButtonColor = vanDialogConfirmButtonTextColor,
    this.confirmButtonDisabled = false,
    this.cancelButtonText = '取消',
    this.cancelButtonColor = Colors.black,
    this.cancelButtonDisabled = false,
    this.overlay = true,
    this.overlayClass,
    this.overlayStyle,
    this.closeOnClickOverlay = false,
    this.allowHtml = false,
    this.beforeClose,
    this.transition = '',
    this.onConfirm,
    this.onCancel,
    this.onOpen,
    this.onClose,
    this.titleWidget,
    this.child,
    this.footerWidget,
  });
}

class _VanDialog extends StatelessWidget {
  final VanDialogOptions options;

  const _VanDialog({super.key, required this.options});

  void _handleAction(BuildContext context, String action) async {
    if (options.beforeClose != null) {
      bool allowClose = await options.beforeClose!(action);
      if (!allowClose) return;
    }
    Navigator.of(context).pop(action);
  }

  Widget _messageWidget(BuildContext context) {
    if (options.child != null) return options.child!;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        vanDialogMessagePadding,
        options.title != null ? vanDialogHasTitleMessagePaddingTop : 26,
        vanDialogMessagePadding,
        26,
      ),
      child: Row(
        mainAxisAlignment: options.messageAlign,
        children: [
          Expanded(
            child: options.allowHtml
                ? Text.rich(
                    TextSpan(text: options.message),
                  )
                : ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height *
                          vanDialogMessageMaxHeight,
                    ),
                    child: Text(
                      options.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: vanDialogMessageFontSize,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget get _titleWidget {
    if (options.titleWidget != null) return options.titleWidget!;
    return Padding(
      padding: const EdgeInsets.only(top: vanDialogHeaderPaddingTop),
      child: Text(
        options.title!,
        style: const TextStyle(
          fontSize: vanDialogFontSize,
          fontWeight: vanDialogHeaderFontWeight,
          // height: vanDialogHeaderLineHeight,
        ),
      ),
    );
  }

  Widget _footerWidget(BuildContext context) {
    if (options.footerWidget != null) return options.footerWidget!;
    return Row(
      children: [
        if (options.showCancelButton)
          Expanded(
            child: SizedBox(
              height: vanDialogButtonHeight,
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0),
                      bottomLeft: Radius.circular(vanDialogRadius),
                      topRight: Radius.circular(0),
                      bottomRight: Radius.circular(0),
                    ), // 圆角半径
                  ), // 内边距（可选）
                ),
                onPressed: options.cancelButtonDisabled
                    ? null
                    : () {
                        options.onCancel?.call();
                        Navigator.of(context).pop();
                        options.onClose?.call();
                      },
                child: Text(
                  options.cancelButtonText,
                  style: TextStyle(color: options.cancelButtonColor),
                ),
              ),
            ),
          ),
        if (options.showConfirmButton)
          Expanded(
            child: SizedBox(
              height: vanDialogButtonHeight,
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(0),
                      bottomLeft: options.showCancelButton
                          ? const Radius.circular(0)
                          : const Radius.circular(vanDialogRadius),
                      topRight: const Radius.circular(0),
                      bottomRight: const Radius.circular(vanDialogRadius),
                    ), // 圆角半径
                  ), // 内边距（可选）
                ),
                onPressed: options.confirmButtonDisabled
                    ? null
                    : () {
                        options.onConfirm?.call();
                        Navigator.of(context).pop();
                        options.onClose?.call();
                      },
                child: Text(
                  options.confirmButtonText,
                  style: TextStyle(color: options.confirmButtonColor),
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final dialogContent = Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          width: options.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(vanDialogRadius), // 调大圆角
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (options.title != null) _titleWidget,
              _messageWidget(context),
              _footerWidget(context),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     if (options.showCancelButton && options.showConfirmButton)
              //       Expanded(
              //         child: TextButton(
              //           onPressed: options.cancelButtonDisabled
              //               ? null
              //               : () => _handleAction(context, 'cancel'),
              //           style: TextButton.styleFrom(
              //             foregroundColor: options.cancelButtonColor,
              //           ),
              //           child: Text(options.cancelButtonText),
              //         ),
              //       ),
              //     if (options.showCancelButton && options.showConfirmButton)
              //       const SizedBox(width: 8), // 分隔符
              //     if (options.showConfirmButton && !options.showCancelButton)
              //       Expanded(
              //         child: TextButton(
              //           onPressed: options.confirmButtonDisabled
              //               ? null
              //               : () => _handleAction(context, 'confirm'),
              //           style: TextButton.styleFrom(
              //             foregroundColor: options.confirmButtonColor,
              //           ),
              //           child: Text(options.confirmButtonText),
              //         ),
              //       ),
              //     if (options.showCancelButton && !options.showConfirmButton)
              //       Expanded(
              //         child: TextButton(
              //           onPressed: options.cancelButtonDisabled
              //               ? null
              //               : () => _handleAction(context, 'cancel'),
              //           style: TextButton.styleFrom(
              //             foregroundColor: options.cancelButtonColor,
              //           ),
              //           child: Text(options.cancelButtonText),
              //         ),
              //       ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );

    return WillPopScope(
      onWillPop: () async => false, // 禁止系统返回键关闭
      child: Stack(
        children: [
          if (options.overlay)
            GestureDetector(
              onTap: options.closeOnClickOverlay
                  ? () => _handleAction(context, 'overlay')
                  : null,
              child: Container(
                color: options.overlayStyle?.color ??
                    Colors.black.withOpacity(0.5),
              ),
            ),
          dialogContent,
        ],
      ),
    );
  }
}

void showVanDialog(BuildContext context, VanDialogOptions options) {
  showDialog(
    context: context,
    builder: (context) {
      return _VanDialog(options: options);
    },
  );
}
