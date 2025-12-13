import 'package:flutter/material.dart';
import 'package:flutter_macos_dock/src/enums/dock_position.dart';
import 'package:flutter_macos_dock/src/models/dock_item.dart';
import 'package:flutter_macos_dock/src/models/drag_state.dart';
import 'package:flutter_macos_dock/src/utils/magnification_calculator.dart';
import 'package:flutter_macos_dock/src/utils/reorder_calculator.dart';
import 'package:flutter_macos_dock/src/widgets/draggable_dock_icon.dart';
import 'package:flutter_macos_dock/src/widgets/dragged_icon_overlay.dart';

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
    this.liftStrength = 0.5,
    this.magnificationAnimationDuration = const Duration(milliseconds: 200),
    this.reorderAnimationDuration = const Duration(milliseconds: 220),
    this.returnAnimationDuration = const Duration(milliseconds: 300),
    this.onReorder,
    this.onRemove,
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

  /// Strength of the lift effect during magnification.
  ///
  /// Controls how much icons move towards the cursor when magnified.
  /// A value of 0.0 disables the lift effect. A value of 1.0 means icons
  /// will lift by the full amount of their size increase.
  ///
  /// Defaults to 0.5 (50% of size increase).
  final double liftStrength;

  /// Duration for magnification animation transitions.
  ///
  /// Controls how quickly icons scale when the cursor moves over them.
  ///
  /// Defaults to 200 milliseconds.
  final Duration magnificationAnimationDuration;

  /// Duration for reordering animation transitions.
  ///
  /// Controls the speed of icon repositioning during drag and drop.
  ///
  /// Defaults to 220 milliseconds.
  final Duration reorderAnimationDuration;

  /// Duration for return animation when dropping items.
  ///
  /// Controls how quickly the dragged icon returns to its position.
  ///
  /// Defaults to 300 milliseconds.
  final Duration returnAnimationDuration;

  /// Callback invoked when an icon is reordered in the dock.
  ///
  /// Called when the user drags an icon to a new position and releases it.
  /// Parameters are the old index and new index of the moved item.
  final void Function(int oldIndex, int newIndex)? onReorder;

  /// Callback invoked when an icon is removed from the dock.
  ///
  /// Called when the user drags an icon outside the dock bounds
  /// and releases it.
  final void Function(int index, DockItem item)? onRemove;

  @override
  State<MacDock> createState() => _MacDockState();
}

class _MacDockState extends State<MacDock> {
  final _cursorPositionNotifier = ValueNotifier<Offset?>(null);
  final _dragInfoNotifier = ValueNotifier<DragInfo?>(null);
  final GlobalKey _stackKey = GlobalKey();

  // Getters and setters for easier access
  Offset? get _cursorPosition => _cursorPositionNotifier.value;
  set _cursorPosition(Offset? value) => _cursorPositionNotifier.value = value;

  DragInfo? get _dragInfo => _dragInfoNotifier.value;
  set _dragInfo(DragInfo? value) => _dragInfoNotifier.value = value;

  final List<GlobalKey> _iconKeys = [];
  final _reorderCalculator = const ReorderCalculator();
  String? _lastSwapDirection;

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
      // Clear drag info to prevent stale index references
      _dragInfo = null;
      _lastSwapDirection = null;
    }
  }

  @override
  void dispose() {
    _cursorPositionNotifier.dispose();
    _dragInfoNotifier.dispose();
    super.dispose();
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

  Offset _globalToLocal(Offset globalPosition) {
    final stackRenderBox =
        _stackKey.currentContext?.findRenderObject() as RenderBox?;
    if (stackRenderBox != null) {
      return stackRenderBox.globalToLocal(globalPosition);
    }
    return globalPosition;
  }

  Rect _getDockBounds() {
    final dockRenderBox = context.findRenderObject() as RenderBox?;
    if (dockRenderBox != null && dockRenderBox.hasSize) {
      final position = dockRenderBox.localToGlobal(Offset.zero);
      return Rect.fromLTWH(
        position.dx,
        position.dy,
        dockRenderBox.size.width,
        dockRenderBox.size.height,
      );
    }
    return Rect.zero;
  }

  void _handleDragStart(int index) {
    // Safety check: ensure index is valid
    if (index >= widget.items.length) return;

    final globalPosition = _calculateIconCenters()[index];

    // Calculate current scales to capture magnification at grab moment
    final iconCenters = _calculateIconCenters();
    final scales = MagnificationCalculator.calculateScales(
      cursorPosition: _cursorPosition,
      iconCenters: iconCenters,
      magnificationStrength: widget.magnification,
      magnificationRadius: widget.magnificationRadius,
    );

    _dragInfo = DragInfo(
      draggedIndex: index,
      draggedItemId: widget.items[index].id,
      initialPosition: globalPosition,
      currentPosition: globalPosition,
      state: DragState.dragging,
      hoverIndex: index,
      initialScale: scales[index],
    );
  }

  void _handleDragUpdate(int index, DragUpdateDetails details) {
    if (_dragInfo == null || _dragInfo!.draggedIndex != index) return;

    // Safety check: ensure draggedIndex is still valid after list changes
    if (_dragInfo!.draggedIndex >= widget.items.length) return;

    final localPosition = _globalToLocal(details.globalPosition);

    // Check if outside dock bounds (only if removal is enabled)
    final dockBounds = _getDockBounds();
    final canRemove = widget.onRemove != null;
    final isOutside = canRemove &&
        _reorderCalculator.isOutsideDock(
          dragPosition: details.globalPosition,
          dockBounds: dockBounds,
          dockPosition: widget.position.name,
        );

    // Only calculate reorder if not in removing state
    int? newHoverIndex;
    if (!isOutside) {
      // Get icon centers BEFORE updating cursor position
      // This ensures consistent positions for swap detection
      final iconCenters = _calculateIconCenters();

      // Use current hover index as the "dragged" position for swap calculations
      // This allows continuous reordering as the icon moves
      final currentDraggedIndex =
          _dragInfo!.hoverIndex ?? _dragInfo!.draggedIndex;

      // Calculate new hover index
      newHoverIndex = _reorderCalculator.calculateNewIndex(
        iconPositions: iconCenters,
        iconSize: widget.size,
        draggedIndex: currentDraggedIndex,
        dragPosition: details.globalPosition,
        lastSwapDirection: _lastSwapDirection,
        isHorizontal: _isHorizontal,
      );

      // Update swap direction
      if (newHoverIndex != _dragInfo!.hoverIndex) {
        _lastSwapDirection =
            newHoverIndex < currentDraggedIndex ? 'left' : 'right';
      }
    } else {
      // When outside/removing, keep current hover index
      newHoverIndex = _dragInfo!.hoverIndex;
    }

    // Update cursor position for magnification during drag
    _cursorPosition = details.globalPosition;

    _dragInfo = _dragInfo!.copyWith(
      currentPosition: localPosition,
      hoverIndex: newHoverIndex,
      state: isOutside ? DragState.removing : DragState.dragging,
    );
  }

  void _handleDragEnd(int index, DragEndDetails details) {
    if (_dragInfo == null || _dragInfo!.draggedIndex != index) return;

    // Find dragged item by ID first (safer than index access)
    final draggedItem = widget.items.firstWhere(
      (item) => item.id == _dragInfo!.draggedItemId,
      orElse: () => widget.items.length > index
          ? widget.items[index]
          : widget.items.first,
    );

    if (_dragInfo!.state == DragState.removing) {
      // Icon was removed
      widget.onRemove?.call(index, draggedItem);
      _dragInfo = null;
      _lastSwapDirection = null;
      _cursorPosition = null; // Clear cursor to stop magnification
    } else if (_dragInfo!.hoverIndex != null &&
        _dragInfo!.hoverIndex != _dragInfo!.draggedIndex) {
      // Icon was reordered
      final oldIndex = _dragInfo!.draggedIndex;
      final newIndex = _dragInfo!.hoverIndex!;

      // Call onReorder immediately to update the list
      widget.onReorder?.call(oldIndex, newIndex);

      // Wait for rebuild, then calculate target position from new list order
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _dragInfo == null) return;

        // Now list is reordered, get icon centers WITHOUT gap offsets
        // Temporarily clear dragInfo to get clean positions
        final savedDragInfo = _dragInfo;
        _dragInfo = null;

        // Force immediate layout update
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;

          final iconCenters = _calculateIconCenters();

          // Calculate scales and offsets
          final scales = MagnificationCalculator.calculateScales(
            cursorPosition: _cursorPosition,
            iconCenters: iconCenters,
            magnificationStrength: widget.magnification,
            magnificationRadius: widget.magnificationRadius,
          );

          // Calculate target position matching exact visual position
          // During returning, gapOffset is 0
          const gapOffset = 0;
          final magnificationOffset =
              _calculateMagnificationOffset(newIndex, scales);
          final totalOffset = gapOffset + magnificationOffset;

          // Calculate lift offset (same as in _buildIconsWithMagnification)
          final scaleDelta = scales[newIndex] - 1.0;
          final liftAmount = widget.size * scaleDelta * widget.liftStrength;

          // Find where the dragged item ended up in the new list
          final targetGlobalCenter = iconCenters[newIndex];
          final targetLocalCenter = _globalToLocal(targetGlobalCenter);

          // Calculate target position (top-left of overlay)
          var targetX = targetLocalCenter.dx - widget.size / 2;
          var targetY = targetLocalCenter.dy - widget.size / 2;

          if (_isHorizontal) {
            // Horizontal: magnification offset in X, lift in Y
            targetX += totalOffset;
            targetY +=
                widget.position == DockPosition.top ? liftAmount : -liftAmount;
          } else {
            // Vertical: magnification offset in Y, lift in X
            targetY += totalOffset;
            targetX +=
                widget.position == DockPosition.left ? liftAmount : -liftAmount;
          }

          final targetPosition = Offset(targetX, targetY);

          // Calculate current overlay position (where it actually is now)
          // During dragging, overlay position is currentPosition - size/2
          // We need to convert this to top-left for returning state
          if (savedDragInfo == null) return;
          final currentOverlayPosition = Offset(
            savedDragInfo.currentPosition.dx - widget.size / 2,
            savedDragInfo.currentPosition.dy - widget.size / 2,
          );

          // First, set returning state with CURRENT overlay position
          _dragInfo = savedDragInfo.copyWith(
            state: DragState.returning,
            currentPosition:
                currentOverlayPosition, // Start animation from here
            draggedIndex: newIndex, // Update to new index
            hoverIndex: newIndex,
          );

          // Then in next frame, update to target position for smooth animation
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted || _dragInfo == null) return;

            _dragInfo = _dragInfo!.copyWith(
              currentPosition: targetPosition,
            );
          });

          // After animation completes, clear drag state
          Future.delayed(widget.returnAnimationDuration, () {
            if (mounted) {
              _dragInfo = null;
              _lastSwapDirection = null;
            }
          });
        });
      });
    } else {
      // No reorder, just release
      _dragInfo = null;
      _lastSwapDirection = null;
      _cursorPosition = null; // Clear cursor to stop magnification
    }
  }

  double _calculateIconOffset(int index) {
    if (_dragInfo == null) return 0;

    // Don't show gaps during returning animation
    // List is already reordered, so items are in final positions
    if (_dragInfo!.state == DragState.returning) return 0;

    // Keep gaps during dragging state
    return _reorderCalculator.calculateIconOffset(
      iconIndex: index,
      draggedIndex: _dragInfo!.draggedIndex,
      targetIndex: _dragInfo!.hoverIndex ?? _dragInfo!.draggedIndex,
      iconSize: widget.size,
      spacing: 8,
    );
  }

  /// Calculates displacement for magnified icons to prevent overlap.
  ///
  /// Icons are pushed based on magnification of surrounding icons,
  /// following macOS dock behavior.
  double _calculateMagnificationOffset(int index, List<double> scales) {
    if (_cursorPosition == null || widget.magnification <= 1) return 0;

    var offset = 0.0;

    // Calculate cumulative offset from all icons
    // Use minimum length to avoid index out of range after reorder
    final length = scales.length < widget.items.length
        ? scales.length
        : widget.items.length;

    for (var i = 0; i < length; i++) {
      if (i == index) continue;

      // Skip dragged icon by ID (works even after reorder)
      if (_dragInfo != null && widget.items[i].id == _dragInfo!.draggedItemId) {
        continue;
      }

      final scaleDelta = (scales[i] - 1.0) * widget.size;

      if (i < index) {
        // Icons to the left push this icon right
        offset += scaleDelta / 2;
      } else {
        // Icons to the right push this icon left
        offset -= scaleDelta / 2;
      }
    }

    return offset;
  }

  List<Widget> _buildIconsWithMagnification() {
    final iconCenters = _calculateIconCenters();

    // Magnification works during drag, but dragged icon is excluded
    final scales = MagnificationCalculator.calculateScales(
      cursorPosition: _cursorPosition,
      iconCenters: iconCenters,
      magnificationStrength: widget.magnification,
      magnificationRadius: widget.magnificationRadius,
    );

    return List.generate(widget.items.length, (index) {
      final gapOffset = _calculateIconOffset(index);
      final magnificationOffset = _calculateMagnificationOffset(index, scales);
      final totalOffset = gapOffset + magnificationOffset;

      // Use ID to identify dragged item (works even after reorder)
      final isTheDraggedItem = _dragInfo != null &&
          widget.items[index].id == _dragInfo!.draggedItemId;
      final isDragging =
          isTheDraggedItem && _dragInfo!.state == DragState.dragging;

      // During returning animation, hide the dragged icon to prevent duplicate
      // (it's being animated in the overlay)
      final isReturning = _dragInfo?.state == DragState.returning;
      final shouldHide = isTheDraggedItem && isReturning;

      // Calculate lift offset based on scale and dock position
      final scaleDelta = scales[index] - 1.0;
      final liftAmount = widget.size * scaleDelta * widget.liftStrength;

      double translateX = 0;
      double translateY = 0;

      if (_isHorizontal) {
        translateX = totalOffset;
        // Lift up or down based on position
        translateY =
            widget.position == DockPosition.top ? liftAmount : -liftAmount;
      } else {
        translateY = totalOffset;
        // Lift left or right based on position
        translateX =
            widget.position == DockPosition.left ? liftAmount : -liftAmount;
      }

      return AnimatedContainer(
        key: ValueKey(widget.items[index].id),
        duration: widget.reorderAnimationDuration,
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(translateX, translateY, 0),
        child: Opacity(
          opacity: shouldHide ? 0.0 : 1.0,
          child: DraggableDockIcon(
            key: _iconKeys[index],
            item: widget.items[index],
            size: widget.size,
            scale: isDragging ? 1.0 : scales[index],
            animationDuration: widget.magnificationAnimationDuration,
            isDragging: isDragging,
            onDragStart: () => _handleDragStart(index),
            onDragUpdate: (details) => _handleDragUpdate(index, details),
            onDragEnd: (details) => _handleDragEnd(index, details),
          ),
        ),
      );
    });
  }

  Widget? _buildDragOverlay() {
    if (_dragInfo == null) return null;

    // Find the dragged item by ID (works even after reorder)
    final draggedItem = widget.items.firstWhere(
      (item) => item.id == _dragInfo!.draggedItemId,
      orElse: () => widget.items[_dragInfo!.draggedIndex],
    );

    Offset targetPosition;
    if (_dragInfo!.state == DragState.returning) {
      // Use the pre-calculated target position stored in currentPosition
      // This was calculated AFTER the list was reordered
      targetPosition = _dragInfo!.currentPosition;
    } else {
      // Follow cursor during drag
      targetPosition = Offset(
        _dragInfo!.currentPosition.dx - widget.size / 2,
        _dragInfo!.currentPosition.dy - widget.size / 2,
      );
    }

    return DraggedIconOverlay(
      position: targetPosition,
      size: widget.size,
      isLifted: _dragInfo!.state == DragState.dragging,
      isRemoving: _dragInfo!.state == DragState.removing,
      isReturning: _dragInfo!.state == DragState.returning,
      initialScale: _dragInfo!.initialScale,
      returnDuration: widget.returnAnimationDuration,
      child: draggedItem.icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return const SizedBox.shrink();
    }

    return MouseRegion(
      onHover: (event) {
        _cursorPosition = event.position;
      },
      onExit: (_) {
        if (_dragInfo == null) {
          _cursorPosition = null;
        }
      },
      child: ValueListenableBuilder<Offset?>(
        valueListenable: _cursorPositionNotifier,
        builder: (context, cursorPosition, _) {
          return ValueListenableBuilder<DragInfo?>(
            valueListenable: _dragInfoNotifier,
            builder: (context, dragInfo, _) {
              final children = _buildIconsWithMagnification();

              return Stack(
                key: _stackKey,
                clipBehavior: Clip.none,
                children: [
                  if (_isHorizontal)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: children,
                    )
                  else
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: children,
                    ),
                  if (_buildDragOverlay() != null) _buildDragOverlay()!,
                ],
              );
            },
          );
        },
      ),
    );
  }
}
