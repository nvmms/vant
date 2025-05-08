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
  nomore,
  loadMoreError,
}

class VanRequestProvider<T> extends ChangeNotifier {
  VantRequestStatus status = VantRequestStatus.loading;

  /// 1 EasyRefresh下拉刷新
  /// 2 EasyRefresh上拉加载
  int easyRefreshStatus = 0;
  List<T> data = [];
  VantRequestQuery<T>? onQuery;
  int page = 1;
  String? error;
  Completer<IndicatorResult>? completer;
  EasyRefreshController? _easyRefreshController;

  VanRequestProvider() {
    _easyRefreshController = EasyRefreshController(
      controlFinishLoad: true,
      controlFinishRefresh: true,
    );
  }

  Future<IndicatorResult> refresh() async {
    completer = Completer<IndicatorResult>();
    if (onQuery == null) {
      completer!.complete(IndicatorResult.fail);
    } else {
      this.page = 1;
      this.onQuery!(this.page);
    }
    return completer!.future;
  }

  Future<IndicatorResult> loadMore() async {
    if (onQuery == null) return IndicatorResult.fail;
    this.page++;
    completer = Completer<IndicatorResult>();
    this.onQuery!(this.page);
    return completer!.future;
  }

  void complete({List<T>? data, int? totalRow, String? error}) {
    if (error != null) {
      this.error = error;
      // if (easyRefreshStatus == 2 && completer != null) {
      //   completer!.complete(IndicatorResult.fail);
      // } else if (easyRefreshStatus == 0) {
      //   status = VantRequestStatus.error;
      //   notifyListeners();
      // }
      if (this.data.isEmpty) {
        status = VantRequestStatus.error;
      } else {
        status = VantRequestStatus.loadMoreError;
      }
      return;
    }
    // if (data == null || data.isEmpty) {
    //   if (easyRefreshStatus == 2 && completer != null) {
    //     completer!.complete(IndicatorResult.noMore);
    //   } else {
    //     status = VantRequestStatus.empty;
    //     notifyListeners();
    //   }
    //   return;
    // }
    // if (page == 1) {
    //   this.data = data;
    // } else {
    //   this.data.addAll(data);
    // }

    // if (easyRefreshStatus == 0) {
    //   if (totalRow != null && this.data.length >= totalRow) {
    //     _easyRefreshController?.finishLoad(IndicatorResult.noMore);
    //     _easyRefreshController?.finishRefresh(IndicatorResult.noMore);
    //   }
    // } else if (easyRefreshStatus == 1 && completer != null) {
    //   completer!.complete(IndicatorResult.success);
    // } else if (easyRefreshStatus == 2 && completer != null) {
    //   if (totalRow != null && this.data.length >= totalRow) {
    //     completer!.complete(IndicatorResult.noMore);
    //   } else {
    //     completer!.complete(IndicatorResult.success);
    //   }
    // }
    // easyRefreshStatus = 0;
    // status = VantRequestStatus.complete;
    notifyListeners();
  }
}

typedef VantRequestItemBuilder<T> = Widget Function(
    BuildContext context, T item, int index);
typedef VantRequestBuilder<T> = Widget Function(
    BuildContext context, List<T> item);
typedef VantRequestQuery<T> = void Function(int page);

class VanRequest<T> extends StatefulWidget {
  const VanRequest({
    super.key,
    required this.provider,
    this.itemBuilder,
    this.builder,
    this.header,
    this.footer,
    this.loading,
    this.empty,
    this.error,
    this.refreshFooter,
    this.refreshHeader,
    this.padding,
    this.enablePullDown = true,
    this.enablePullUp = true,
  }) : assert(itemBuilder != null || builder != null,
            "itemBuilder or builder is required");

  final VantRequestItemBuilder<T>? itemBuilder;
  final VanRequestProvider<T> provider;
  final Header? refreshHeader;
  final Footer? refreshFooter;
  final Widget Function(BuildContext context)? header;
  final Widget Function(BuildContext context)? footer;
  final Widget? loading;
  final Widget? empty;
  final Widget Function(String? errorMessage)? error;
  final VantRequestBuilder<T>? builder;
  final EdgeInsets? padding;
  final bool enablePullDown;
  final bool enablePullUp;

  @override
  State<VanRequest<T>> createState() => _VanRequestState<T>();
}

class _VanRequestState<T> extends State<VanRequest<T>> {
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
  void didUpdateWidget(covariant VanRequest<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.provider.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.provider,
      child: Selector<VanRequestProvider<T>, (List<T>, VantRequestStatus, int)>(
        selector: (context, provider) => (
          provider.data,
          provider.status,
          provider.data.length,
        ),
        shouldRebuild: (previous, next) =>
            previous.$1 != next.$1 ||
            previous.$2 != next.$2 ||
            previous.$3 != next.$3,
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
                  VanEmpty(
                    description: "暂无更多数据",
                    type: VantEmptyType.normal,
                    bottom: SizedBox(
                      width: 100,
                      height: 40,
                      child: VanButton(
                        text: "重试",
                        type: VanType.primary,
                        onPressed: () {
                          widget.provider.refresh();
                        },
                      ),
                    ),
                  );
            case VantRequestStatus.error:
              return widget.error?.call(widget.provider.error) ??
                  VanEmpty(
                    description: widget.provider.error,
                    type: VantEmptyType.error,
                    bottom: SizedBox(
                      width: 100,
                      height: 40,
                      child: VanButton(
                        text: "重试",
                        type: VanType.primary,
                        onPressed: () {
                          widget.provider.refresh();
                        },
                      ),
                    ),
                  );
            case VantRequestStatus.complete:
            default:
              int trueLength = value.$3;
              if (widget.header != null) {
                trueLength = trueLength + 1;
              }
              if (widget.footer != null) {
                trueLength = trueLength + 1;
              }
              if (widget.enablePullUp) {
                trueLength = trueLength + 1;
              }

              if (widget.builder != null) {
                return NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      // 这里放置 Sliver 组件
                    ];
                  },
                  body: widget.builder!(context, value.$1),
                );
              } else {
                return ListView.builder(
                  padding: widget.padding,
                  itemCount: trueLength,
                  itemBuilder: (context, index) {
                    var nowIndex = index;
                    if (widget.header != null) {
                      if (index == 0) {
                        return widget.header!(context);
                      } else {
                        nowIndex = nowIndex - 1;
                      }
                    }
                    if (widget.footer != null && index == trueLength - 1) {
                      return widget.footer!(context);
                    }
                    if (widget.enablePullUp && index == trueLength - 1) {
                      if (value.$2 == VantRequestStatus.nomore) {
                        return Text("暂无更多数据");
                      } else if (value.$2 == VantRequestStatus.loadMoreError) {
                        return Text(widget.provider.error ?? "请求发生异常");
                      } else {
                        return Text("数据加载中...");
                      }
                    }
                    return widget.itemBuilder!(
                      context,
                      value.$1[nowIndex],
                      nowIndex,
                    );
                  },
                );
              }

            // return EasyRefresh(
            //   controller: widget.provider._easyRefreshController,
            //   onRefresh: () {
            //     widget.provider.easyRefreshStatus = 1;
            //     return widget.provider.refresh();
            //   },
            //   onLoad: () {
            //     widget.provider.easyRefreshStatus = 2;
            //     return widget.provider.loadMore();
            //   },
            //   header: widget.refreshHeader,
            //   footer: widget.refreshFooter,
            //   child: widget.builder?.call(context, value.$1) ??
            //       ListView.builder(
            //         padding: widget.padding,
            //         itemCount: trueLength,
            //         itemBuilder: (context, index) {
            //           var nowIndex = index;
            //           if (widget.header != null && index == 0) {
            //             if (index == 0) {
            //               return widget.header!(context);
            //             } else {
            //               nowIndex = nowIndex - 1;
            //             }
            //           }
            //           if (widget.footer != null && index == trueLength - 1) {
            //             return widget.footer!(context);
            //           }
            //           return widget.itemBuilder!(
            //             context,
            //             value.$1[nowIndex],
            //             nowIndex,
            //           );
            //         },
            //       ),
            // );
          }
        },
      ),
    );
  }
}
