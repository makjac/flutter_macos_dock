import 'package:flutter/material.dart';

/// Calculates icon reordering positions during drag operations.
///
/// This utility class implements the swap algorithm for determining when
/// icons should be reordered during drag and drop. It uses a 50% threshold
/// with hysteresis to prevent flickering when the dragged icon crosses
/// the center of other icons.
///
/// The algorithm tracks the last swap direction to implement hysteresis,
/// ensuring smooth and stable reordering behavior that matches macOS dock
/// behavior.
///
/// The calculator provides methods to:
/// - Calculate new icon positions during drag
/// - Determine swap thresholds with hysteresis
/// - Compute icon offsets for gap animations
/// - Detect when drag is outside dock bounds
///
/// References:
/// * Technical specs: SWAP_THRESHOLD (0.5), HYSTERESIS (0.05)
///
/// Example:
/// ```dart
/// final calculator = ReorderCalculator();
/// final newIndex = calculator.calculateNewIndex(
///   iconPositions: positions,
///   iconSize: 48.0,
///   draggedIndex: 2,
///   dragPosition: Offset(150, 20),
/// );
/// ```
class ReorderCalculator {
  /// Creates a reorder calculator instance.
  const ReorderCalculator();

  /// Swap threshold as percentage of icon width.
  ///
  /// Icons swap when the dragged icon center crosses 50% of the
  /// target icon's width.
  static const double swapThreshold = 0.5;

  /// Hysteresis value to prevent swap flickering.
  ///
  /// Adds 5% of icon width to the swap threshold in the direction
  /// of the last swap to prevent rapid back-and-forth swapping.
  static const double hysteresis = 0.05;

  /// Exit threshold in pixels from dock edge for remove mode.
  ///
  /// When the dragged icon moves this distance beyond the dock bounds,
  /// it enters remove mode.
  static const double exitThreshold = 60;

  /// Calculates the new index position for a dragged icon.
  ///
  /// Determines where the dragged icon should be placed based on its
  /// current position relative to other icons. Uses 50% threshold with
  /// hysteresis to prevent flickering during reordering.
  ///
  /// Parameters:
  /// * [iconPositions] - List of icon center positions
  /// * [iconSize] - Base size of icons in logical pixels
  /// * [draggedIndex] - Current index of the dragged icon
  /// * [dragPosition] - Current position of the dragged icon center
  /// * [lastSwapDirection] - Last swap direction ('left', 'right', or null)
  /// * [isHorizontal] - True for horizontal layout, false for vertical
  ///
  /// Returns the new index where the icon should be placed.
  int calculateNewIndex({
    required List<Offset> iconPositions,
    required double iconSize,
    required int draggedIndex,
    required Offset dragPosition,
    String? lastSwapDirection,
    bool isHorizontal = true,
  }) {
    if (iconPositions.isEmpty) return 0;

    // Use appropriate coordinate based on orientation
    final draggedCenter = isHorizontal ? dragPosition.dx : dragPosition.dy;

    // For each icon, check if we should take its position
    for (var i = 0; i < iconPositions.length; i++) {
      if (i == draggedIndex) continue;

      final targetCenter =
          isHorizontal ? iconPositions[i].dx : iconPositions[i].dy;
      final halfWidth = iconSize * swapThreshold;

      // Calculate threshold with hysteresis
      var threshold = halfWidth;
      if (lastSwapDirection == 'left' && i < draggedIndex) {
        threshold -= iconSize * hysteresis;
      } else if (lastSwapDirection == 'right' && i > draggedIndex) {
        threshold -= iconSize * hysteresis;
      }

      // Check if dragged icon has crossed the swap threshold
      if (i < draggedIndex) {
        // Moving left: swap when dragged center crosses left of
        // (target + threshold)
        if (draggedCenter <= targetCenter + threshold) {
          return i;
        }
      } else {
        // Moving right: swap when dragged center crosses right of
        // (target + threshold)
        if (draggedCenter >= targetCenter + threshold) {
          return i;
        }
      }
    }

    return draggedIndex;
  }

  /// Calculates the gap position for icon reordering animation.
  ///
  /// Determines the horizontal offset each icon should have to create
  /// a gap at the target drop position during drag operations.
  ///
  /// Parameters:
  /// * [iconIndex] - Index of the icon to calculate offset for
  /// * [draggedIndex] - Index of the currently dragged icon
  /// * [targetIndex] - Target index where the gap should appear
  /// * [iconSize] - Base size of icons in logical pixels
  /// * [spacing] - Spacing between icons in logical pixels
  ///
  /// Returns the horizontal offset for the icon.
  double calculateIconOffset({
    required int iconIndex,
    required int draggedIndex,
    required int targetIndex,
    required double iconSize,
    required double spacing,
  }) {
    // The dragged icon doesn't participate in the gap
    if (iconIndex == draggedIndex) return 0;

    final gapWidth = iconSize + spacing;

    // Moving left: create gap by shifting icons right
    if (targetIndex < draggedIndex) {
      if (iconIndex >= targetIndex && iconIndex < draggedIndex) {
        return gapWidth;
      }
    }
    // Moving right: create gap by shifting icons left
    else if (targetIndex > draggedIndex) {
      if (iconIndex > draggedIndex && iconIndex <= targetIndex) {
        return -gapWidth;
      }
    }

    return 0;
  }

  /// Checks if the dragged icon is outside dock bounds for removal.
  ///
  /// Determines whether the icon has moved far enough from the dock
  /// edge to trigger remove mode based on the exit threshold.
  ///
  /// Parameters:
  /// * [dragPosition] - Current position of the dragged icon
  /// * [dockBounds] - Bounding rectangle of the dock
  /// * [dockPosition] - Position of the dock (bottom, top, left, right)
  ///
  /// Returns true if the icon is outside the exit threshold.
  bool isOutsideDock({
    required Offset dragPosition,
    required Rect dockBounds,
    required String dockPosition,
  }) {
    switch (dockPosition) {
      case 'bottom':
        return dragPosition.dy < dockBounds.top - exitThreshold;
      case 'top':
        return dragPosition.dy > dockBounds.bottom + exitThreshold;
      case 'left':
        return dragPosition.dx > dockBounds.right + exitThreshold;
      case 'right':
        return dragPosition.dx < dockBounds.left - exitThreshold;
      default:
        return false;
    }
  }
}
