import 'dart:math' as math;
import 'dart:ui';

/// A utility class for calculating icon magnification scales based on cursor
/// position.
///
/// This class provides methods to calculate how much each icon should be
/// magnified based on the distance between the cursor and the icon's center.
/// The magnification follows a distance-based algorithm with smooth linear
/// falloff within a configurable radius.
///
/// The calculation uses Euclidean distance and applies linear interpolation
/// to create a smooth magnification effect that feels natural and
/// responsive.
///
/// References:
/// * [calculateScale] for single icon scale calculation
/// * [calculateScales] for batch calculation of multiple icons
///
/// Example:
/// ```dart
/// final scale = MagnificationCalculator.calculateScale(
///   cursorPosition: Offset(100, 50),
///   iconCenter: Offset(120, 50),
///   magnificationStrength: 2.0,
///   magnificationRadius: 100.0,
/// );
/// // Returns a value between 1.0 and 2.0 based on distance
/// ```
class MagnificationCalculator {
  /// Calculates the magnification scale for a single icon based on cursor
  /// position.
  ///
  /// The scale is calculated using the Euclidean distance between the cursor
  /// and icon center. Icons within the [magnificationRadius] are magnified
  /// with a smooth linear falloff. Icons beyond the radius maintain their
  /// normal size (scale = 1.0).
  ///
  /// Formula:
  /// ```dart
  /// distance = sqrt((cursorX - iconX)² + (cursorY - iconY)²)
  /// if distance > radius: scale = 1.0
  /// else: scale = 1.0 + (strength - 1.0) * (1.0 - distance / radius)
  /// ```
  ///
  /// Parameters:
  /// * [cursorPosition] - The current cursor position in logical pixels.
  ///   If null, returns 1.0 (no magnification).
  /// * [iconCenter] - The center position of the icon in logical pixels.
  /// * [magnificationStrength] - Maximum magnification scale (e.g., 2.0 for
  ///   2x size). Must be >= 1.0. A value of 1.0 disables magnification.
  /// * [magnificationRadius] - The radius in logical pixels within which
  ///   magnification is applied. Must be > 0.
  ///
  /// Returns:
  /// * A scale value clamped between 1.0 and [magnificationStrength].
  ///
  /// References:
  /// * [calculateScales] for calculating multiple icons at once
  ///
  /// Example:
  /// ```dart
  /// // Cursor directly on icon center
  /// final maxScale = MagnificationCalculator.calculateScale(
  ///   cursorPosition: Offset(100, 50),
  ///   iconCenter: Offset(100, 50),
  ///   magnificationStrength: 2.0,
  ///   magnificationRadius: 100.0,
  /// );
  /// // Returns 2.0 (maximum magnification)
  ///
  /// // Cursor at edge of radius
  /// final minScale = MagnificationCalculator.calculateScale(
  ///   cursorPosition: Offset(200, 50),
  ///   iconCenter: Offset(100, 50),
  ///   magnificationStrength: 2.0,
  ///   magnificationRadius: 100.0,
  /// );
  /// // Returns 1.0 (no magnification)
  /// ```
  static double calculateScale({
    required Offset? cursorPosition,
    required Offset iconCenter,
    required double magnificationStrength,
    required double magnificationRadius,
  }) {
    // No magnification when cursor is not hovering
    if (cursorPosition == null) {
      return 1;
    }

    // No magnification if strength is 1.0 or less
    if (magnificationStrength <= 1) {
      return 1;
    }

    // Calculate Euclidean distance from cursor to icon center
    final dx = cursorPosition.dx - iconCenter.dx;
    final dy = cursorPosition.dy - iconCenter.dy;
    final distance = math.sqrt(dx * dx + dy * dy);

    // No magnification beyond radius
    if (distance >= magnificationRadius) {
      return 1;
    }

    // Linear interpolation within radius
    // normalized = 1.0 at center, 0.0 at radius edge
    final normalized = 1 - (distance / magnificationRadius);

    // Calculate scale with smooth falloff
    final scale = 1 + (magnificationStrength - 1) * normalized;

    // Clamp to valid range
    return scale.clamp(1, magnificationStrength);
  }

  /// Calculates magnification scales for multiple icons at once.
  ///
  /// This method efficiently calculates the scale for each icon based on
  /// cursor position. It's optimized for rendering multiple dock icons
  /// simultaneously.
  ///
  /// Parameters:
  /// * [cursorPosition] - The current cursor position in logical pixels.
  ///   If null, returns a list of 1.0 values (no magnification).
  /// * [iconCenters] - List of icon center positions in logical pixels.
  /// * [magnificationStrength] - Maximum magnification scale. Must be >= 1.0.
  /// * [magnificationRadius] - The radius within which magnification is
  ///   applied. Must be > 0.
  ///
  /// Returns:
  /// * A list of scale values, one for each icon in [iconCenters].
  ///   Each value is clamped between 1.0 and [magnificationStrength].
  ///
  /// References:
  /// * [calculateScale] for single icon calculation details
  ///
  /// Example:
  /// ```dart
  /// final scales = MagnificationCalculator.calculateScales(
  ///   cursorPosition: Offset(150, 50),
  ///   iconCenters: [
  ///     Offset(100, 50),
  ///     Offset(150, 50),
  ///     Offset(200, 50),
  ///   ],
  ///   magnificationStrength: 2.0,
  ///   magnificationRadius: 100.0,
  /// );
  /// // Returns [1.5, 2.0, 1.5] - center icon at max, others scaled by
  /// // distance
  /// ```
  static List<double> calculateScales({
    required Offset? cursorPosition,
    required List<Offset> iconCenters,
    required double magnificationStrength,
    required double magnificationRadius,
  }) {
    return iconCenters
        .map(
          (center) => calculateScale(
            cursorPosition: cursorPosition,
            iconCenter: center,
            magnificationStrength: magnificationStrength,
            magnificationRadius: magnificationRadius,
          ),
        )
        .toList();
  }
}
