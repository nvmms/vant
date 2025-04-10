import 'package:flutter/material.dart';

/// Vant风格的Empty组件
class VantEmpty extends StatelessWidget {
  /// 图片地址或类型
  /// 1. 预设类型：error、network、search
  /// 2. 网络图片：以http开头的URL
  /// 3. 资源图片：assets路径
  final String? image;

  /// 图片大小
  final double imageSize;

  /// 自定义图片
  final Widget? imageWidget;

  /// 描述文字
  final String? description;

  /// 自定义描述内容
  final Widget? descriptionWidget;

  /// 底部内容
  final Widget? bottom;

  const VantEmpty({
    super.key,
    this.image,
    this.imageSize = 120.0,
    this.imageWidget,
    this.description,
    this.descriptionWidget,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 图片
          _buildImage(),
          const SizedBox(height: 16),
          // 描述文字
          _buildDescription(),
          // 底部内容
          if (bottom != null) ...[
            const SizedBox(height: 16),
            bottom!,
          ],
        ],
      ),
    );
  }

  // 构建图片
  Widget _buildImage() {
    if (imageWidget != null) {
      return imageWidget!;
    }

    // 默认图片
    return SizedBox(
      width: imageSize,
      height: imageSize,
      child: _getImageByType(),
    );
  }

  // 根据类型获取图片
  Widget _getImageByType() {
    if (image == null) {
      // 默认图标
      return _buildDefaultImage(
        Icons.inbox_outlined,
        Colors.grey.shade300,
      );
    }

    // 处理预设类型
    switch (image) {
      case 'error':
        return _buildDefaultImage(
          Icons.error_outline,
          Colors.red.shade300,
        );
      case 'network':
        return _buildDefaultImage(
          Icons.wifi_off_outlined,
          Colors.grey.shade500,
        );
      case 'search':
        return _buildDefaultImage(
          Icons.search,
          Colors.grey.shade500,
        );
    }

    // 处理图片地址
    if (image!.startsWith('http')) {
      // 网络图片
      return Image.network(
        image!,
        fit: BoxFit.contain,
        width: imageSize,
        height: imageSize,
        errorBuilder: (context, error, stackTrace) {
          return _buildDefaultImage(
            Icons.broken_image_outlined,
            Colors.grey.shade400,
          );
        },
      );
    } else {
      // 资源图片
      return Image.asset(
        image!,
        fit: BoxFit.contain,
        width: imageSize,
        height: imageSize,
        errorBuilder: (context, error, stackTrace) {
          return _buildDefaultImage(
            Icons.broken_image_outlined,
            Colors.grey.shade400,
          );
        },
      );
    }
  }

  // 构建默认图片
  Widget _buildDefaultImage(IconData icon, Color color) {
    return Icon(
      icon,
      size: imageSize * 0.8,
      color: color,
    );
  }

  // 构建描述文字
  Widget _buildDescription() {
    if (descriptionWidget != null) {
      return descriptionWidget!;
    }

    if (description != null) {
      return Text(
        description!,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.black54,
        ),
        textAlign: TextAlign.center,
      );
    }

    return const Text(
      '暂无数据',
      style: TextStyle(
        fontSize: 12,
        color: Colors.black54,
      ),
      textAlign: TextAlign.center,
    );
  }
}
