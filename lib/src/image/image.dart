import 'package:flutter/material.dart';

/// Vant风格的Image组件
class VantImage extends StatelessWidget {
  /// 图片地址，可以是网络图片(http开头)或资源图片(assets路径)
  final String src;

  /// 图片宽度
  final double? width;

  /// 图片高度
  final double? height;

  /// 占位符
  final ImageProvider? placeholder;

  /// 加载失败时显示的组件
  final Widget? errorWidget;

  /// 图片适应方式
  final BoxFit fit;

  /// 圆角半径
  final double radius;

  /// 是否为圆形
  final bool round;

  /// 是否启用懒加载
  final bool lazyLoad;

  const VantImage({
    super.key,
    required this.src,
    this.width,
    this.height,
    this.placeholder,
    this.errorWidget,
    this.fit = BoxFit.cover,
    this.radius = 0.0,
    this.round = false,
    this.lazyLoad = false,
  });

  @override
  Widget build(BuildContext context) {
    final imageProvider = _getImageProvider();

    return ClipRRect(
      borderRadius:
          BorderRadius.circular(round ? (width ?? height ?? 0) / 2 : radius),
      child: lazyLoad
          ? _buildLazyLoadImage(imageProvider)
          : _buildImage(imageProvider),
    );
  }

  // 构建普通图片
  Widget _buildImage(ImageProvider imageProvider) {
    return Image(
      image: imageProvider,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return placeholder != null
            ? Image(image: placeholder!, width: width, height: height, fit: fit)
            : Center(child: CircularProgressIndicator());
      },
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ?? Icon(Icons.broken_image, size: width ?? height);
      },
    );
  }

  // 构建懒加载图片
  Widget _buildLazyLoadImage(ImageProvider imageProvider) {
    return FadeInImage(
      placeholder: placeholder ?? AssetImage('assets/placeholder.png'),
      image: imageProvider,
      width: width,
      height: height,
      fit: fit,
      imageErrorBuilder: (context, error, stackTrace) {
        return errorWidget ?? Icon(Icons.broken_image, size: width ?? height);
      },
    );
  }

  // 根据图片地址获取ImageProvider
  ImageProvider _getImageProvider() {
    if (src.startsWith('http')) {
      return NetworkImage(src);
    } else {
      return AssetImage(src);
    }
  }
}
