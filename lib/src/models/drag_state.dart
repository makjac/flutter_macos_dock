import 'package:flutter/material.dart';

/// Represents the state of a drag operation.
enum DragState {
  /// No drag operation in progress.
  idle,

  /// Drag threshold detection in progress (checking distance/time).
  detecting,

  /// Actively dragging an icon.
  dragging,

  /// Icon is in remove mode (dragged outside bounds).
  removing,

  /// Animating return to original position (cancelled drag).
  returning,
}

/// Holds information about an active drag session.
class DragInfo {
  /// Creates a drag information object.
  const DragInfo({
    required this.draggedIndex,
    required this.draggedItemId,
    required this.initialPosition,
    required this.currentPosition,
    required this.state,
    this.hoverIndex,
    this.initialScale = 1.0,
  });

  /// Index of the icon being dragged (original index before reorder).
  final int draggedIndex;

  /// ID of the item being dragged (stable across reorders).
  final String draggedItemId;

  /// Initial global position where drag started.
  final Offset initialPosition;

  /// Current global position of the cursor.
  final Offset currentPosition;

  /// Current state of the drag operation.
  final DragState state;

  /// Index where the icon would be dropped if released now.
  final int? hoverIndex;

  /// The magnification scale at the moment the icon was grabbed.
  final double initialScale;

  /// Creates a copy with updated fields.
  DragInfo copyWith({
    int? draggedIndex,
    String? draggedItemId,
    Offset? initialPosition,
    Offset? currentPosition,
    DragState? state,
    int? hoverIndex,
    double? initialScale,
  }) {
    return DragInfo(
      draggedIndex: draggedIndex ?? this.draggedIndex,
      draggedItemId: draggedItemId ?? this.draggedItemId,
      initialPosition: initialPosition ?? this.initialPosition,
      currentPosition: currentPosition ?? this.currentPosition,
      state: state ?? this.state,
      hoverIndex: hoverIndex ?? this.hoverIndex,
      initialScale: initialScale ?? this.initialScale,
    );
  }
}
