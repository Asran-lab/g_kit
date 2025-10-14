import 'package:flutter/material.dart';
import 'package:g_ui/configs/g_text_config.dart';

class GSlideToUnlock extends StatefulWidget {
  final String text;
  final VoidCallback? onSlideComplete;
  final bool isLoading;
  final Color primaryColor;
  final Color secondaryColor;

  const GSlideToUnlock({
    super.key,
    required this.text,
    this.onSlideComplete,
    this.isLoading = false,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  State<GSlideToUnlock> createState() => GSlideToUnlockState();
}

class GSlideToUnlockState extends State<GSlideToUnlock>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _shimmerController;
  late AnimationController _progressController;
  late Animation<double> slideAnimation;
  late Animation<double> _shimmerAnimation;
  late Animation<double> _progressAnimation;

  double _dragOffset = 0.0;
  bool isDragging = false;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 3500),
      vsync: this,
    );

    _progressController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    slideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _shimmerAnimation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOut,
    ));

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));

    // Shimmer 애니메이션 반복
    _shimmerController.repeat();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _shimmerController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(GSlideToUnlock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading && !oldWidget.isLoading) {
      _startProgressAnimation();
    } else if (!widget.isLoading && oldWidget.isLoading) {
      _stopProgressAnimation();
    }
  }

  void _startProgressAnimation() {
    _progressController.repeat();
  }

  void _stopProgressAnimation() {
    _progressController.stop();
    _progressController.reset();
  }

  void _onDragStart(DragStartDetails details) {
    if (widget.isLoading || _isCompleted) return;
    setState(() => isDragging = true);
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (widget.isLoading || _isCompleted) return;

    setState(() {
      _dragOffset += details.delta.dx;
      _dragOffset = _dragOffset.clamp(0.0, _getMaxDragDistance());
    });
  }

  void _onDragEnd(DragEndDetails details) {
    if (widget.isLoading || _isCompleted) return;

    setState(() => isDragging = false);

    final maxDistance = _getMaxDragDistance();
    if (_dragOffset >= maxDistance * 0.8) {
      // 슬라이드 완료
      _completeSlide();
    } else {
      // 원위치로 복귀
      _resetSlide();
    }
  }

  void _completeSlide() {
    _slideController.forward().then((_) {
      setState(() => _isCompleted = true);
      widget.onSlideComplete?.call();
    });
  }

  void reset() {
    setState(() {
      _isCompleted = false;
      _dragOffset = 0.0;
    });
    _slideController.reset();
  }

  void _resetSlide() {
    _slideController.reverse().then((_) {
      setState(() => _dragOffset = 0.0);
    });
  }

  double _getMaxDragDistance() {
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return 0.0;
    return renderBox.size.width - 60; // 슬라이더 버튼 크기 고려
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // final maxDragDistance = constraints.maxWidth - 64;
        // final slideProgress = _dragOffset / maxDragDistance;

        return Container(
          height: 64,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.grey.shade900.withValues(alpha: 0.8),
                Colors.grey.shade800.withValues(alpha: 0.8),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: Colors.grey.shade700.withValues(alpha: 0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              // 배경 그라데이션
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.grey.shade900.withValues(alpha: 0.6),
                      Colors.grey.shade800.withValues(alpha: 0.6),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(32),
                ),
              ),

              // 슬라이드 진행 영역
              Container(
                width: _dragOffset + 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      widget.primaryColor.withValues(alpha: 0.3),
                      widget.secondaryColor.withValues(alpha: 0.3),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(32),
                ),
              ),

              // 텍스트 (Shimmer 효과)
              if (!widget.isLoading && !_isCompleted)
                Positioned(
                  left: _dragOffset, // 슬라이더 버튼 너비 + 드래그 오프셋의 절반
                  right: _dragOffset,
                  top: 0,
                  bottom: 0,
                  child: AnimatedBuilder(
                    animation: _shimmerAnimation,
                    builder: (context, child) {
                      return ShaderMask(
                        shaderCallback: (bounds) {
                          return LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.white.withValues(alpha: 0.2),
                              Colors.white.withValues(alpha: 0.9),
                              Colors.white.withValues(alpha: 0.2),
                              Colors.transparent,
                            ],
                            stops: [
                              _shimmerAnimation.value - 0.6,
                              _shimmerAnimation.value - 0.2,
                              _shimmerAnimation.value,
                              _shimmerAnimation.value + 0.3,
                              _shimmerAnimation.value + 0.6,
                            ],
                          ).createShader(bounds);
                        },
                        child: Center(
                          child: Text(
                            widget.text,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

              // 로딩 상태일 때 프로그레스
              if (widget.isLoading)
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: _progressAnimation,
                    builder: (context, child) {
                      return Stack(
                        children: [
                          // 프로그레스 배경
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  widget.primaryColor.withValues(alpha: 0.4),
                                  widget.secondaryColor.withValues(alpha: 0.4),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(32),
                            ),
                          ),

                          // 프로그레스 바
                          Container(
                            width:
                                constraints.maxWidth * _progressAnimation.value,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  widget.primaryColor,
                                  widget.secondaryColor,
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(32),
                            ),
                          ),

                          // 로딩 텍스트
                          Center(
                            child: Text(
                              '숏코드 생성중...',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

              // 슬라이더 버튼
              if (!widget.isLoading)
                Positioned(
                  left: _dragOffset,
                  top: 2, // 상단에서 2px 여백
                  child: GestureDetector(
                    onPanStart: _onDragStart,
                    onPanUpdate: _onDragUpdate,
                    onPanEnd: _onDragEnd,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.grey.shade100,
                            Colors.grey.shade200,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                          BoxShadow(
                            color: Colors.white.withValues(alpha: 0.1),
                            blurRadius: 1,
                            offset: const Offset(0, -1),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        color: widget.primaryColor,
                        size: 26,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
