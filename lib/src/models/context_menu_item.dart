import 'package:flutter/material.dart';

/// An item in a context menu displayed for a dock icon.
///
/// Context menus are triggered by long press or right-click on dock icons
/// and provide quick access to common actions.
///
/// Parameters:
/// * [label] - Display text for the menu item
/// * [onTap] - Callback executed when the menu item is selected
/// * [icon] - Optional icon widget displayed next to the label
///
/// Example:
/// ```dart
/// ContextMenuItem(
///   label: 'Open',
///   icon: Icon(Icons.open_in_new),
///   onTap: () {
///     print('Open action triggered');
///   },
/// )
/// ```
@immutable
class ContextMenuItem {
  /// Creates a context menu item.
  const ContextMenuItem({
    required this.label,
    required this.onTap,
    this.icon,
  });

  /// Display text for the menu item.
  final String label;

  /// Callback executed when the menu item is selected.
  final VoidCallback onTap;

  /// Optional icon widget displayed next to the label.
  final Widget? icon;

  /// Creates a copy of this context menu item with the given fields
  /// replaced with new values.
  ContextMenuItem copyWith({
    String? label,
    VoidCallback? onTap,
    Widget? icon,
  }) {
    return ContextMenuItem(
      label: label ?? this.label,
      onTap: onTap ?? this.onTap,
      icon: icon ?? this.icon,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ContextMenuItem &&
        other.label == label &&
        other.onTap == onTap &&
        other.icon == icon;
  }

  @override
  int get hashCode {
    return Object.hash(label, onTap, icon);
  }
}
