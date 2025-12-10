import 'package:flutter/material.dart';
import 'package:flutter_macos_dock/src/models/dock_item.dart';

/// A widget that displays a single dock icon with hover detection and
/// magnification animation.
///
/// This widget wraps a dock item's icon with hover detection using
/// [MouseRegion] and applies smooth scale animation using [AnimatedScale].
/// It handles tap gestures and provides callbacks for hover enter/exit
/// events.
///
/// The icon is rendered at [size] dimensions and scaled by [scale] factor.
/// Scale animation uses the specified [animationDuration] and a smooth
/// easing curve for natural motion.
///
/// Parameters:
/// * [item] - The dock item containing icon and interaction callbacks
/// * [size] - Base size of the icon in logical pixels (width and height)
/// * [scale] - Magnification scale factor (1.0 = normal, >1.0 = magnified)
/// * [animationDuration] - Duration for scale animation transitions
/// * [onHoverEnter] - Called when mouse enters icon area
/// * [onHoverExit] - Called when mouse exits icon area
///
/// Example:
/// ```dart
/// DockIcon(
///   item: DockItem(
///     id: 'finder',
///     icon: Icon(Icons.folder),
///     onTap: () => print('Tapped'),
///   ),
///   size: 48.0,
///   scale: 1.5,
///   animationDuration: Duration(milliseconds: 200),
///   onHoverEnter: () => print('Hover enter'),
///   onHoverExit: () => print('Hover exit'),
/// )
/// ```
class DockIcon extends StatelessWidget {
  /// Creates a dock icon widget.
  ///
  /// The [item], [size], and [scale] parameters are required.
  const DockIcon({
    required this.item,
    required this.size,
    required this.scale,
    super.key,
    this.animationDuration = const Duration(milliseconds: 200),
    this.onHoverEnter,
    this.onHoverExit,
  });

  /// The dock item containing icon and interaction callbacks.
  final DockItem item;

  /// Base size of the icon in logical pixels.
  ///
  /// This defines both width and height of the icon container before
  /// magnification is applied.
  final double size;

  /// Magnification scale factor.
  ///
  /// A value of 1.0 represents normal size, values greater than 1.0
  /// magnify the icon. For example, 2.0 doubles the icon size.
  final double scale;

  /// Duration for scale animation transitions.
  ///
  /// Default is 200 milliseconds for smooth, responsive animations.
  final Duration animationDuration;

  /// Callback invoked when mouse enters the icon area.
  final VoidCallback? onHoverEnter;

  /// Callback invoked when mouse exits the icon area.
  final VoidCallback? onHoverExit;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => onHoverEnter?.call(),
      onExit: (_) => onHoverExit?.call(),
      child: GestureDetector(
        onTap: item.onTap,
        child: AnimatedScale(
          scale: scale,
          duration: animationDuration,
          curve: Curves.easeOutCubic,
          child: SizedBox(
            width: size,
            height: size,
            child: item.icon,
          ),
        ),
      ),
    );
  }
}
