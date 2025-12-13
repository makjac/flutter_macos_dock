import 'package:flutter_macos_dock/src/models/drag_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DragState', () {
    test('has all required states', () {
      expect(DragState.values.length, 5);
      expect(DragState.values, contains(DragState.idle));
      expect(DragState.values, contains(DragState.detecting));
      expect(DragState.values, contains(DragState.dragging));
      expect(DragState.values, contains(DragState.removing));
      expect(DragState.values, contains(DragState.returning));
    });
  });

  group('DragInfo', () {
    test('creates instance with required fields', () {
      const dragInfo = DragInfo(
        draggedIndex: 0,
        draggedItemId: 'test-id',
        initialPosition: Offset(10, 20),
        currentPosition: Offset(15, 25),
        state: DragState.dragging,
      );

      expect(dragInfo.draggedIndex, 0);
      expect(dragInfo.initialPosition, const Offset(10, 20));
      expect(dragInfo.currentPosition, const Offset(15, 25));
      expect(dragInfo.state, DragState.dragging);
      expect(dragInfo.hoverIndex, isNull);
    });

    test('creates instance with optional hover index', () {
      const dragInfo = DragInfo(
        draggedIndex: 0,
        draggedItemId: 'test-id',
        initialPosition: Offset(10, 20),
        currentPosition: Offset(15, 25),
        state: DragState.dragging,
        hoverIndex: 2,
      );

      expect(dragInfo.hoverIndex, 2);
    });

    test('copyWith updates specified fields', () {
      const original = DragInfo(
        draggedIndex: 0,
        draggedItemId: 'test-id',
        initialPosition: Offset(10, 20),
        currentPosition: Offset(15, 25),
        state: DragState.detecting,
      );

      final updated = original.copyWith(
        currentPosition: const Offset(20, 30),
        state: DragState.dragging,
        hoverIndex: 1,
      );

      expect(updated.draggedIndex, 0); // unchanged
      expect(updated.initialPosition, const Offset(10, 20)); // unchanged
      expect(updated.currentPosition, const Offset(20, 30)); // updated
      expect(updated.state, DragState.dragging); // updated
      expect(updated.hoverIndex, 1); // updated
    });

    test('copyWith preserves unchanged fields', () {
      const original = DragInfo(
        draggedIndex: 0,
        draggedItemId: 'test-id',
        initialPosition: Offset(10, 20),
        currentPosition: Offset(15, 25),
        state: DragState.dragging,
        hoverIndex: 2,
      );

      final updated = original.copyWith();

      expect(updated.draggedIndex, original.draggedIndex);
      expect(updated.initialPosition, original.initialPosition);
      expect(updated.currentPosition, original.currentPosition);
      expect(updated.state, original.state);
      expect(updated.hoverIndex, original.hoverIndex);
    });
  });
}
