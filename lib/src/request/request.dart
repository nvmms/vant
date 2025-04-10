import 'dart:async';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:vant/vant.dart';

enum VantRequestStatus {
  loading,
  empty,
  error,
  complete,
}

class VantRequestProvider<T> extends ChangeNotifier {
  VantRequestStatus status = VantRequestStatus.loading;

  /// 1 EasyRefresh下拉刷新
  /// 2 EasyRefresh上拉加载
  int easyRefreshStatus = 0;
  List<T> data = [];
  VantRequestQuery<T>? onQuery;
  final int pageSize = 20;
  int page = 1;
  String? error;
  Completer<IndicatorResult>? completer;

  Future<IndicatorResult> refresh() async {
    completer = Completer<IndicatorResult>();
    if (onQuery == null) {
      completer!.complete(IndicatorResult.fail);
    } else {
      this.page = 1;
      this.onQuery!(this.page, this.pageSize);
    }
    return completer!.future;
  }

  Future<IndicatorResult> loadMore() async {
    if (onQuery == null) return IndicatorResult.fail;
    this.page++;
    completer = Completer<IndicatorResult>();
    this.onQuery!(this.page, this.pageSize);
    return completer!.future;
  }

  void complete({List<T>? data, int? totalRow, String? error}) {
    if (error != null) {
      this.error = error;
      if (easyRefreshStatus == 2 && completer != null) {
        completer!.complete(IndicatorResult.fail);
      } else if (easyRefreshStatus == 0) {
        status = VantRequestStatus.error;
        notifyListeners();
      }
      return;
    }
    if (data == null) {
      if (easyRefreshStatus == 2 && completer != null) {
        completer!.complete(IndicatorResult.noMore);
      } else {
        status = VantRequestStatus.empty;
        notifyListeners();
      }
      return;
    }
    if (page == 1) {
      this.data = data;
    } else {
      this.data.addAll(data);
    }

    if (easyRefreshStatus == 1 && completer != null) {
      completer!.complete(IndicatorResult.success);
    } else if (easyRefreshStatus == 2 && completer != null) {
      if (totalRow != null && this.data.length >= totalRow) {
        completer!.complete(IndicatorResult.noMore);
      } else {
        completer!.complete(IndicatorResult.success);
      }
    }
    easyRefreshStatus = 0;
    status = VantRequestStatus.complete;
    notifyListeners();
  }
}

typedef VantRequestItemBuilder<T> = Widget Function(
    BuildContext context, T item, int index);
typedef VantRequestBuilder<T> = Widget Function(
    BuildContext context, List<T> item);
typedef VantRequestQuery<T> = void Function(int page, int pageSize);

class VantRequest<T> extends StatefulWidget {
  const VantRequest({
    super.key,
    required this.provider,
    required this.itemBuilder,
    this.builder,
    this.header,
    this.footer,
    this.loading,
    this.empty,
    this.error,
  }) : assert(itemBuilder != null || builder != null,
            "itemBuilder or builder is required");

  final VantRequestItemBuilder<T>? itemBuilder;
  final VantRequestProvider<T> provider;
  final Header? header;
  final Footer? footer;
  final Widget? loading;
  final Widget? empty;
  final Widget Function(String? errorMessage)? error;
  final VantRequestBuilder<T>? builder;

  @override
  State<VantRequest<T>> createState() => _VantRequestState<T>();
}

class _VantRequestState<T> extends State<VantRequest<T>> {
  EasyRefreshController easyRefreshController = EasyRefreshController(
    controlFinishLoad: true,
    controlFinishRefresh: true,
  );

  @override
  void initState() {
    super.initState();
    widget.provider.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.provider,
      child: Selector<VantRequestProvider<T>, (List<T>, VantRequestStatus)>(
        selector: (context, provider) => (
          provider.data,
          provider.status,
        ),
        shouldRebuild: (previous, next) =>
            previous.$2 != next.$2 || previous.$1 != next.$1,
        builder: (context, value, child) {
          switch (value.$2) {
            case VantRequestStatus.loading:
              return widget.loading ??
                  const Center(
                    child: CupertinoActivityIndicator(
                      radius: 15, // 控制大小
                      animating: true, // 是否动画
                    ),
                  );
            case VantRequestStatus.empty:
              return widget.empty ??
                  VantEmpty(
                    description: "暂无更多数据",
                    type: VantEmptyType.normal,
                    bottom: SizedBox(
                      width: 100,
                      height: 40,
                      child: VantButton(
                        text: "重试",
                        type: VantButtonType.primary,
                        onPressed: () {
                          widget.provider.refresh();
                        },
                      ),
                    ),
                  );
            case VantRequestStatus.error:
              return widget.error?.call(widget.provider.error) ??
                  VantEmpty(
                    description: widget.provider.error,
                    type: VantEmptyType.error,
                    bottom: SizedBox(
                      width: 100,
                      height: 40,
                      child: VantButton(
                        text: "重试",
                        type: VantButtonType.primary,
                        onPressed: () {
                          widget.provider.refresh();
                        },
                      ),
                    ),
                  );
            case VantRequestStatus.complete:
              return EasyRefresh(
                onRefresh: () {
                  widget.provider.easyRefreshStatus = 1;
                  return widget.provider.refresh();
                },
                onLoad: () {
                  widget.provider.easyRefreshStatus = 2;
                  return widget.provider.loadMore();
                },
                child: widget.builder?.call(context, value.$1) ??
                    ListView.builder(
                      itemCount: value.$1.length,
                      itemBuilder: (context, index) => widget.itemBuilder!(
                        context,
                        value.$1[index],
                        index,
                      ),
                    ),
              );
          }
        },
      ),
    );
  }
}
