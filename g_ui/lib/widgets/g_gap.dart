import 'package:flutter/material.dart';

/// A gap widget that automatically provides spacing based on the parent layout.
///
/// - In a [Column], it provides vertical spacing (height)
/// - In a [Row], it provides horizontal spacing (width)
///
/// Example:
/// ```dart
/// Column(
///   children: [
///     Text('First widget'),
///     Gap(16), // 16px vertical gap
///     Text('Second widget'),
///   ],
/// )
/// ```
class Gap extends StatelessWidget {
  /// The size of the gap
  final double size;

  const Gap(this.size, {super.key});

  @override
  Widget build(BuildContext context) {
    // SizedBox with both width and height set to size
    // In Column: height will be used for vertical spacing
    // In Row: width will be used for horizontal spacing
    return SizedBox(width: size, height: size);
  }
}
