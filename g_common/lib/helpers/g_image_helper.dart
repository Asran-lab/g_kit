import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:g_lib/g_lib_image.dart' as g_image;

class GImageHelper {
  static final Map<String, Uint8List> _memoryCache = {};
  static const int _maxCacheSize = 100 * 1024 * 1024; // 100MB
  static int _currentCacheSize = 0;

  /// ✅ 1. 이미지 표시 (Asset, Network, SVG, Lottie 자동 처리)
  static Widget showImage(
    String path, {
    Size? size,
    Color? color,
    BoxFit fit = BoxFit.contain,
    double? scale,
    bool preserveColor = false,
    String fallbackAsset = '',
    bool onLoading = false,
  }) {
    if (path.isEmpty) {
      return _buildErrorWidget(size, color, fit, fallbackAsset);
    }

    try {
      final isNetwork = path.startsWith('http');
      final isSvg = path.toLowerCase().endsWith('.svg');

      /// 1. 네트워크 SVG
      if (isNetwork && isSvg) {
        return _NetworkSvgWidget(
          url: path,
          size: size,
          color: color,
          fit: fit,
          preserveColor: preserveColor,
          fallbackAsset: fallbackAsset,
        );
      }

      /// 2. 로컬 SVG
      if (!isNetwork && isSvg) {
        return _LocalSvgWidget(
          path: path,
          size: size,
          color: color,
          fit: fit,
          preserveColor: preserveColor,
          fallbackAsset: fallbackAsset,
        );
      }

      /// 3. 네트워크 일반 이미지
      if (isNetwork) {
        return _CachedNetworkImageWidget(
          url: path,
          size: size,
          color: color,
          fit: fit,
          scale: scale ?? 1.0,
          fallbackAsset: fallbackAsset,
        );
      }

      /// 4. 캐시된 파일
      if (path.contains('cache') || path.startsWith('/')) {
        return _FileImageWidget(
          path: path,
          size: size,
          color: color,
          fit: fit,
          fallbackAsset: fallbackAsset,
        );
      }

      /// 5. Lottie 애니메이션
      if (path.endsWith('.json') || path.endsWith('.lottie')) {
        return LottieWidget(
          path: path,
          size: size ?? const Size(100, 100),
          onLoading: onLoading,
        );
      }

      /// 6. 일반 에셋 이미지
      return Image.asset(
        path,
        width: size?.width,
        height: size?.height,
        fit: fit,
        color: color,
        scale: scale ?? 1.0,
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorWidget(size, color, fit, fallbackAsset);
        },
      );
    } catch (e) {
      return _buildErrorWidget(size, color, fit, fallbackAsset);
    }
  }

  /// ✅ 2. 이미지 압축 (cloud 업로드용)
  static Future<Uint8List> compressImage(io.File file,
      {int quality = 75}) async {
    final image = g_image.decodeImage(await file.readAsBytes());
    if (image == null) throw Exception("이미지 디코딩 실패");

    final compressed = g_image.encodeJpg(image, quality: quality);
    return Uint8List.fromList(compressed);
  }

  /// ✅ 3. 이미지 리사이즈
  static Future<Uint8List> resizeImage(io.File file, {int width = 512}) async {
    final image = g_image.decodeImage(await file.readAsBytes());
    if (image == null) throw Exception("이미지 디코딩 실패");

    final resized = g_image.copyResize(image, width: width);
    return Uint8List.fromList(g_image.encodeJpg(resized));
  }

  /// ✅ 4. 썸네일 생성 (리사이즈의 alias)
  static Future<Uint8List> generateThumbnail(
    io.File file, {
    int width = 200,
  }) =>
      resizeImage(file, width: width);

  /// ✅ 5. 파일 → Image 위젯 (간단한 경우용, 고급 기능은 _FileImageWidget 사용)
  static Widget fromFile(
    io.File file, {
    Size? size,
    BoxFit fit = BoxFit.cover,
  }) =>
      Image.file(
        file,
        width: size?.width,
        height: size?.height,
        fit: fit,
      );

  /// ✅ 6. Uint8List → Image 위젯
  static Widget fromBytes(
    Uint8List bytes, {
    Size? size,
    BoxFit fit = BoxFit.cover,
  }) =>
      Image.memory(
        bytes,
        width: size?.width,
        height: size?.height,
        fit: fit,
      );

  /// ✅ 7. 이미지 캐시 정리
  static void clearCache() {
    _memoryCache.clear();
    _currentCacheSize = 0;
  }

  /// ✅ 8. 전체 사이즈 이미지 렌더링
  static Widget showFullSizeImage(
    String path, {
    Size? size,
    int offset = 0,
    Color? color,
    bool onLoading = true,
  }) {
    return LayoutBuilder(
      builder: (context, layout) {
        return ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: Container(
            width: layout.maxWidth,
            height: layout.maxHeight > offset
                ? layout.maxHeight - offset
                : double.infinity,
            color: color ?? Colors.black.withValues(alpha: 0.4),
            child: showImage(
              path,
              onLoading: onLoading,
              size: size,
            ),
          ),
        );
      },
    );
  }

  /// 에러 위젯 빌더
  static Widget _buildErrorWidget(
    Size? size,
    Color? color,
    BoxFit fit,
    String fallbackAsset,
  ) {
    if (fallbackAsset.isNotEmpty) {
      return Image.asset(
        fallbackAsset,
        width: size?.width,
        height: size?.height,
        fit: fit,
        color: color,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: size?.width ?? 48,
            height: size?.height ?? 48,
            color: Colors.grey[300],
            child: const Icon(Icons.image_not_supported),
          );
        },
      );
    }

    return Container(
      width: size?.width ?? 48,
      height: size?.height ?? 48,
      color: Colors.grey[300],
      child: const Icon(Icons.image_not_supported),
    );
  }

  /// 네트워크에서 데이터 로드
  static Future<Uint8List> loadNetworkData(String url) async {
    if (_memoryCache.containsKey(url)) {
      return _memoryCache[url]!;
    }

    final client = io.HttpClient();
    try {
      final request = await client.getUrl(Uri.parse(url));
      final response = await request.close();

      if (response.statusCode == 200) {
        final bytes = await _consolidateHttpClientResponseBytes(response);
        await _cacheData(url, bytes);
        return bytes;
      } else {
        throw Exception('HTTP ${response.statusCode}');
      }
    } finally {
      client.close();
    }
  }

  /// HttpClientResponse에서 바이트 데이터 통합
  static Future<Uint8List> _consolidateHttpClientResponseBytes(
      io.HttpClientResponse response) async {
    final List<int> bytes = [];
    await for (final chunk in response) {
      bytes.addAll(chunk);
    }
    return Uint8List.fromList(bytes);
  }

  /// 메모리 캐시에 데이터 저장
  static Future<void> _cacheData(String key, Uint8List data) async {
    if (_currentCacheSize + data.length > _maxCacheSize) {
      _clearOldCache();
    }

    _memoryCache[key] = data;
    _currentCacheSize += data.length;
  }

  /// 오래된 캐시 정리
  static void _clearOldCache() {
    final keysToRemove = _memoryCache.keys.take(_memoryCache.length ~/ 2);
    for (final key in keysToRemove) {
      final data = _memoryCache.remove(key);
      if (data != null) {
        _currentCacheSize -= data.length;
      }
    }
  }

  /// SVG 크기 정보 추출
  static Size _extractSvgSize(String svgString) {
    // viewBox 파싱
    final viewBoxMatch = RegExp(r'viewBox="([^"]*)"').firstMatch(svgString);
    if (viewBoxMatch != null) {
      final viewBox = viewBoxMatch.group(1)!.split(' ');
      if (viewBox.length >= 4) {
        final width = double.tryParse(viewBox[2]) ?? 24;
        final height = double.tryParse(viewBox[3]) ?? 24;
        return Size(width, height);
      }
    }

    // width/height 속성 파싱
    final widthMatch = RegExp(r'width="([^"]*)"').firstMatch(svgString);
    final heightMatch = RegExp(r'height="([^"]*)"').firstMatch(svgString);

    final width =
        widthMatch != null ? double.tryParse(widthMatch.group(1)!) ?? 24 : 24.0;
    final height = heightMatch != null
        ? double.tryParse(heightMatch.group(1)!) ?? 24
        : 24.0;

    return Size(width, height);
  }

  /// SVG 파싱 (단순한 형태만 지원)
  static Future<ui.Picture> parseSvg(String svgString,
      {Size? targetSize}) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // SVG 크기 정보 추출
    final svgSize = _extractSvgSize(svgString);

    // 목표 크기가 있으면 스케일 계산
    if (targetSize != null) {
      final scaleX = targetSize.width / svgSize.width;
      final scaleY = targetSize.height / svgSize.height;
      final scale = scaleX < scaleY ? scaleX : scaleY;
      canvas.scale(scale);
    }

    // 간단한 path 파싱
    final pathMatches =
        RegExp(r'<path[^>]*d="([^"]*)"[^>]*>').allMatches(svgString);

    for (final match in pathMatches) {
      final pathData = match.group(1);
      if (pathData != null) {
        final path = _parseSimplePath(pathData);
        final paint = Paint()
          ..color = Colors.black
          ..style = PaintingStyle.fill;

        // fill 속성 파싱
        final fillMatch = RegExp(r'fill="([^"]*)"').firstMatch(match.group(0)!);
        if (fillMatch != null) {
          final fillColor = _parseColor(fillMatch.group(1)!);
          if (fillColor != null) {
            paint.color = fillColor;
          }
        }

        canvas.drawPath(path, paint);
      }
    }

    return recorder.endRecording();
  }

  /// 간단한 SVG path 파싱 (M, L 명령만 지원)
  static Path _parseSimplePath(String pathData) {
    final path = Path();
    final commands =
        pathData.replaceAll(RegExp(r'[,\s]+'), ' ').trim().split(' ');

    String? currentCommand;
    double currentX = 0;
    double currentY = 0;

    for (int i = 0; i < commands.length; i++) {
      final command = commands[i];

      if (command == 'M' || command == 'm') {
        currentCommand = command;
        if (i + 2 < commands.length) {
          final x = double.tryParse(commands[i + 1]) ?? 0;
          final y = double.tryParse(commands[i + 2]) ?? 0;

          if (command == 'M') {
            path.moveTo(x, y);
            currentX = x;
            currentY = y;
          } else {
            path.moveTo(currentX + x, currentY + y);
            currentX += x;
            currentY += y;
          }
          i += 2;
        }
      } else if (command == 'L' || command == 'l') {
        currentCommand = command;
        if (i + 2 < commands.length) {
          final x = double.tryParse(commands[i + 1]) ?? 0;
          final y = double.tryParse(commands[i + 2]) ?? 0;

          if (command == 'L') {
            path.lineTo(x, y);
            currentX = x;
            currentY = y;
          } else {
            path.lineTo(currentX + x, currentY + y);
            currentX += x;
            currentY += y;
          }
          i += 2;
        }
      } else if (command == 'Z' || command == 'z') {
        path.close();
      } else if (double.tryParse(command) != null && currentCommand != null) {
        // 숫자인 경우 이전 명령 반복
        final x = double.parse(command);
        if (i + 1 < commands.length) {
          final y = double.tryParse(commands[i + 1]) ?? 0;

          if (currentCommand == 'M' || currentCommand == 'L') {
            path.lineTo(x, y);
            currentX = x;
            currentY = y;
          } else if (currentCommand == 'm' || currentCommand == 'l') {
            path.lineTo(currentX + x, currentY + y);
            currentX += x;
            currentY += y;
          }
          i += 1;
        }
      }
    }

    return path;
  }

  /// 색상 파싱
  static Color? _parseColor(String colorString) {
    final color = colorString.toLowerCase().trim();

    if (color == 'none' || color == 'transparent') {
      return Colors.transparent;
    }

    if (color.startsWith('#')) {
      final hex = color.substring(1);
      if (hex.length == 6) {
        return Color(int.parse('FF$hex', radix: 16));
      } else if (hex.length == 8) {
        return Color(int.parse(hex, radix: 16));
      }
    }

    // 기본 색상들
    switch (color) {
      case 'black':
        return Colors.black;
      case 'white':
        return Colors.white;
      case 'red':
        return Colors.red;
      case 'green':
        return Colors.green;
      case 'blue':
        return Colors.blue;
      default:
        return null;
    }
  }
}

/// 네트워크 SVG 위젯
class _NetworkSvgWidget extends StatefulWidget {
  final String url;
  final Size? size;
  final Color? color;
  final BoxFit fit;
  final bool preserveColor;
  final String fallbackAsset;

  const _NetworkSvgWidget({
    required this.url,
    this.size,
    this.color,
    this.fit = BoxFit.contain,
    this.preserveColor = false,
    this.fallbackAsset = '',
  });

  @override
  State<_NetworkSvgWidget> createState() => _NetworkSvgWidgetState();
}

class _NetworkSvgWidgetState extends State<_NetworkSvgWidget> {
  ui.Picture? _picture;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadSvg();
  }

  Future<void> _loadSvg() async {
    try {
      final data = await GImageHelper.loadNetworkData(widget.url);
      final svgString = utf8.decode(data);
      final picture =
          await GImageHelper.parseSvg(svgString, targetSize: widget.size);

      if (mounted) {
        setState(() {
          _picture = picture;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return SizedBox(
        width: widget.size?.width ?? 24,
        height: widget.size?.height ?? 24,
        child: const CircularProgressIndicator(strokeWidth: 2),
      );
    }

    if (_error != null || _picture == null) {
      return GImageHelper._buildErrorWidget(
        widget.size,
        widget.color,
        widget.fit,
        widget.fallbackAsset,
      );
    }

    return CustomPaint(
      size: widget.size ?? const Size(24, 24),
      painter: _SvgPainter(
        picture: _picture!,
        color: widget.preserveColor ? null : widget.color,
        fit: widget.fit,
      ),
    );
  }
}

/// 로컬 SVG 위젯
class _LocalSvgWidget extends StatefulWidget {
  final String path;
  final Size? size;
  final Color? color;
  final BoxFit fit;
  final bool preserveColor;
  final String fallbackAsset;

  const _LocalSvgWidget({
    required this.path,
    this.size,
    this.color,
    this.fit = BoxFit.contain,
    this.preserveColor = false,
    this.fallbackAsset = '',
  });

  @override
  State<_LocalSvgWidget> createState() => _LocalSvgWidgetState();
}

class _LocalSvgWidgetState extends State<_LocalSvgWidget> {
  ui.Picture? _picture;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadSvg();
  }

  Future<void> _loadSvg() async {
    try {
      final svgString = await rootBundle.loadString(widget.path);
      final picture =
          await GImageHelper.parseSvg(svgString, targetSize: widget.size);

      if (mounted) {
        setState(() {
          _picture = picture;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return SizedBox(
        width: widget.size?.width ?? 24,
        height: widget.size?.height ?? 24,
        child: const CircularProgressIndicator(strokeWidth: 2),
      );
    }

    if (_error != null || _picture == null) {
      return GImageHelper._buildErrorWidget(
        widget.size,
        widget.color,
        widget.fit,
        widget.fallbackAsset,
      );
    }

    return CustomPaint(
      size: widget.size ?? const Size(24, 24),
      painter: _SvgPainter(
        picture: _picture!,
        color: widget.preserveColor ? null : widget.color,
        fit: widget.fit,
      ),
    );
  }
}

/// SVG 페인터
class _SvgPainter extends CustomPainter {
  final ui.Picture picture;
  final Color? color;
  final BoxFit fit;

  const _SvgPainter({
    required this.picture,
    this.color,
    this.fit = BoxFit.contain,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (color != null) {
      canvas.saveLayer(null,
          Paint()..colorFilter = ColorFilter.mode(color!, BlendMode.srcIn));
    }

    // SVG 크기 정보를 알 수 없어 기본값 사용 (targetSize로 이미 조정됨)
    canvas.drawPicture(picture);

    if (color != null) {
      canvas.restore();
    }
  }

  // _getScale 메서드 제거됨 (사용되지 않음)

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is! _SvgPainter ||
        oldDelegate.picture != picture ||
        oldDelegate.color != color ||
        oldDelegate.fit != fit;
  }
}

/// 캐시된 네트워크 이미지 위젯
class _CachedNetworkImageWidget extends StatefulWidget {
  final String url;
  final Size? size;
  final Color? color;
  final BoxFit fit;
  final double scale;
  final String fallbackAsset;

  const _CachedNetworkImageWidget({
    required this.url,
    this.size,
    this.color,
    this.fit = BoxFit.contain,
    this.scale = 1.0,
    this.fallbackAsset = '',
  });

  @override
  State<_CachedNetworkImageWidget> createState() =>
      _CachedNetworkImageWidgetState();
}

class _CachedNetworkImageWidgetState extends State<_CachedNetworkImageWidget> {
  ImageProvider? _imageProvider;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    try {
      final data = await GImageHelper.loadNetworkData(widget.url);

      if (mounted) {
        setState(() {
          _imageProvider = MemoryImage(data);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        width: widget.size?.width,
        height: widget.size?.height,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(strokeWidth: 2),
      );
    }

    if (_error != null || _imageProvider == null) {
      return GImageHelper._buildErrorWidget(
        widget.size,
        widget.color,
        widget.fit,
        widget.fallbackAsset,
      );
    }

    return Image(
      image: _imageProvider!,
      width: widget.size?.width,
      height: widget.size?.height,
      fit: widget.fit,
      color: widget.color,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) return child;
        return AnimatedOpacity(
          opacity: frame == null ? 0 : 1,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          child: child,
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return GImageHelper._buildErrorWidget(
          widget.size,
          widget.color,
          widget.fit,
          widget.fallbackAsset,
        );
      },
    );
  }
}

/// 파일 이미지 위젯
class _FileImageWidget extends StatelessWidget {
  final String path;
  final Size? size;
  final Color? color;
  final BoxFit fit;
  final String fallbackAsset;

  const _FileImageWidget({
    required this.path,
    this.size,
    this.color,
    this.fit = BoxFit.contain,
    this.fallbackAsset = '',
  });

  @override
  Widget build(BuildContext context) {
    final double? w = size?.width;
    final double? h = size?.height;
    final int? cacheW = (w != null && w.isFinite && w > 0) ? w.floor() : null;

    return Image.file(
      io.File(path),
      width: (w != null && w.isFinite) ? w : null,
      height: (h != null && h.isFinite) ? h : null,
      fit: fit,
      color: color,
      cacheWidth: cacheW,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) return child;
        return AnimatedOpacity(
          opacity: frame == null ? 0 : 1,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          child: child,
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return GImageHelper._buildErrorWidget(size, color, fit, fallbackAsset);
      },
    );
  }
}

class LottieWidget extends StatefulWidget {
  final String path;
  final Size size;
  final bool onLoading;

  const LottieWidget({
    super.key,
    required this.path,
    this.size = const Size(100, 100),
    this.onLoading = false,
  });

  @override
  State<LottieWidget> createState() => LottieWidgetState();
}

class LottieWidgetState extends State<LottieWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final g_image.LottieBuilder _lottieBuilder;
  g_image.LottieDecoder? _decoder;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);

    // Choose decoder for .lottie/.tgs if needed
    final lowerPath = widget.path.toLowerCase();
    if (lowerPath.endsWith('.tgs')) {
      _decoder = g_image.LottieComposition.decodeGZip;
    } else if (lowerPath.endsWith('.lottie')) {
      _decoder = (bytes) => g_image.LottieComposition.decodeZip(
            bytes,
            filePicker: (files) {
              // Prefer animations/*.json inside the archive
              for (final f in files) {
                final name = f.name.toLowerCase();
                if (name.startsWith('animations/') && name.endsWith('.json')) {
                  return f;
                }
              }
              // Fallback: first json file
              for (final f in files) {
                if (f.name.toLowerCase().endsWith('.json')) return f;
              }
              return files.first;
            },
          );
    }
    _lottieBuilder = g_image.LottieBuilder.asset(
      widget.path,
      controller: _animationController,
      onLoaded: (composition) {
        _animationController
          ..duration = composition.duration
          ..repeat();
      },
      width: widget.size.width,
      height: widget.size.height,
      decoder: _decoder,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: _lottieBuilder);
  }
}
