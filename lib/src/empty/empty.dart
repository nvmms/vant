import 'package:flutter/material.dart';

/// Empty状态类型
enum VantEmptyType {
  /// 默认，空状态
  normal,

  /// 错误
  error,

  /// 网络错误
  network,

  /// 搜索为空
  search,
}

/// Vant风格的Empty组件
class VanEmpty extends StatelessWidget {
  /// 空状态类型
  final VantEmptyType type;

  /// 图片地址，可以是网络图片(http开头)或资源图片(assets路径)
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

  const VanEmpty({
    super.key,
    this.type = VantEmptyType.normal,
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

    // 如果有图片地址，优先使用图片地址
    if (image != null) {
      return SizedBox(
        width: imageSize,
        height: imageSize,
        child: _buildImageFromSource(image!),
      );
    }

    // 否则使用类型对应的默认图标
    return SizedBox(
      width: imageSize,
      height: imageSize,
      child: _getImageByType(),
    );
  }

  // 根据类型获取图片
  Widget _getImageByType() {
    switch (type) {
      case VantEmptyType.error:
        return _buildDefaultImage(
          Icons.error_outline,
          Colors.red.shade300,
        );
      case VantEmptyType.network:
        return _buildDefaultImage(
          Icons.wifi_off_outlined,
          Colors.grey.shade500,
        );
      case VantEmptyType.search:
        return _buildDefaultImage(
          Icons.search,
          Colors.grey.shade500,
        );
      case VantEmptyType.normal:
      default:
        return _buildDefaultImage(
          Icons.inbox_outlined,
          Colors.grey.shade300,
        );
    }
  }

  // 从图片地址构建图片
  Widget _buildImageFromSource(String source) {
    if (source.startsWith('http')) {
      // 网络图片
      return Image.network(
        source,
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
        source,
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
