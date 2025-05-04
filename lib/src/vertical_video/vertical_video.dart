import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:like_button/like_button.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:vant/src/vertical_video/video_cache_manager.dart';
import 'package:vant/vant.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VanVerticalVideoPlayer extends StatefulWidget {
  const VanVerticalVideoPlayer({
    super.key,
    required this.src,
    this.autoPlay = false,
  });

  final String src;
  final bool autoPlay;

  @override
  State<VanVerticalVideoPlayer> createState() => _VanVerticalVideoPlayerState();
}

class _VanVerticalVideoPlayerState extends State<VanVerticalVideoPlayer> {
  VideoPlayerController? _controller;
  late Directory _directory;
  CancelToken cancelToken = CancelToken();
  bool _isShow = false;
  String get _localFilePath {
    final uri = Uri.parse(widget.src);
    final fileExtension = uri.pathSegments.last.split('.').last;
    final fileName = '${widget.src.hashCode}.$fileExtension';
    return '${_directory.path}/$fileName';
  }

  @override
  void initState() {
    super.initState();
    getApplicationCacheDirectory().then((value) {
      _directory = value;
      _cacheVideo();
    });
  }

  Future<void> _cacheVideo() async {
    try {
      var videoCacheManager = VideoCacheManager(
        videoUrl: widget.src,
        savePath: _localFilePath,
        cancelToken: cancelToken,
      );
      videoCacheManager.addListener(() {
        _initVideoController();
      });
    } catch (e) {
      debugPrint('下载失败: $e');
    }
  }

  Future<void> _initVideoController() async {
    if (_controller != null) return; // 避免重复初始化
    final file = File(_localFilePath);
    if (!await file.exists()) return;

    final controller = VideoPlayerController.file(file);
    controller.addListener(() {
      if (controller.value.hasError) {
        debugPrint('视频播放失败: ${controller.value.errorDescription}');
      }
    });
    await controller.initialize();
    controller.setLooping(true);
    if (_isShow) {
      controller.play();
    }
    setState(() {
      _controller = controller;
    });
  }

  @override
  void dispose() {
    if (!cancelToken.isCancelled) {
      cancelToken.cancel();
    }
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('video-${widget.src}'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction >= 1) {
          _isShow = true;
          if (_controller != null && _controller!.value.isInitialized) {
            _controller?.play();
          }
        } else {
          if (info.visibleFraction <= 0.1) {
            _controller?.pause();
          }
        }
      },
      child: _controller != null && _controller!.value.isInitialized
          ? Center(
              child: AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: VideoPlayer(_controller!),
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

class VanVerticalVideoDataExtractor<T> {
  final String Function(T) getVideoSrc;
  final String Function(T) getCoverImage;
  final String Function(T) getTitle;
  final String Function(T) getTopic;
  final String Function(T) getAuthorName;
  final String Function(T) getAvatarUrl;
  final int Function(T) getLikeCount;
  final int Function(T) getCommentCount;
  final int Function(T) getShareCount;
  final int Function(T) getFavoriteCount;
  final bool Function(T) isLike;
  final bool Function(T) isCollect;
  final bool Function(T) isFollow;

  const VanVerticalVideoDataExtractor({
    required this.getVideoSrc,
    required this.getCoverImage,
    required this.getTitle,
    required this.getTopic,
    required this.getAuthorName,
    required this.getAvatarUrl,
    required this.getLikeCount,
    required this.getCommentCount,
    required this.getShareCount,
    required this.getFavoriteCount,
    required this.isLike,
    required this.isCollect,
    required this.isFollow,
  });
}

class VanVerticalVideoItem<T> extends StatelessWidget {
  const VanVerticalVideoItem({
    super.key,
    required this.item,
    required this.index,
    required this.currentIndex,
    required this.extractor,
    required this.onTap,
  });
  final T item;
  final int index;
  final int currentIndex;
  final VanVerticalVideoDataExtractor<T> extractor;
  final Future<bool?> Function(T item, int index, int type)? onTap;

  ///
  /// 底部名称、头像、位置等信息
  /// 右侧点赞、评论、分享、收藏、转发、更多等按钮
  ///
  List<Widget> _buildVideoInfo() {
    return [
      Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black.withAlpha(0), Colors.black.withAlpha(100)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                        top: 10,
                        bottom: 5,
                      ),
                      child: Row(
                        children: [
                          InkWell(
                            child: VanImage(
                              src: extractor.getAvatarUrl(item),
                              width: 30,
                              height: 30,
                              radius: 30,
                            ),
                            onTap: () {
                              onTap?.call(item, index, 4);
                            },
                          ),
                          const SizedBox(width: 10),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 90),
                            child: Text(
                              "@${extractor.getAuthorName(item)}",
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            height: 30,
                            width: 80,
                            child: ElevatedButton(
                              onPressed: () {
                                onTap?.call(item, index, 5);
                              },
                              child:
                                  Text(extractor.isFollow(item) ? "已关注" : "关注"),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                        top: 5,
                        bottom: 5,
                      ),
                      child: Text(
                        extractor.getTitle(item),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                        top: 5,
                        bottom: 10,
                      ),
                      child: Row(
                        children: [
                          Text("02-25-10  ${currentIndex} ",
                              style: TextStyle(color: Colors.white)),
                          const SizedBox(width: 10),
                          Text("IP属地：北京",
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 60,
                child: Column(
                  children: [
                    SizedBox(
                      height: 60,
                      child: LikeButton(
                        countPostion: CountPostion.bottom,
                        isLiked: extractor.isLike(item),
                        likeCount: extractor.getLikeCount(item),
                        likeBuilder: (isLiked) => Icon(
                          isLiked ? Icons.favorite : Icons.favorite,
                          color: isLiked ? Colors.red : Colors.white,
                        ),
                        countBuilder: (count, isLiked, countText) => Text(
                          countText,
                          style: TextStyle(
                            color: isLiked ? Colors.red : Colors.white,
                          ),
                        ),
                        onTap: (isLiked) {
                          return onTap?.call(item, index, 0) ??
                              Future.value(false);
                        },
                      ),
                    ),
                    SizedBox(
                      height: 60,
                      child: LikeButton(
                        countPostion: CountPostion.bottom,
                        isLiked: false,
                        likeCount: 0,
                        animationDuration: Duration.zero,
                        likeCountAnimationDuration: Duration.zero,
                        likeBuilder: (isLiked) =>
                            const Icon(Icons.comment, color: Colors.white),
                        countBuilder: (count, isLiked, countText) => Text(
                          extractor.getCommentCount(item).toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                        onTap: (isLiked) {
                          return onTap?.call(item, index, 0) ??
                              Future.value(false);
                        },
                      ),
                    ),
                    SizedBox(
                      height: 60,
                      child: LikeButton(
                        countPostion: CountPostion.bottom,
                        isLiked: extractor.isCollect(item),
                        likeCount: extractor.getFavoriteCount(item),
                        likeBuilder: (isLiked) => Icon(
                          Icons.star,
                          color: isLiked ? Colors.amber : Colors.white,
                        ),
                        countBuilder: (count, isLiked, countText) => Text(
                          countText,
                          style: TextStyle(
                            color: isLiked ? Colors.amber : Colors.white,
                          ),
                        ),
                        onTap: (isLiked) {
                          return onTap?.call(item, index, 0) ??
                              Future.value(false);
                        },
                      ),
                    ),
                    SizedBox(
                      height: 60,
                      child: LikeButton(
                        countPostion: CountPostion.bottom,
                        isLiked: false,
                        likeCount: 0,
                        animationDuration: Duration.zero,
                        likeCountAnimationDuration: Duration.zero,
                        likeBuilder: (isLiked) =>
                            const Icon(Icons.more_horiz, color: Colors.white),
                        countBuilder: (count, isLiked, countText) => Text(
                          extractor.getShareCount(item).toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                        onTap: (isLiked) {
                          return onTap?.call(item, index, 4) ??
                              Future.value(false);
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (index == currentIndex ||
        index >= currentIndex - 1 ||
        index <= currentIndex + 1) {
      // 当前正在显示的page
      // 加载其余信息，
      return Container(
        color: Colors.black,
        child: Stack(
          children: [
            VanVerticalVideoPlayer(src: extractor.getVideoSrc(item)),
            // 视频
            ..._buildVideoInfo(),
          ],
        ),
      );
    } else if (index >= currentIndex - 2 || index <= currentIndex + 2) {
      // 当前page的前后两页，默认显示图片
      return Container(
        color: Colors.black,
        child: Stack(
          children: [
            Center(
              child: VanImage(src: extractor.getCoverImage(item)),
            ),
            // 视频
            ..._buildVideoInfo(),
          ],
        ),
      );
    } else if (index < currentIndex - 1 || index > currentIndex + 1) {
      // 当前page的前后两页以前的数据，不加载任何东西
      return const SizedBox.shrink();
    } else {
      throw UnimplementedError();
    }
  }
}

typedef VantVerticalVideoItemBuilder<T> = Widget Function(
    int index, int currentIndex, T item);

class VanVerticalVideo<T> extends StatefulWidget {
  const VanVerticalVideo({
    super.key,
    required this.data,
    required this.itemBuilder,
    this.preloadPagesCount = 3,
    this.onPageChanged,
  });

  final List<T> data;
  final int preloadPagesCount;
  final ValueChanged<int>? onPageChanged;
  final Widget Function(T item, int index, int currentIndex) itemBuilder;

  @override
  State<VanVerticalVideo<T>> createState() => _VanVerticalVideoState<T>();
}

class _VanVerticalVideoState<T> extends State<VanVerticalVideo<T>> {
  late PreloadPageController controller;
  int currentIndex = 0;
  @override
  void initState() {
    super.initState();
    controller = PreloadPageController();
  }

  void _checkAndNotifyPageChanged() {
    if (currentIndex != controller.page?.toInt()) {
      currentIndex = controller.page?.toInt() ?? currentIndex;
      widget.onPageChanged?.call(currentIndex);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo is ScrollStartNotification) {
        } else if (scrollInfo is ScrollEndNotification) {
          _checkAndNotifyPageChanged();
        } else if (scrollInfo is UserScrollNotification &&
            scrollInfo.direction == ScrollDirection.idle) {
          _checkAndNotifyPageChanged();
        }

        return false;
      },
      child: PreloadPageView.builder(
        itemCount: widget.data.length,
        scrollDirection: Axis.vertical,
        preloadPagesCount: widget.preloadPagesCount,
        controller: controller,
        itemBuilder: (context, index) => widget.itemBuilder(
          widget.data[index],
          index,
          currentIndex,
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
