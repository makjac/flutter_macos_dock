import 'package:flutter/material.dart';
import 'package:flutter_macos_dock/src/enums/dock_position.dart';
import 'package:flutter_macos_dock/src/models/dock_item.dart';

/// A widget that displays a macOS-style dock.
///
/// This widget replicates the appearance of the macOS dock,
/// rendering icons in a horizontal or vertical layout based on
/// the specified position.
///
/// The layout direction is automatically determined by [position]:
/// * [DockPosition.bottom] and [DockPosition.top] use horizontal layout
/// * [DockPosition.left] and [DockPosition.right] use vertical layout
///
/// Parameters:
/// * [items] - List of dock items to display
/// * [position] - Position of the dock on screen
/// * [size] - Base size of dock icons in logical pixels
///
/// References:
/// * [DockItem] for item configuration
/// * [DockPosition] for available positions
///
/// Example:
/// ```dart
/// MacDock(
///   items: [
///     DockItem(
///       id: 'finder',
///       icon: Icon(Icons.folder),
///       tooltip: 'Finder',
///     ),
///     DockItem(
///       id: 'mail',
///       icon: Icon(Icons.mail),
///       tooltip: 'Mail',
///     ),
///   ],
///   position: DockPosition.bottom,
///   size: 48.0,
/// )
/// ```
class MacDock extends StatelessWidget {
  /// Creates a macOS-style dock widget.
  const MacDock({
    required this.items,
    this.position = DockPosition.bottom,
    this.size = 48.0,
    super.key,
  });

  /// List of dock items to display.
  final List<DockItem> items;

  /// Position of the dock on screen.
  ///
  /// Defaults to [DockPosition.bottom].
  final DockPosition position;

  /// Base size of dock icons in logical pixels.
  ///
  /// Defaults to 48.0.
  final double size;

  bool get _isHorizontal =>
      position == DockPosition.bottom || position == DockPosition.top;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    final children = items.map((item) {
      return GestureDetector(
        onTap: item.onTap,
        child: SizedBox(
          width: size,
          height: size,
          child: item.icon,
        ),
      );
    }).toList();

    return _isHorizontal
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: children,
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: children,
          );
  }
}
