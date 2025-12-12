import 'package:flutter/material.dart';
import 'package:flutter_macos_dock/src/utils/reorder_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ReorderCalculator', () {
    late ReorderCalculator calculator;

    setUp(() {
      calculator = const ReorderCalculator();
    });

    group('calculateNewIndex', () {
      test('returns same index when drag position is over same icon', () {
        final iconPositions = [
          const Offset(50, 100),
          const Offset(150, 100),
          const Offset(250, 100),
        ];

        final newIndex = calculator.calculateNewIndex(
          iconPositions: iconPositions,
          iconSize: 48,
          draggedIndex: 1,
          dragPosition: const Offset(150, 100),
        );

        expect(newIndex, 1);
      });

      test('returns left index when dragged past 50% threshold', () {
        final iconPositions = [
          const Offset(50, 100),
          const Offset(150, 100),
          const Offset(250, 100),
        ];

        // Drag to 74px (at the 50% threshold of icon 0)
        // Icon 0 at 50, threshold is 50+24=74
        final newIndex = calculator.calculateNewIndex(
          iconPositions: iconPositions,
          iconSize: 48,
          draggedIndex: 1,
          dragPosition: const Offset(74, 100),
        );

        expect(newIndex, 0);
      });

      test('returns right index when dragged past 50% threshold', () {
        final iconPositions = [
          const Offset(50, 100),
          const Offset(150, 100),
          const Offset(250, 100),
        ];

        // Drag to 274px (at the 50% threshold of icon 2)
        // Icon 2 at 250, threshold is 250+24=274
        final newIndex = calculator.calculateNewIndex(
          iconPositions: iconPositions,
          iconSize: 48,
          draggedIndex: 1,
          dragPosition: const Offset(274, 100),
        );

        expect(newIndex, 2);
      });

      test('applies hysteresis when last swap was left', () {
        final iconPositions = [
          const Offset(50, 100),
          const Offset(150, 100),
          const Offset(250, 100),
        ];

        // With hysteresis, threshold is reduced by 5% (2.4px)
        // Should stay at index 0 even when slightly right of threshold
        final newIndex = calculator.calculateNewIndex(
          iconPositions: iconPositions,
          iconSize: 48,
          draggedIndex: 0,
          dragPosition: const Offset(52, 100),
          lastSwapDirection: 'left',
        );

        expect(newIndex, 0);
      });

      test('applies hysteresis when last swap was right', () {
        final iconPositions = [
          const Offset(50, 100),
          const Offset(150, 100),
          const Offset(250, 100),
        ];

        // With hysteresis, should stay at index 2
        final newIndex = calculator.calculateNewIndex(
          iconPositions: iconPositions,
          iconSize: 48,
          draggedIndex: 2,
          dragPosition: const Offset(248, 100),
          lastSwapDirection: 'right',
        );

        expect(newIndex, 2);
      });

      test('returns 0 for empty icon positions', () {
        final newIndex = calculator.calculateNewIndex(
          iconPositions: [],
          iconSize: 48,
          draggedIndex: 0,
          dragPosition: const Offset(100, 100),
        );

        expect(newIndex, 0);
      });
    });

    group('calculateIconOffset', () {
      test('returns 0 for dragged icon', () {
        final offset = calculator.calculateIconOffset(
          iconIndex: 1,
          draggedIndex: 1,
          targetIndex: 2,
          iconSize: 48,
          spacing: 8,
        );

        expect(offset, 0.0);
      });

      test('shifts icon right when creating gap to the left', () {
        final offset = calculator.calculateIconOffset(
          iconIndex: 1,
          draggedIndex: 2,
          targetIndex: 0,
          iconSize: 48,
          spacing: 8,
        );

        expect(offset, 56.0); // 48 + 8
      });

      test('shifts icon left when creating gap to the right', () {
        final offset = calculator.calculateIconOffset(
          iconIndex: 2,
          draggedIndex: 0,
          targetIndex: 3,
          iconSize: 48,
          spacing: 8,
        );

        expect(offset, -56.0); // -(48 + 8)
      });

      test('returns 0 when icon is not affected by gap', () {
        final offset = calculator.calculateIconOffset(
          iconIndex: 0,
          draggedIndex: 2,
          targetIndex: 4,
          iconSize: 48,
          spacing: 8,
        );

        expect(offset, 0.0);
      });

      test('returns 0 when target equals dragged index', () {
        final offset = calculator.calculateIconOffset(
          iconIndex: 0,
          draggedIndex: 1,
          targetIndex: 1,
          iconSize: 48,
          spacing: 8,
        );

        expect(offset, 0.0);
      });
    });

    group('isOutsideDock', () {
      const dockBounds = Rect.fromLTWH(100, 100, 400, 80);

      test('returns true when dragged above bottom dock threshold', () {
        final isOutside = calculator.isOutsideDock(
          dragPosition: const Offset(300, 30),
          dockBounds: dockBounds,
          dockPosition: 'bottom',
        );

        expect(isOutside, true);
      });

      test('returns false when within bottom dock threshold', () {
        final isOutside = calculator.isOutsideDock(
          dragPosition: const Offset(300, 50),
          dockBounds: dockBounds,
          dockPosition: 'bottom',
        );

        expect(isOutside, false);
      });

      test('returns true when dragged below top dock threshold', () {
        final isOutside = calculator.isOutsideDock(
          dragPosition: const Offset(300, 250),
          dockBounds: dockBounds,
          dockPosition: 'top',
        );

        expect(isOutside, true);
      });

      test('returns false when within top dock threshold', () {
        final isOutside = calculator.isOutsideDock(
          dragPosition: const Offset(300, 230),
          dockBounds: dockBounds,
          dockPosition: 'top',
        );

        expect(isOutside, false);
      });

      test('returns true when dragged right of left dock threshold', () {
        final isOutside = calculator.isOutsideDock(
          dragPosition: const Offset(570, 150),
          dockBounds: dockBounds,
          dockPosition: 'left',
        );

        expect(isOutside, true);
      });

      test('returns false when within left dock threshold', () {
        final isOutside = calculator.isOutsideDock(
          dragPosition: const Offset(540, 150),
          dockBounds: dockBounds,
          dockPosition: 'left',
        );

        expect(isOutside, false);
      });

      test('returns true when dragged left of right dock threshold', () {
        final isOutside = calculator.isOutsideDock(
          dragPosition: const Offset(30, 150),
          dockBounds: dockBounds,
          dockPosition: 'right',
        );

        expect(isOutside, true);
      });

      test('returns false when within right dock threshold', () {
        final isOutside = calculator.isOutsideDock(
          dragPosition: const Offset(50, 150),
          dockBounds: dockBounds,
          dockPosition: 'right',
        );

        expect(isOutside, false);
      });

      test('returns false for unknown dock position', () {
        final isOutside = calculator.isOutsideDock(
          dragPosition: const Offset(300, 30),
          dockBounds: dockBounds,
          dockPosition: 'unknown',
        );

        expect(isOutside, false);
      });
    });

    group('constants', () {
      test('swapThreshold is 0.5', () {
        const calculator = ReorderCalculator();
        expect(ReorderCalculator.swapThreshold, 0.5);
      });

      test('hysteresis is 0.05', () {
        expect(ReorderCalculator.hysteresis, 0.05);
      });

      test('exitThreshold is 60.0', () {
        expect(ReorderCalculator.exitThreshold, 60.0);
      });
    });
  });
}
