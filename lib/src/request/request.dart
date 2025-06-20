import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  List<T> items = [];
  VantRequestQuery<T>? onQuery;
  int page = 1;
  String? error;
  Completer<VantRequestStatus>? completer;
  bool isLoading = false;
  bool isLoadingMore = false;
  bool isEmpty = false;
  bool isError = false;
  // EasyRefreshController? _easyRefreshController;

  VanRequestProvider() {
    // _easyRefreshController = EasyRefreshController(
    //   controlFinishLoad: true,
    //   controlFinishRefresh: true,
    // );
  }

  void add(T item) {
    items.add(item);
    notifyListeners();
  }

  void insert(int index, T item) {
    items.insert(index, item);
    notifyListeners();
  }

  void removeAt(int index) {
    items.removeAt(index);
    notifyListeners();
  }

  void remove(T item) {
    items.remove(item);
    notifyListeners();
  }

  /// 下拉刷新
  Future<VantRequestStatus> refresh() async {
    completer = Completer<VantRequestStatus>();
    isLoading = true;
    if (onQuery == null) {
      completer!.complete(VantRequestStatus.error);
    } else {
      this.page = 1;
      this.onQuery!(this.page);
    }
    return completer!.future;
  }

  Future<VantRequestStatus?> loadMore() async {
    if (isLoadingMore) return null;
    if (onQuery == null) return VantRequestStatus.loadMoreError;
    isLoading = true;
    this.page++;
    isLoadingMore = true;
    notifyListeners();
    completer = Completer<VantRequestStatus>();
    this.onQuery!(this.page);
    return completer!.future;
  }

  void complete({List<T>? data, int? totalRow, String? error}) {
    isLoading = false;
    isLoadingMore = false;
    if (error != null) {
      this.error = error;
      // if (easyRefreshStatus == 2 && completer != null) {
      //   completer!.complete(IndicatorResult.fail);
      // } else if (easyRefreshStatus == 0) {
      //   status = VantRequestStatus.error;
      //   notifyListeners();
      // }
      if (this.items.isEmpty) {
        status = VantRequestStatus.error;
      } else {
        status = VantRequestStatus.loadMoreError;
      }
      this.page--;
      completer!.completeError(status);
      return;
    }
    if (data == null || data.isEmpty) {
      if (this.items.isEmpty) {
        status = VantRequestStatus.empty;
      } else {
        status = VantRequestStatus.nomore;
      }
      this.page--;
      completer!.complete(status);
      notifyListeners();
      return;
    }
    if (page == 1) {
      this.items = data;
    } else {
      this.items.addAll(data);
    }
    if (totalRow != null && this.items.length >= totalRow) {
      status = VantRequestStatus.nomore;
    } else {
      status = VantRequestStatus.complete;
    }
    completer!.complete(status);
    // status = VantRequestStatus.complete;
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
    BuildContext context, List<T> items);
typedef VantRequestQuery<T> = void Function(int page);

class VanRequest<T> extends StatefulWidget {
  const VanRequest({
    super.key,
    required this.provider,
    this.itemBuilder,
    this.builder,
    this.header,
    this.footer,
    // this.refreshFooter,
    // this.refreshHeader,
    this.padding,
    this.enablePullDown = true,
    this.enablePullUp = true,
    this.loading,
    this.empty,
    this.error,
    this.nomore,
    this.loadingMore,
    this.loadMoreError,
  }) : assert(itemBuilder != null || builder != null,
            "itemBuilder or builder is required");

  final VantRequestItemBuilder<T>? itemBuilder;
  final VanRequestProvider<T> provider;
  // final Header? refreshHeader;
  // final Footer? refreshFooter;
  final Widget Function(BuildContext context)? header;
  final Widget Function(BuildContext context)? footer;
  final VantRequestBuilder<T>? builder;
  final EdgeInsets? padding;
  final bool enablePullDown;
  final bool enablePullUp;

  final Widget? loading;
  final Widget? empty;
  final Widget Function(String? errorMessage)? error;
  final Widget? nomore;
  final Widget? loadingMore;
  final Widget Function(BuildContext context, String errorMessage)?
      loadMoreError;

  @override
  State<VanRequest<T>> createState() => _VanRequestState<T>();
}

class _VanRequestState<T> extends State<VanRequest<T>> {
  double screenHeight = 0.0;

  @override
  void initState() {
    super.initState();
    widget.provider.refresh();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    screenHeight = MediaQuery.of(context).size.height;
  }

  @override
  void didUpdateWidget(covariant VanRequest<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    widget.provider.refresh();
  }

  bool isSliver(Widget w) {
    if (w is RenderObjectWidget) {
      final name = w.runtimeType.toString();
      if (name.startsWith('Sliver')) {
        return true;
      }
    }
    return false;
  }

// 通用工具方法
  Widget wrapInSliver(Widget? widget, Widget fallback) {
    if (widget == null) return SliverToBoxAdapter(child: fallback);
    return isSliver(widget) ? widget : SliverToBoxAdapter(child: widget);
  }

  Widget wrapBuilderInSliver(Widget? Function()? builder, Widget fallback) {
    final built = builder?.call();
    if (built == null) return SliverToBoxAdapter(child: fallback);
    return isSliver(built) ? built : SliverToBoxAdapter(child: built);
  }

  // Header、Footer、Builder 内容
  Widget get _header => wrapInSliver(
        widget.header?.call(context),
        const SizedBox.shrink(),
      );

  Widget get _footer => wrapInSliver(
        widget.footer?.call(context),
        const SizedBox.shrink(),
      );

  Widget get _child => wrapInSliver(
        widget.builder?.call(context, widget.provider.items),
        const SizedBox.shrink(),
      );

  // 加载中
  Widget get _loading => wrapInSliver(
        widget.loading,
        SizedBox(
          height: screenHeight,
          child: const Center(
            child: CupertinoActivityIndicator(
              radius: 15,
              animating: true,
            ),
          ),
        ),
      );

  // 空数据
  Widget get _empty => wrapInSliver(
        widget.empty,
        SizedBox(
          height: screenHeight,
          child: VanEmpty(
            description: "暂无更多数据",
            type: VantEmptyType.normal,
            bottom: SizedBox(
              width: 100,
              height: 40,
              child: VanButton(
                text: "重试",
                type: VanType.primary,
                onPressed: () => widget.provider.refresh(),
              ),
            ),
          ),
        ),
      );

  // 错误
  Widget get _error => wrapInSliver(
      widget.error?.call(widget.provider.error),
      SizedBox(
        height: screenHeight,
        child: Center(
          child: VanEmpty(
            description: widget.provider.error,
            type: VantEmptyType.error,
            bottom: SizedBox(
              width: 100,
              height: 40,
              child: VanButton(
                text: "重试",
                type: VanType.primary,
                onPressed: () => widget.provider.refresh(),
              ),
            ),
          ),
        ),
      ));

  // 加载更多状态：无更多、加载中、加载失败
  Widget get _nomore => wrapInSliver(
      widget.nomore,
      SizedBox(
        height: screenHeight,
        child: const Center(
          child: SizedBox(
            height: 50,
            child: Text("暂无更多数据"),
          ),
        ),
      ));

  Widget get _loadingMore => wrapInSliver(
        widget.loadingMore,
        const SizedBox(
          height: 50,
          child: VanSpace(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(),
              ),
              Text("数据加载中"),
            ],
          ),
        ),
      );

  Widget get _loadMoreError => wrapBuilderInSliver(
        () => widget.loadMoreError?.call(context, widget.provider.error ?? ''),
        SizedBox(
          height: 50,
          child: Center(
            child: Text(widget.provider.error ?? "加载发生异常"),
          ),
        ),
      );

  // 加载更多选择器
  Widget _pullUp() {
    if (widget.provider.isLoadingMore) {
      return _loadingMore;
    } else if (widget.provider.status == VantRequestStatus.loadMoreError) {
      return _loadMoreError;
    } else if (widget.provider.status == VantRequestStatus.nomore) {
      return _nomore;
    } else {
      return const SizedBox.shrink();
    }
    // switch (status) {
    //   case VantRequestStatus.nomore:
    //     return _nomore;
    //   case VantRequestStatus.loadMoreError:
    //     return _loadMoreError;
    //   default:
    //     return _loadingMore;
    // }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.provider,
      child: RefreshIndicator(
        onRefresh: widget.provider.refresh,
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification notification) {
            final currentScroll = notification.metrics.pixels;
            final maxScroll = notification.metrics.maxScrollExtent;

            if (currentScroll + 200 >= maxScroll) {
              widget.provider.loadMore();
            }
            return false;
          },
          child: CustomScrollView(
            slivers: [
              if (widget.header != null) _header,
              Selector<VanRequestProvider<T>, VantRequestStatus>(
                selector: (context, provider) => provider.status,
                builder: (context, status, child) {
                  switch (status) {
                    case VantRequestStatus.loading:
                      return _loading;
                    case VantRequestStatus.empty:
                      return _empty;
                    case VantRequestStatus.error:
                      return _error;
                    default:
                      return const SliverToBoxAdapter(
                        child: SizedBox.shrink(),
                      );
                  }
                },
              ),
              Selector<VanRequestProvider<T>, List<T>>(
                selector: (context, provider) => provider.items,
                builder: (context, items, child) {
                  if (widget.builder != null) {
                    return _child;
                  } else {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return widget.itemBuilder!(
                            context,
                            items[index],
                            index,
                          );
                        },
                        childCount: items.length,
                      ),
                    );
                  }
                },
              ),
              if (widget.footer != null) _footer,
              Selector<VanRequestProvider<T>, bool>(
                selector: (context, provider) => provider.isLoadingMore,
                builder: (context, isLoadingMore, child) {
                  if (widget.enablePullUp && isLoadingMore) {
                    return _pullUp();
                  } else {
                    return const SliverToBoxAdapter(
                      child: SizedBox.shrink(),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
    // return ChangeNotifierProvider.value(
    //   value: widget.provider,
    //   child: Selector<VanRequestProvider<T>, (List<T>, VantRequestStatus, int)>(
    //     selector: (context, provider) => (
    //       provider.items,
    //       provider.status,
    //       provider.items.length,
    //     ),
    //     shouldRebuild: (previous, next) =>
    //         previous.$1 != next.$1 ||
    //         previous.$2 != next.$2 ||
    //         previous.$3 != next.$3,
    //     builder: (context, value, child) {

    //       // switch (value.$2) {
    //       //   case VantRequestStatus.:
    //       //     return ;
    //       //   case VantRequestStatus.:
    //       //     return ;
    //       //   case VantRequestStatus.:
    //       //   default:

    //       //   // return NotificationListener<ScrollNotification>(
    //       //   //   onNotification: (ScrollNotification notification) {
    //       //   //     // 当前滚动位置
    //       //   //     final currentScroll = notification.metrics.pixels;
    //       //   //     // 最大可滚动距离
    //       //   //     final maxScroll = notification.metrics.maxScrollExtent;

    //       //   //     if (currentScroll + 200 >= maxScroll) {
    //       //   //       // 即将到底底部
    //       //   //       widget.provider.loadMore();
    //       //   //     }
    //       //   //     return false; // false 表示继续向上传递通知
    //       //   //   },
    //       //   //   child: widget.builder != null
    //       //   //       ? widget.builder!(context, value.$1)
    //       //   //       : ListView.builder(
    //       //   //           padding: widget.padding,
    //       //   //           itemCount: trueLength,
    //       //   //           itemBuilder: (context, index) {
    //       //   //             var nowIndex = index;
    //       //   //             if (widget.header != null) {
    //       //   //               if (index == 0) {
    //       //   //                 return widget.header!(context);
    //       //   //               } else {
    //       //   //                 nowIndex = nowIndex - 1;
    //       //   //               }
    //       //   //             }
    //       //   //             if (widget.footer != null &&
    //       //   //                 index == trueLength - 1) {
    //       //   //               return widget.footer!(context);
    //       //   //             }
    //       //   //             if (widget.enablePullUp && index == trueLength - 1) {
    //       //   //               if (value.$2 == VantRequestStatus.nomore) {
    //       //   //                 return _nomore;
    //       //   //               } else if (value.$2 ==
    //       //   //                   VantRequestStatus.loadMoreError) {
    //       //   //                 return _loadMoreError;
    //       //   //               } else {
    //       //   //                 return _loadingMore;
    //       //   //               }
    //       //   //             }
    //       //   //             return widget.itemBuilder!(
    //       //   //               context,
    //       //   //               value.$1[nowIndex],
    //       //   //               nowIndex,
    //       //   //             );
    //       //   //           },
    //       //   //         ),
    //       //   // );

    //       //   // if (widget.builder != null) {
    //       //   //   return widget.builder!(context, value.$1);
    //       //   // } else {
    //       //   //   return ListView.builder(
    //       //   //     padding: widget.padding,
    //       //   //     itemCount: trueLength,
    //       //   //     itemBuilder: (context, index) {
    //       //   //       var nowIndex = index;
    //       //   //       if (widget.header != null) {
    //       //   //         if (index == 0) {
    //       //   //           return widget.header!(context);
    //       //   //         } else {
    //       //   //           nowIndex = nowIndex - 1;
    //       //   //         }
    //       //   //       }
    //       //   //       if (widget.footer != null && index == trueLength - 1) {
    //       //   //         return widget.footer!(context);
    //       //   //       }
    //       //   //       if (widget.enablePullUp && index == trueLength - 1) {
    //       //   //         if (value.$2 == VantRequestStatus.nomore) {
    //       //   //           return Text("暂无更多数据");
    //       //   //         } else if (value.$2 == VantRequestStatus.loadMoreError) {
    //       //   //           return Text(widget.provider.error ?? "请求发生异常");
    //       //   //         } else {
    //       //   //           return Text("数据加载中...");
    //       //   //         }
    //       //   //       }
    //       //   //       return widget.itemBuilder!(
    //       //   //         context,
    //       //   //         value.$1[nowIndex],
    //       //   //         nowIndex,
    //       //   //       );
    //       //   //     },
    //       //   //   );
    //       //   // }

    //       //   // return EasyRefresh(
    //       //   //   controller: widget.provider._easyRefreshController,
    //       //   //   onRefresh: () {
    //       //   //     widget.provider.easyRefreshStatus = 1;
    //       //   //     return widget.provider.refresh();
    //       //   //   },
    //       //   //   onLoad: () {
    //       //   //     widget.provider.easyRefreshStatus = 2;
    //       //   //     return widget.provider.loadMore();
    //       //   //   },
    //       //   //   header: widget.refreshHeader,
    //       //   //   footer: widget.refreshFooter,
    //       //   //   child: widget.builder?.call(context, value.$1) ??
    //       //   //       ListView.builder(
    //       //   //         padding: widget.padding,
    //       //   //         itemCount: trueLength,
    //       //   //         itemBuilder: (context, index) {
    //       //   //           var nowIndex = index;
    //       //   //           if (widget.header != null && index == 0) {
    //       //   //             if (index == 0) {
    //       //   //               return widget.header!(context);
    //       //   //             } else {
    //       //   //               nowIndex = nowIndex - 1;
    //       //   //             }
    //       //   //           }
    //       //   //           if (widget.footer != null && index == trueLength - 1) {
    //       //   //             return widget.footer!(context);
    //       //   //           }
    //       //   //           return widget.itemBuilder!(
    //       //   //             context,
    //       //   //             value.$1[nowIndex],
    //       //   //             nowIndex,
    //       //   //           );
    //       //   //         },
    //       //   //       ),
    //       //   // );
    //       // }
    //     },
    //   ),
    // );
  }
}
