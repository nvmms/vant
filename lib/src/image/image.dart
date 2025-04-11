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
  final Widget? placeholder;

  /// 加载失败时显示的组件
  final Widget? errorWidget;

  const VantImage({
    super.key,
    required this.src,
    this.width,
    this.height,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Image(
      image: _getImageProvider(),
      width: width,
      height: height,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return placeholder ?? Center(child: CircularProgressIndicator());
      },
      errorBuilder: (context, error, stackTrace) {
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
