import 'package:flutter/material.dart';

enum GDirection {
  horizontal, // 좌우 분할
  vertical, // 상하 분할
}

class GSplitView extends StatefulWidget {
  final Widget firstChild;
  final Widget secondChild;
  final double ratio;
  final GDirection direction;
  final double dividerSize;
  final Color? dividerColor;

  const GSplitView({
    super.key,
    required this.firstChild,
    required this.secondChild,
    this.ratio = 0.5,
    this.direction = GDirection.vertical,
    this.dividerSize = 4.0,
    this.dividerColor,
  })  : assert(ratio >= 0),
        assert(ratio <= 1);

  @override
  State<GSplitView> createState() => _GSplitViewState();
}

class _GSplitViewState extends State<GSplitView> {
  late double _ratio;
  double _maxSize = 0;

  double get _firstSize => _ratio * _maxSize;
  // double get secondSize => (1 - _ratio) * _maxSize;

  bool get _isVertical => widget.direction == GDirection.vertical;

  @override
  void initState() {
    super.initState();
    _ratio = widget.ratio;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, BoxConstraints constraints) {
        assert(_ratio <= 1);
        assert(_ratio >= 0);

        final maxSize = _isVertical
            ? constraints.maxHeight - widget.dividerSize
            : constraints.maxWidth - widget.dividerSize;

        if (_maxSize != maxSize) {
          _maxSize = maxSize;
        }

        return _isVertical ? _buildVerticalSplit() : _buildHorizontalSplit();
      },
    );
  }

  Widget _buildVerticalSplit() {
    return Column(
      children: [
        SizedBox(
          height: _firstSize,
          child: widget.firstChild,
        ),
        _buildVerticalDivider(context),
        Expanded(child: widget.secondChild),
      ],
    );
  }

  Widget _buildHorizontalSplit() {
    return Row(
      children: [
        SizedBox(
          width: _firstSize,
          child: widget.firstChild,
        ),
        _buildHorizontalDivider(context),
        Expanded(child: widget.secondChild),
      ],
    );
  }

  Widget _buildVerticalDivider(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onPanUpdate: _handleVerticalDrag,
      child: Container(
        width: 30,
        height: widget.dividerSize,
        alignment: Alignment.center,
        color: widget.dividerColor ?? Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Container(
          width: 40,
          height: widget.dividerSize + 24,
          decoration: BoxDecoration(
            color: widget.dividerColor ?? Theme.of(context).dividerColor,
            borderRadius: BorderRadius.circular(widget.dividerSize / 2),
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalDivider(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onPanUpdate: _handleHorizontalDrag,
      child: Container(
        width: widget.dividerSize + 24,
        height: 30,
        alignment: Alignment.center,
        color: widget.dividerColor ?? Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Container(
          width: widget.dividerSize,
          height: 40,
          decoration: BoxDecoration(
            color: widget.dividerColor ?? Theme.of(context).dividerColor,
            borderRadius: BorderRadius.circular(widget.dividerSize / 2),
          ),
        ),
      ),
    );
  }

  void _handleVerticalDrag(DragUpdateDetails details) {
    setState(() {
      _ratio += details.delta.dy / _maxSize;
      _ratio = _ratio.clamp(0.1, 1.3);
    });
  }

  void _handleHorizontalDrag(DragUpdateDetails details) {
    setState(() {
      _ratio += details.delta.dx / _maxSize;
      _ratio = _ratio.clamp(0.1, 0.3);
    });
  }
}
