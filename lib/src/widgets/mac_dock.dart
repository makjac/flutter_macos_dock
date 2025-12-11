import 'package:flutter/material.dart';
import 'package:flutter_macos_dock/src/enums/dock_position.dart';
import 'package:flutter_macos_dock/src/models/dock_item.dart';
import 'package:flutter_macos_dock/src/utils/magnification_calculator.dart';
import 'package:flutter_macos_dock/src/widgets/dock_icon.dart';

/// A widget that displays a macOS-style dock with magnification effect.
///
/// This widget replicates the appearance and behavior of the macOS dock,
/// rendering icons in a horizontal or vertical layout based on the
/// specified position. Icons magnify smoothly when the cursor hovers
/// over them, creating an interactive and visually appealing effect.
///
/// The layout direction is automatically determined by [position]:
/// * [DockPosition.bottom] and [DockPosition.top] use horizontal layout
/// * [DockPosition.left] and [DockPosition.right] use vertical layout
///
/// Magnification is controlled by [magnification] strength and applies
/// to icons within [magnificationRadius] of the cursor. Set
/// [magnification] to 1.0 to disable the effect.
///
/// Parameters:
/// * [items] - List of dock items to display
/// * [position] - Position of the dock on screen
/// * [size] - Base size of dock icons in logical pixels
/// * [magnification] - Maximum magnification scale (1.0 = disabled, 2.0 = 2x)
/// * [magnificationRadius] - Radius in pixels for magnification effect
/// * [magnificationAnimationDuration] - Duration for magnification animation
///
/// References:
/// * [DockItem] for item configuration
/// * [DockPosition] for available positions
/// * [MagnificationCalculator] for scale calculation details
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
///   magnification: 2.0,
///   magnificationRadius: 100.0,
/// )
/// ```
class MacDock extends StatefulWidget {
  /// Creates a macOS-style dock widget.
  const MacDock({
    required this.items,
    this.position = DockPosition.bottom,
    this.size = 48.0,
    this.magnification = 1.0,
    this.magnificationRadius = 100.0,
    this.magnificationAnimationDuration = const Duration(milliseconds: 200),
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

  /// Maximum magnification scale for icons.
  ///
  /// A value of 1.0 disables magnification. Values greater than 1.0
  /// magnify icons when the cursor hovers over them. For example,
  /// 2.0 doubles the icon size at the cursor position.
  ///
  /// Defaults to 1.0 (no magnification).
  final double magnification;

  /// Radius in logical pixels within which magnification is applied.
  ///
  /// Icons within this distance from the cursor will be magnified
  /// with a smooth falloff. Icons beyond this radius maintain their
  /// normal size.
  ///
  /// Defaults to 100.0.
  final double magnificationRadius;

  /// Duration for magnification animation transitions.
  ///
  /// Controls how quickly icons scale when the cursor moves over them.
  ///
  /// Defaults to 200 milliseconds.
  final Duration magnificationAnimationDuration;

  @override
  State<MacDock> createState() => _MacDockState();
}

class _MacDockState extends State<MacDock> {
  Offset? _cursorPosition;
  final List<GlobalKey> _iconKeys = [];

  @override
  void initState() {
    super.initState();
    _initializeKeys();
  }

  @override
  void didUpdateWidget(MacDock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items.length != widget.items.length) {
      _initializeKeys();
    }
  }

  void _initializeKeys() {
    _iconKeys.clear();
    for (var i = 0; i < widget.items.length; i++) {
      _iconKeys.add(GlobalKey());
    }
  }

  bool get _isHorizontal =>
      widget.position == DockPosition.bottom ||
      widget.position == DockPosition.top;

  List<Offset> _calculateIconCenters() {
    final centers = <Offset>[];
    for (final key in _iconKeys) {
      final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null && renderBox.hasSize) {
        final position = renderBox.localToGlobal(Offset.zero);
        final center = position +
            Offset(
              renderBox.size.width / 2,
              renderBox.size.height / 2,
            );
        centers.add(center);
      } else {
        centers.add(Offset.zero);
      }
    }
    return centers;
  }

  List<Widget> _buildIconsWithMagnification() {
    final iconCenters = _calculateIconCenters();
    final scales = MagnificationCalculator.calculateScales(
      cursorPosition: _cursorPosition,
      iconCenters: iconCenters,
      magnificationStrength: widget.magnification,
      magnificationRadius: widget.magnificationRadius,
    );

    return List.generate(widget.items.length, (index) {
      return Container(
        key: _iconKeys[index],
        child: DockIcon(
          item: widget.items[index],
          size: widget.size,
          scale: scales[index],
          animationDuration: widget.magnificationAnimationDuration,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return const SizedBox.shrink();
    }

    final children = _buildIconsWithMagnification();

    return MouseRegion(
      onHover: (event) {
        setState(() {
          _cursorPosition = event.position;
        });
      },
      onExit: (_) {
        setState(() {
          _cursorPosition = null;
        });
      },
      child: _isHorizontal
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: children,
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: children,
            ),
    );
  }
}
