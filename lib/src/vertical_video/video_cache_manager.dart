import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;

typedef VideoCacheListener = void Function();

class VideoCacheManager {
  final Dio _dio = Dio();
  VideoCacheListener? _listener;
  bool _isInit = false;

  /// 缓存视频，支持 mp4 和 m3u8
  VideoCacheManager({
    required String videoUrl,
    required String savePath,
    required CancelToken cancelToken,
  }) {
    _init(videoUrl, savePath, cancelToken);
  }

  void addListener(VideoCacheListener listener) {
    _listener = listener;
  }

  void _init(String videoUrl, String savePath, CancelToken cancelToken) {
    if (savePath.endsWith('.m3u8')) {
      _cacheM3u8(videoUrl, savePath, cancelToken);
    } else {
      _cacheNormal(videoUrl, savePath, cancelToken);
    }
  }

  /// 缓存普通视频（支持断点续传）
  Future<void> _cacheNormal(
    String videoUrl,
    String savePath,
    CancelToken cancelToken,
  ) async {
    var file = File(savePath);
    if (await file.exists()) {
      _listener?.call();
    } else {
      file.createSync(recursive: true);
      _listener?.call();
    }

    try {
      await _downloadFile(videoUrl, savePath, cancelToken);
    } catch (e) {
      debugPrint('普通视频缓存失败: $e');
    }
  }

  /// 缓存 m3u8 视频（支持边下边播）
  Future<void> _cacheM3u8(
    String videoUrl,
    String savePath,
    CancelToken cancelToken,
  ) async {
    final m3u8File = File(savePath);
    final tsDir = Directory('${savePath}_ts');

    try {
      if (!await tsDir.exists()) {
        await tsDir.create(recursive: true);
      }

      final response = await _dio.get<String>(
        videoUrl,
        cancelToken: cancelToken,
        options: Options(responseType: ResponseType.plain),
      );

      final m3u8Content = response.data!;
      final lines = m3u8Content.split('\n');
      final tsUrls = <String>[];
      final rewrittenLines = <String>[];

      for (var line in lines) {
        line = line.trim();
        if (line.isEmpty) continue;

        if (line.startsWith('#')) {
          rewrittenLines.add(line);
        } else if (line.contains('.ts')) {
          final index = tsUrls.length;
          final tsUrl = _resolveUrl(videoUrl, line);
          tsUrls.add(tsUrl);

          final tsLocalPath = p.join(tsDir.path, 'segment_$index.ts');
          final localUri = 'file://${tsLocalPath.replaceAll('\\', '/')}';
          rewrittenLines.add(localUri);
        } else {
          // 其他资源（例如 key）也可能是相对路径，直接保持原样或额外处理
          rewrittenLines.add(line);
        }
      }

      // ✅ 立即写入本地 m3u8 文件
      await m3u8File.writeAsString(rewrittenLines.join('\n'), flush: true);

      // ⏬ 异步下载 ts 分片
      for (int i = 0; i < tsUrls.length; i++) {
        final tsUrl = tsUrls[i];
        final finalPath = p.join(tsDir.path, 'segment_$i.ts');

        try {
          await _downloadFile(tsUrl, finalPath, cancelToken);
          if (!_isInit) {
            _isInit = true;
            _listener?.call();
          }
        } catch (e) {
          debugPrint('❌ ts 分片 $i 下载失败: $e');
        }
      }
    } catch (e) {
      debugPrint('❌ m3u8 缓存失败: $e');
    }
  }

  /// 下载单个文件
  Future<void> _downloadFile(
    String url,
    String path,
    CancelToken cancelToken,
  ) async {
    final headResp = await _dio.head(
      url,
      options: Options(responseType: ResponseType.plain),
    );
    final contentLength =
        headResp.headers.value(HttpHeaders.contentLengthHeader);
    final totalSize =
        contentLength != null ? int.tryParse(contentLength) : null;
    int start = 0;

    final file = File(path);
    if (await file.exists()) {
      final localLength = await file.length();
      if (totalSize != null && localLength >= totalSize) {
        return; // 已下载完成
      }
      start = localLength;
    }

    await _dio.download(
      url,
      path,
      cancelToken: cancelToken,
      options: Options(
        headers: start > 0 ? {HttpHeaders.rangeHeader: 'bytes=$start-'} : null,
      ),
      onReceiveProgress: (received, total) {
        // debugPrint("下载: $received/$total");
      },
    );
  }

  /// 解析相对 ts 地址
  String _resolveUrl(String baseUrl, String relativePath) {
    final uri = Uri.parse(baseUrl);
    final tsUri = uri.resolve(relativePath);
    return tsUri.toString();
  }
}
