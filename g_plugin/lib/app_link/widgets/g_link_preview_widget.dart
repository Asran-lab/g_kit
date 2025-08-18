import 'package:flutter/material.dart';
import 'package:g_lib/g_lib_common.dart';
import 'package:g_plugin/app_link/service/g_app_link_service.dart';
import 'package:g_common/g_common.dart';
import '../facade/g_app_link.dart';

/// 링크 프리뷰 위젯
class GLinkPreviewWidget extends StatefulWidget {
  final String url;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderWidth;
  final bool showCloseButton;
  final VoidCallback? onClose;
  final LinkPreviewData? initialData;

  const GLinkPreviewWidget({
    super.key,
    required this.url,
    this.onTap,
    this.onLongPress,
    this.margin,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.showCloseButton = false,
    this.onClose,
    this.initialData,
  });

  /// MemoLink 데이터로부터 생성하는 팩토리 생성자
  factory GLinkPreviewWidget.fromMemoLink({
    Key? key,
    required String url,
    required String title,
    required String description,
    String? thumbnailUrl,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
    Color? backgroundColor,
    Color? borderColor,
    double? borderWidth,
    bool showCloseButton = false,
    VoidCallback? onClose,
  }) {
    return GLinkPreviewWidget(
      key: key,
      url: url,
      onTap: onTap,
      onLongPress: onLongPress,
      margin: margin,
      padding: padding,
      borderRadius: borderRadius,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      borderWidth: borderWidth,
      showCloseButton: showCloseButton,
      onClose: onClose,
      initialData: LinkPreviewData(
        url: url,
        title: title.isNotEmpty ? title : null,
        description: description.isNotEmpty ? description : null,
        imageUrl: thumbnailUrl,
      ),
    );
  }

  @override
  State<GLinkPreviewWidget> createState() => _GLinkPreviewWidgetState();
}

class _GLinkPreviewWidgetState extends State<GLinkPreviewWidget> {
  LinkPreviewData? _previewData;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadPreviewData();
  }

  Future<void> _loadPreviewData() async {
    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });

      // initialData가 있으면 바로 사용
      if (widget.initialData != null) {
        Logger.d('🔗 위젯: 초기 데이터 사용 - ${widget.initialData!.title}');
        if (mounted) {
          setState(() {
            _previewData = widget.initialData;
            _isLoading = false;
          });
        }
        return;
      }

      // initialData가 없으면 API 호출
      Logger.d('🔗 위젯: 링크 프리뷰 로딩 시작 - ${widget.url}');
      final data = await GAppLink.extractLinkMetadata(widget.url)
          .timeout(const Duration(seconds: 20));
      Logger.d('🔗 위젯: 메타데이터 수신 - ${data?.title}');

      if (mounted) {
        setState(() {
          _previewData = data;
          _isLoading = false;
        });
        Logger.d('🔗 위젯: 상태 업데이트 완료');
      }
    } catch (e) {
      Logger.e('🔗 위젯: 로딩 실패 - $e');
      if (mounted) {
        // 에러가 발생해도 기본 데이터를 생성해서 표시
        final fallbackData = LinkPreviewData(
          url: widget.url,
          title: _extractDomainFromUrl(widget.url),
          description: '링크 프리뷰를 불러올 수 없습니다.',
        );
        
        setState(() {
          _previewData = fallbackData;
          _hasError = false; // 에러 상태가 아닌 성공 상태로 처리
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleTap() async {
    if (widget.onTap != null) {
      widget.onTap!();
    } else {
      // 기본 동작: 외부 브라우저에서 열기
      try {
        final url = Uri.parse(widget.url);
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        }
      } catch (e) {
        // URL 오류 시 무시
        Logger.e('URL 실행 오류: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin ?? const EdgeInsets.symmetric(vertical: 8),
      child: Material(
        color: widget.backgroundColor ?? Theme.of(context).cardColor,
        borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
        child: InkWell(
          onTap: _handleTap,
          onLongPress: widget.onLongPress,
          borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
          child: Container(
            padding: widget.padding ?? const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(
                color: widget.borderColor ?? Theme.of(context).dividerColor,
                width: widget.borderWidth ?? 1,
              ),
              borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
            ),
            child: _buildContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_hasError || _previewData == null) {
      return _buildErrorState();
    }

    return _buildPreviewContent();
  }

  Widget _buildLoadingState() {
    return SizedBox(
      height: 80,
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 제목 스켈레톤
                Container(
                  height: 16,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                // 설명 스켈레톤
                Container(
                  height: 12,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  height: 12,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                // URL 스켈레톤
                Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      height: 12,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return SizedBox(
      height: 80,
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.link_off, color: Colors.grey),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _extractDomainFromUrl(widget.url),
                  style: Theme.of(context).textTheme.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '링크 프리뷰를 불러올 수 없습니다',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewContent() {
    final data = _previewData!;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 이미지 또는 파비콘
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[300],
          ),
          child: _buildPreviewImage(data),
        ),
        const SizedBox(width: 12),
        // 텍스트 콘텐츠
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // 제목
              Text(
                data.title ?? _extractDomainFromUrl(data.url),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              // 설명
              if (data.description != null) ...[
                const SizedBox(height: 4),
                Text(
                  data.description!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              const SizedBox(height: 8),

              // URL 및 사이트명
              Row(
                children: [
                  if (data.favicon != null) ...[
                    Image.network(
                      data.favicon!,
                      width: 16,
                      height: 16,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Icon(Icons.public, size: 16);
                      },
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.public, size: 16),
                    ),
                    const SizedBox(width: 4),
                  ],
                  Expanded(
                    child: Text(
                      data.siteName ?? _extractDomainFromUrl(data.url),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[500],
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // 닫기 버튼
        if (widget.showCloseButton) ...[
          const SizedBox(width: 8),
          InkWell(
            onTap: widget.onClose,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Icon(
                Icons.close,
                size: 16,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPreviewImage(LinkPreviewData data) {
    if (data.imageUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          data.imageUrl!,
          width: 80,
          height: 80,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: 80,
              height: 80,
              color: Colors.grey[300],
              child: const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) => _buildFallbackImage(data),
        ),
      );
    }

    return _buildFallbackImage(data);
  }

  Widget _buildFallbackImage(LinkPreviewData data) {
    if (data.favicon != null) {
      return Center(
        child: Image.network(
          data.favicon!,
          width: 32,
          height: 32,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Icon(Icons.public, size: 32, color: Colors.grey);
          },
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.public, size: 32, color: Colors.grey),
        ),
      );
    }

    return const Center(
      child: Icon(Icons.link, size: 32, color: Colors.grey),
    );
  }

  String _extractDomainFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.host;
    } catch (e) {
      return url;
    }
  }
}
