import 'package:flutter/material.dart';

/// Configuration for a badge displayed on a dock icon.
///
/// A badge can display either a numerical count or a text label,
/// typically used to show notifications, unread messages, or other
/// status information on dock icons.
///
/// Either [text] or [count] should be provided, not both. If both are
/// provided, [text] takes precedence.
///
/// Parameters:
/// * [text] - Optional text label for the badge
/// * [count] - Optional numerical count to display
/// * [backgroundColor] - Background color of the badge
/// * [textColor] - Text color for the badge content
///
/// Example:
/// ```dart
/// DockBadge(
///   count: 5,
///   backgroundColor: Colors.red,
///   textColor: Colors.white,
/// )
/// ```
///
/// Example with text:
/// ```dart
/// DockBadge(
///   text: 'New',
///   backgroundColor: Colors.blue,
/// )
/// ```
@immutable
class DockBadge {
  /// Creates a dock badge with optional text or count.
  const DockBadge({
    this.text,
    this.count,
    this.backgroundColor,
    this.textColor,
  });

  /// Text label to display in the badge.
  ///
  /// If both [text] and [count] are provided, [text] takes precedence.
  final String? text;

  /// Numerical count to display in the badge.
  ///
  /// If both [text] and [count] are provided, [text] takes precedence.
  final int? count;

  /// Background color of the badge.
  ///
  /// If null, a default color will be used by the badge renderer.
  final Color? backgroundColor;

  /// Text color for the badge content.
  ///
  /// If null, a default color will be used by the badge renderer.
  final Color? textColor;

  /// Creates a copy of this badge with the given fields replaced
  /// with new values.
  DockBadge copyWith({
    String? text,
    int? count,
    Color? backgroundColor,
    Color? textColor,
  }) {
    return DockBadge(
      text: text ?? this.text,
      count: count ?? this.count,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DockBadge &&
        other.text == text &&
        other.count == count &&
        other.backgroundColor == backgroundColor &&
        other.textColor == textColor;
  }

  @override
  int get hashCode {
    return Object.hash(
      text,
      count,
      backgroundColor,
      textColor,
    );
  }
}
