import 'package:flutter/material.dart';

/// A widget that renders a dragged icon with lift animation and shadow.
///
/// This widget displays an icon that has been grabbed during a drag
/// operation. It applies visual feedback including lift height, scale
/// transformation, reduced opacity, and enhanced shadow to indicate
/// the dragged state.
///
/// The widget is positioned absolutely and follows the cursor during
/// drag operations. It excludes the dragged icon from magnification
/// calculations while maintaining normal magnification for other icons.
///
/// Parameters:
/// * [child] - The icon widget to display
/// * [position] - Current position in local coordinates
/// * [size] - Base size of the icon
/// * [isLifted] - Whether the icon is in lifted (dragging) state
/// * [isRemoving] - Whether the icon is in remove mode
///
/// References:
/// * Technical specs: LIFT_HEIGHT (12-20px), LIFT_SCALE (1.05-1.10)
/// * Animation timing: LIFT_DURATION (100-150ms)
///
/// Example:
/// ```dart
/// DraggedIconOverlay(
///   child: Icon(Icons.folder),
///   position: Offset(100, 50),
///   size: 48.0,
///   isLifted: true,
///   isRemoving: false,
/// )
/// ```
class DraggedIconOverlay extends StatelessWidget {
  /// Creates a dragged icon overlay widget.
  const DraggedIconOverlay({
    required this.child,
    required this.position,
    required this.size,
    this.isLifted = false,
    this.isRemoving = false,
    this.isReturning = false,
    this.initialScale = 1.0,
    this.returnDuration = const Duration(milliseconds: 300),
    super.key,
  });

  /// The icon widget to display.
  final Widget child;

  /// Current position in local coordinates.
  ///
  /// This should be the cursor position converted to the coordinate
  /// system of the parent widget, with the icon centered on the cursor
  /// by subtracting half the icon width and height.
  final Offset position;

  /// Base size of the icon in logical pixels.
  final double size;

  /// The magnification scale at the moment the icon was grabbed.
  final double initialScale;

  /// Whether the icon is in lifted (dragging) state.
  ///
  /// When true, applies lift transformation (scale and vertical offset).
  final bool isLifted;

  /// Whether the icon is in remove mode.
  ///
  /// When true, reduces opacity to indicate the icon will be removed.
  final bool isRemoving;

  /// Whether the icon is returning to its position after drop.
  ///
  /// When true, animates to target position with smooth descent.
  final bool isReturning;

  /// Duration for return animation.
  final Duration returnDuration;

  static const double _liftHeight = 16; // 12-20px range
  static const double _liftScale = 1.08; // 1.05-1.10 range
  static const Duration _liftDuration = Duration(milliseconds: 120);

  @override
  Widget build(BuildContext context) {
    // Use longer duration for return animation
    final duration = isReturning ? returnDuration : _liftDuration;

    return AnimatedPositioned(
      left: position.dx,
      top: position.dy,
      duration: duration,
      curve: Curves.easeOut,
      child: AnimatedContainer(
        duration: duration,
        curve: Curves.easeOut,
        transform: (isLifted && !isReturning)
            ? (Matrix4.identity()
              // Using deprecated methods for simplicity
              // ignore: deprecated_member_use
              ..translate(0.0, -_liftHeight)
              // Using deprecated method for simplicity
              // ignore: deprecated_member_use
              ..scale(initialScale * _liftScale))
            : Matrix4.identity(),
        transformAlignment: Alignment.center,
        child: AnimatedOpacity(
          duration: duration,
          opacity: isRemoving ? 0.5 : (isReturning ? 1.0 : 0.95),
          child: SizedBox(
            key: const ValueKey('dragged_icon_size_box'),
            width: size,
            height: size,
            child: child,
          ),
        ),
      ),
    );
  }
}
