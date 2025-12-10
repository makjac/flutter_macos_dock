import 'package:flutter/material.dart';
import 'package:flutter_macos_dock/src/models/context_menu_item.dart';
import 'package:flutter_macos_dock/src/models/dock_badge.dart';

/// An item displayed in the dock.
///
/// Each dock item represents an application or action with an icon,
/// optional tooltip, callbacks, and visual indicators.
///
/// Parameters:
/// * [id] - Unique identifier for the dock item
/// * [icon] - Widget representing the icon
/// * [tooltip] - Optional text displayed on hover
/// * [onTap] - Optional callback executed when the icon is tapped
/// * [onRemove] - Optional callback executed when dragged outside dock
/// * [contextMenuItems] - Optional list of context menu items
/// * [badge] - Optional badge displayed on the icon
/// * [showIndicator] - Whether to show open application indicator
/// * [data] - Optional custom data associated with this item
///
/// References:
/// * [DockBadge] for badge configuration
/// * [ContextMenuItem] for context menu configuration
///
/// Example:
/// ```dart
/// DockItem(
///   id: 'finder',
///   icon: Icon(Icons.folder),
///   tooltip: 'Finder',
///   showIndicator: true,
///   onTap: () {
///     print('Finder opened');
///   },
/// )
/// ```
///
/// Example with badge:
/// ```dart
/// DockItem(
///   id: 'mail',
///   icon: Icon(Icons.mail),
///   tooltip: 'Mail',
///   badge: DockBadge(count: 5),
/// )
/// ```
@immutable
class DockItem {
  /// Creates a dock item with the specified configuration.
  const DockItem({
    required this.id,
    required this.icon,
    this.tooltip,
    this.onTap,
    this.onRemove,
    this.contextMenuItems,
    this.badge,
    this.showIndicator = false,
    this.data,
  });

  /// Unique identifier for the dock item.
  final String id;

  /// Widget representing the icon.
  final Widget icon;

  /// Optional text displayed on hover.
  final String? tooltip;

  /// Optional callback executed when the icon is tapped.
  final VoidCallback? onTap;

  /// Optional callback executed when icon is dragged outside dock bounds.
  final VoidCallback? onRemove;

  /// Optional list of context menu items.
  ///
  /// Context menus are triggered by long press or right-click.
  final List<ContextMenuItem>? contextMenuItems;

  /// Optional badge displayed on the icon.
  final DockBadge? badge;

  /// Whether to show the open application indicator.
  ///
  /// When true, displays a dot indicator below the icon.
  final bool showIndicator;

  /// Optional custom data associated with this item.
  ///
  /// Can be used to store any application-specific data.
  final dynamic data;

  /// Creates a copy of this dock item with the given fields replaced
  /// with new values.
  DockItem copyWith({
    String? id,
    Widget? icon,
    String? tooltip,
    VoidCallback? onTap,
    VoidCallback? onRemove,
    List<ContextMenuItem>? contextMenuItems,
    DockBadge? badge,
    bool? showIndicator,
    dynamic data,
  }) {
    return DockItem(
      id: id ?? this.id,
      icon: icon ?? this.icon,
      tooltip: tooltip ?? this.tooltip,
      onTap: onTap ?? this.onTap,
      onRemove: onRemove ?? this.onRemove,
      contextMenuItems: contextMenuItems ?? this.contextMenuItems,
      badge: badge ?? this.badge,
      showIndicator: showIndicator ?? this.showIndicator,
      data: data ?? this.data,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DockItem &&
        other.id == id &&
        other.icon == icon &&
        other.tooltip == tooltip &&
        other.onTap == onTap &&
        other.onRemove == onRemove &&
        _listEquals(other.contextMenuItems, contextMenuItems) &&
        other.badge == badge &&
        other.showIndicator == showIndicator &&
        other.data == data;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      icon,
      tooltip,
      onTap,
      onRemove,
      Object.hashAll(contextMenuItems ?? []),
      badge,
      showIndicator,
      data,
    );
  }

  bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
