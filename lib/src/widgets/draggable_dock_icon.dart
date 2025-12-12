import 'package:flutter/material.dart';
import 'package:flutter_macos_dock/src/models/dock_item.dart';

/// A widget that displays a draggable dock icon with threshold detection.
///
/// This widget extends dock icon functionality with drag-and-drop support.
/// It implements threshold-based drag detection using both distance and
/// time criteria to differentiate between clicks and drag operations.
///
/// Drag detection requires either:
/// * Movement of 4 pixels or more from initial press position
/// * Hold time of 150 milliseconds or more
///
/// Once drag threshold is met, the widget transitions from detecting to
/// dragging state and invokes the appropriate callbacks.
///
/// Parameters:
/// * [item] - The dock item containing icon and interaction callbacks
/// * [size] - Base size of the icon in logical pixels
/// * [scale] - Magnification scale factor
/// * [animationDuration] - Duration for scale animation transitions
/// * [isDragging] - Whether this icon is currently being dragged
/// * [onDragStart] - Called when drag threshold is exceeded
/// * [onDragUpdate] - Called on each cursor movement during drag
/// * [onDragEnd] - Called when drag operation completes
/// * [onHoverEnter] - Called when mouse enters icon area
/// * [onHoverExit] - Called when mouse exits icon area
///
/// References:
/// * Technical specs: DRAG_DISTANCE_THRESHOLD (4px)
/// * Technical specs: DRAG_TIME_THRESHOLD (150ms)
///
/// Example:
/// ```dart
/// DraggableDockIcon(
///   item: DockItem(
///     id: 'finder',
///     icon: Icon(Icons.folder),
///   ),
///   size: 48.0,
///   scale: 1.0,
///   isDragging: false,
///   onDragStart: () => print('Drag started'),
///   onDragUpdate: (details) => print('Drag at ${details.globalPosition}'),
///   onDragEnd: (details) => print('Drag ended'),
/// )
/// ```
class DraggableDockIcon extends StatefulWidget {
  /// Creates a draggable dock icon widget.
  const DraggableDockIcon({
    required this.item,
    required this.size,
    required this.scale,
    this.animationDuration = const Duration(milliseconds: 200),
    this.isDragging = false,
    this.onDragStart,
    this.onDragUpdate,
    this.onDragEnd,
    this.onHoverEnter,
    this.onHoverExit,
    super.key,
  });

  /// The dock item containing icon and interaction callbacks.
  final DockItem item;

  /// Base size of the icon in logical pixels.
  final double size;

  /// Magnification scale factor.
  final double scale;

  /// Duration for scale animation transitions.
  final Duration animationDuration;

  /// Whether this icon is currently being dragged.
  ///
  /// When true, the icon is hidden from its normal position as it's
  /// rendered in the overlay instead.
  final bool isDragging;

  /// Callback invoked when drag threshold is exceeded.
  final VoidCallback? onDragStart;

  /// Callback invoked on each cursor movement during drag.
  final void Function(DragUpdateDetails)? onDragUpdate;

  /// Callback invoked when drag operation completes.
  final void Function(DragEndDetails)? onDragEnd;

  /// Callback invoked when mouse enters the icon area.
  final VoidCallback? onHoverEnter;

  /// Callback invoked when mouse exits the icon area.
  final VoidCallback? onHoverExit;

  @override
  State<DraggableDockIcon> createState() => _DraggableDockIconState();
}

class _DraggableDockIconState extends State<DraggableDockIcon> {
  static const double _dragDistanceThreshold = 4; // pixels
  static const Duration _dragTimeThreshold = Duration(milliseconds: 150);

  Offset? _dragStartPosition;
  DateTime? _dragStartTime;
  bool _isDragDetecting = false;

  bool _checkDragThreshold(Offset currentPosition) {
    if (_dragStartPosition == null || _dragStartTime == null) {
      return false;
    }

    // Check distance threshold
    final distance = (currentPosition - _dragStartPosition!).distance;
    if (distance > _dragDistanceThreshold) {
      return true;
    }

    // Check time threshold
    final elapsed = DateTime.now().difference(_dragStartTime!);
    if (elapsed >= _dragTimeThreshold) {
      return true;
    }

    return false;
  }

  void _handlePanStart(DragStartDetails details) {
    setState(() {
      _dragStartPosition = details.globalPosition;
      _dragStartTime = DateTime.now();
      _isDragDetecting = true;
    });
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    if (!_isDragDetecting) {
      widget.onDragUpdate?.call(details);
      return;
    }

    // Check if drag threshold is met
    if (_checkDragThreshold(details.globalPosition)) {
      setState(() {
        _isDragDetecting = false;
      });
      widget.onDragStart?.call();
    }

    // Always call update after threshold is met
    if (!_isDragDetecting) {
      widget.onDragUpdate?.call(details);
    }
  }

  void _handlePanEnd(DragEndDetails details) {
    if (!_isDragDetecting) {
      widget.onDragEnd?.call(details);
    }

    setState(() {
      _dragStartPosition = null;
      _dragStartTime = null;
      _isDragDetecting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => widget.onHoverEnter?.call(),
      onExit: (_) => widget.onHoverExit?.call(),
      child: GestureDetector(
        onTap: widget.item.onTap,
        onPanStart: _handlePanStart,
        onPanUpdate: _handlePanUpdate,
        onPanEnd: _handlePanEnd,
        child: AnimatedOpacity(
          opacity: widget.isDragging ? 0.0 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: AnimatedScale(
            scale: widget.scale,
            duration: widget.animationDuration,
            curve: Curves.easeOutCubic,
            child: SizedBox(
              key: const ValueKey('dock_icon_size_box'),
              width: widget.size,
              height: widget.size,
              child: widget.item.icon,
            ),
          ),
        ),
      ),
    );
  }
}
