import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:g_ui/g_ui.dart';

/// 네비게이션 아이템 모델
class GNavigationItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const GNavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

/// 애니메이션 하단 네비게이션 바 (Scaffold 포함)
///
/// AnimatedBottomNavigationBar, 중앙 FAB, Scaffold를 모두 포함한 완전한 네비게이션 위젯
class GBottomNavigation extends ConsumerStatefulWidget {
  final Widget child;
  final int selectedIndex;
  final List<GNavigationItem> items;
  final Function(int) onTap;
  final bool hasCenterButton;
  final IconData? centerIcon;

  const GBottomNavigation({
    super.key,
    required this.child,
    required this.selectedIndex,
    required this.items,
    required this.onTap,
    this.hasCenterButton = true,
    this.centerIcon,
  });

  @override
  ConsumerState<GBottomNavigation> createState() => GBottomNavigationState();
}

class GBottomNavigationState extends ConsumerState<GBottomNavigation>
    with TickerProviderStateMixin {
  late AnimationController _fabAnimationController;
  late AnimationController _borderRadiusAnimationController;
  late Animation<double> _fabAnimation;
  late Animation<double> _borderRadiusAnimation;
  late AnimationController _hideBottomBarAnimationController;

  // 중앙 버튼의 실제 인덱스 (items 길이의 중간)
  int get _centerButtonIndex => widget.items.length ~/ 2;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _borderRadiusAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    final fabCurve = CurvedAnimation(
      parent: _fabAnimationController,
      curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    );
    final borderRadiusCurve = CurvedAnimation(
      parent: _borderRadiusAnimationController,
      curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    );

    _fabAnimation = Tween<double>(begin: 0, end: 1).animate(fabCurve);
    _borderRadiusAnimation = Tween<double>(begin: 0, end: 1).animate(
      borderRadiusCurve,
    );

    _hideBottomBarAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    // 초기 애니메이션
    Future.delayed(
      const Duration(milliseconds: 100),
      () {
        if (mounted) {
          _fabAnimationController.forward();
          _borderRadiusAnimationController.forward();
        }
      },
    );
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    _borderRadiusAnimationController.dispose();
    _hideBottomBarAnimationController.dispose();
    super.dispose();
  }

  /// 실제 인덱스를 BottomNav 인덱스로 변환
  int _toBottomNavIndex(int actualIndex) {
    if (!widget.hasCenterButton) return actualIndex;

    if (actualIndex == _centerButtonIndex) {
      return -1; // 중앙 버튼 선택 시
    } else if (actualIndex > _centerButtonIndex) {
      return actualIndex - 1;
    } else {
      return actualIndex;
    }
  }

  /// BottomNav 인덱스를 실제 인덱스로 변환
  int _toActualIndex(int bottomNavIndex) {
    if (!widget.hasCenterButton) return bottomNavIndex;

    if (bottomNavIndex >= _centerButtonIndex) {
      return bottomNavIndex + 1;
    } else {
      return bottomNavIndex;
    }
  }

  void _handleTap(int index) {
    widget.onTap(index);

    // 애니메이션 리셋
    _fabAnimationController.reset();
    _borderRadiusAnimationController.reset();
    _fabAnimationController.forward();
    _borderRadiusAnimationController.forward();
  }

  void _handleCenterButtonTap() {
    widget.onTap(_centerButtonIndex);
    // FAB 애니메이션 리셋
    _fabAnimationController.reset();
    _fabAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final bottomNavIndex = _toBottomNavIndex(widget.selectedIndex);

    return Scaffold(
      extendBody: true,
      body: widget.child,
      floatingActionButton:
          widget.hasCenterButton ? _buildCenterButton() : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNavigationBar(colors, bottomNavIndex),
    );
  }

  Widget _buildCenterButton() {
    final colors = Theme.of(context).colorScheme;
    final isSelected = widget.selectedIndex == _centerButtonIndex;

    return ScaleTransition(
      scale: _fabAnimation,
      child: GestureDetector(
        onTap: _handleCenterButtonTap,
        child: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    colors: [colors.primary, colors.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: !isSelected ? colors.primary : null,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? colors.primary.withValues(alpha: 0.9)
                    : colors.outline.withValues(alpha: 0.9),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            widget.centerIcon ?? Icons.home_rounded,
            color: isSelected ? Colors.white : colors.onSurfaceVariant,
            size: 28,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(ColorScheme colors, int bottomNavIndex) {
    return AnimatedBottomNavigationBar.builder(
      itemCount: widget.items.length,
      tabBuilder: (int index, bool isActive) {
        final isSelected = bottomNavIndex == index;
        final color = isSelected ? colors.primary : colors.onSurfaceVariant;
        final item = widget.items[index];

        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? item.activeIcon : item.icon,
              size: 24,
              color: color,
            ),
            Gap(4),
            Text(
              item.label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: color,
              ),
            ),
          ],
        );
      },
      backgroundColor: colors.surface,
      activeIndex: bottomNavIndex,
      splashColor: colors.primary,
      splashSpeedInMilliseconds: 300,
      notchSmoothness: NotchSmoothness.softEdge,
      gapLocation:
          widget.hasCenterButton ? GapLocation.center : GapLocation.none,
      gapWidth: widget.hasCenterButton ? 80 : 0,
      leftCornerRadius: 24,
      rightCornerRadius: 24,
      onTap: (index) {
        final realIndex = _toActualIndex(index);
        _handleTap(realIndex);
      },
      notchAndCornersAnimation: _borderRadiusAnimation,
      hideAnimationController: _hideBottomBarAnimationController,
      shadow: BoxShadow(
        offset: const Offset(0, -2),
        blurRadius: 12,
        spreadRadius: 0.5,
        color: colors.shadow.withValues(alpha: 0.08),
      ),
    );
  }
}
