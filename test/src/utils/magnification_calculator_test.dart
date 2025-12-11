import 'package:flutter_macos_dock/src/utils/magnification_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MagnificationCalculator', () {
    group('calculateScale', () {
      test('returns 1.0 when cursor position is null', () {
        final scale = MagnificationCalculator.calculateScale(
          cursorPosition: null,
          iconCenter: const Offset(100, 50),
          magnificationStrength: 2,
          magnificationRadius: 100,
        );

        expect(scale, equals(1.0));
      });

      test('returns 1.0 when magnification strength is 1.0', () {
        final scale = MagnificationCalculator.calculateScale(
          cursorPosition: const Offset(100, 50),
          iconCenter: const Offset(100, 50),
          magnificationStrength: 1,
          magnificationRadius: 100,
        );

        expect(scale, equals(1.0));
      });

      test('returns 1.0 when magnification strength is less than 1.0', () {
        final scale = MagnificationCalculator.calculateScale(
          cursorPosition: const Offset(100, 50),
          iconCenter: const Offset(100, 50),
          magnificationStrength: 0.5,
          magnificationRadius: 100,
        );

        expect(scale, equals(1.0));
      });

      test(
          'returns magnification strength when cursor is at icon '
          'center', () {
        final scale = MagnificationCalculator.calculateScale(
          cursorPosition: const Offset(100, 50),
          iconCenter: const Offset(100, 50),
          magnificationStrength: 2,
          magnificationRadius: 100,
        );

        expect(scale, equals(2.0));
      });

      test('returns 1.0 when cursor is beyond radius', () {
        final scale = MagnificationCalculator.calculateScale(
          cursorPosition: const Offset(250, 50),
          iconCenter: const Offset(100, 50),
          magnificationStrength: 2,
          magnificationRadius: 100,
        );

        expect(scale, equals(1.0));
      });

      test('returns 1.0 when cursor is exactly at radius edge', () {
        final scale = MagnificationCalculator.calculateScale(
          cursorPosition: const Offset(200, 50),
          iconCenter: const Offset(100, 50),
          magnificationStrength: 2,
          magnificationRadius: 100,
        );

        expect(scale, equals(1.0));
      });

      test(
          'returns interpolated value when cursor is within '
          'radius', () {
        // Cursor at 50 pixels from center (half the radius)
        final scale = MagnificationCalculator.calculateScale(
          cursorPosition: const Offset(150, 50),
          iconCenter: const Offset(100, 50),
          magnificationStrength: 2,
          magnificationRadius: 100,
        );

        // At half distance, normalized = 0.5
        // scale = 1.0 + (2.0 - 1.0) * 0.5 = 1.5
        expect(scale, equals(1.5));
      });

      test('handles diagonal distance correctly', () {
        // Cursor at (100 + 60, 50 + 80) = (160, 130)
        // Distance = sqrt(60^2 + 80^2) = sqrt(3600 + 6400) = 100
        final scale = MagnificationCalculator.calculateScale(
          cursorPosition: const Offset(160, 130),
          iconCenter: const Offset(100, 50),
          magnificationStrength: 2,
          magnificationRadius: 100,
        );

        // At radius edge, scale should be 1.0
        expect(scale, equals(1.0));
      });

      test('handles negative coordinates', () {
        final scale = MagnificationCalculator.calculateScale(
          cursorPosition: const Offset(-50, -50),
          iconCenter: const Offset(-50, -50),
          magnificationStrength: 2,
          magnificationRadius: 100,
        );

        expect(scale, equals(2.0));
      });

      test('clamps scale between 1.0 and magnification strength', () {
        final scale = MagnificationCalculator.calculateScale(
          cursorPosition: const Offset(100, 50),
          iconCenter: const Offset(100, 50),
          magnificationStrength: 2.5,
          magnificationRadius: 100,
        );

        expect(scale, greaterThanOrEqualTo(1.0));
        expect(scale, lessThanOrEqualTo(2.5));
        expect(scale, equals(2.5));
      });

      test('returns correct scale at quarter distance', () {
        // Cursor at 25 pixels from center (quarter the radius)
        final scale = MagnificationCalculator.calculateScale(
          cursorPosition: const Offset(125, 50),
          iconCenter: const Offset(100, 50),
          magnificationStrength: 2,
          magnificationRadius: 100,
        );

        // At quarter distance, normalized = 0.75
        // scale = 1.0 + (2.0 - 1.0) * 0.75 = 1.75
        expect(scale, equals(1.75));
      });

      test('returns correct scale at three-quarter distance', () {
        // Cursor at 75 pixels from center (three-quarters the radius)
        final scale = MagnificationCalculator.calculateScale(
          cursorPosition: const Offset(175, 50),
          iconCenter: const Offset(100, 50),
          magnificationStrength: 2,
          magnificationRadius: 100,
        );

        // At three-quarter distance, normalized = 0.25
        // scale = 1.0 + (2.0 - 1.0) * 0.25 = 1.25
        expect(scale, equals(1.25));
      });

      test('handles very small magnification radius', () {
        final scale = MagnificationCalculator.calculateScale(
          cursorPosition: const Offset(100, 50),
          iconCenter: const Offset(100, 50),
          magnificationStrength: 2,
          magnificationRadius: 1,
        );

        expect(scale, equals(2.0));
      });

      test('handles very large magnification strength', () {
        final scale = MagnificationCalculator.calculateScale(
          cursorPosition: const Offset(100, 50),
          iconCenter: const Offset(100, 50),
          magnificationStrength: 10,
          magnificationRadius: 100,
        );

        expect(scale, equals(10.0));
      });
    });

    group('calculateScales', () {
      test('returns list of 1.0 when cursor position is null', () {
        final scales = MagnificationCalculator.calculateScales(
          cursorPosition: null,
          iconCenters: const [
            Offset(100, 50),
            Offset(150, 50),
            Offset(200, 50),
          ],
          magnificationStrength: 2,
          magnificationRadius: 100,
        );

        expect(scales, equals([1.0, 1.0, 1.0]));
      });

      test('returns empty list when icon centers is empty', () {
        final scales = MagnificationCalculator.calculateScales(
          cursorPosition: const Offset(100, 50),
          iconCenters: const [],
          magnificationStrength: 2,
          magnificationRadius: 100,
        );

        expect(scales, isEmpty);
      });

      test('calculates scales for multiple icons correctly', () {
        final scales = MagnificationCalculator.calculateScales(
          cursorPosition: const Offset(150, 50),
          iconCenters: const [
            Offset(100, 50), // 50px away
            Offset(150, 50), // 0px away (center)
            Offset(200, 50), // 50px away
          ],
          magnificationStrength: 2,
          magnificationRadius: 100,
        );

        expect(scales.length, equals(3));
        expect(scales[0], equals(1.5)); // Half distance = 1.5 scale
        expect(scales[1], equals(2.0)); // At center = max scale
        expect(scales[2], equals(1.5)); // Half distance = 1.5 scale
      });

      test('handles horizontal layout positioning', () {
        final scales = MagnificationCalculator.calculateScales(
          cursorPosition: const Offset(150, 50),
          iconCenters: const [
            Offset(50, 50),
            Offset(100, 50),
            Offset(150, 50),
            Offset(200, 50),
            Offset(250, 50),
          ],
          magnificationStrength: 2,
          magnificationRadius: 100,
        );

        expect(scales.length, equals(5));
        expect(scales[0], equals(1.0)); // Beyond radius
        expect(scales[1], equals(1.5)); // Half distance
        expect(scales[2], equals(2.0)); // At center
        expect(scales[3], equals(1.5)); // Half distance
        expect(scales[4], equals(1.0)); // Beyond radius
      });

      test('handles vertical layout positioning', () {
        final scales = MagnificationCalculator.calculateScales(
          cursorPosition: const Offset(50, 150),
          iconCenters: const [
            Offset(50, 50),
            Offset(50, 100),
            Offset(50, 150),
            Offset(50, 200),
            Offset(50, 250),
          ],
          magnificationStrength: 2,
          magnificationRadius: 100,
        );

        expect(scales.length, equals(5));
        expect(scales[0], equals(1.0)); // Beyond radius
        expect(scales[1], equals(1.5)); // Half distance
        expect(scales[2], equals(2.0)); // At center
        expect(scales[3], equals(1.5)); // Half distance
        expect(scales[4], equals(1.0)); // Beyond radius
      });

      test('handles single icon', () {
        final scales = MagnificationCalculator.calculateScales(
          cursorPosition: const Offset(100, 50),
          iconCenters: const [Offset(100, 50)],
          magnificationStrength: 2,
          magnificationRadius: 100,
        );

        expect(scales, equals([2.0]));
      });

      test('respects magnification strength for all icons', () {
        final scales = MagnificationCalculator.calculateScales(
          cursorPosition: const Offset(150, 50),
          iconCenters: const [
            Offset(100, 50),
            Offset(150, 50),
            Offset(200, 50),
          ],
          magnificationStrength: 3,
          magnificationRadius: 100,
        );

        expect(scales[0], equals(2.0)); // Half distance with 3.0 strength
        expect(scales[1], equals(3.0)); // At center
        expect(scales[2], equals(2.0)); // Half distance with 3.0 strength
      });

      test('handles all icons beyond radius', () {
        final scales = MagnificationCalculator.calculateScales(
          cursorPosition: Offset.zero,
          iconCenters: const [
            Offset(200, 50),
            Offset(250, 50),
            Offset(300, 50),
          ],
          magnificationStrength: 2,
          magnificationRadius: 100,
        );

        expect(scales, equals([1.0, 1.0, 1.0]));
      });

      test('calculates scales with varying distances', () {
        final scales = MagnificationCalculator.calculateScales(
          cursorPosition: const Offset(100, 50),
          iconCenters: const [
            Offset(100, 50), // 0px
            Offset(125, 50), // 25px
            Offset(150, 50), // 50px
            Offset(175, 50), // 75px
            Offset(200, 50), // 100px
          ],
          magnificationStrength: 2,
          magnificationRadius: 100,
        );

        expect(scales.length, equals(5));
        expect(scales[0], equals(2.0)); // 0px = max
        expect(scales[1], equals(1.75)); // 25px
        expect(scales[2], equals(1.5)); // 50px
        expect(scales[3], equals(1.25)); // 75px
        expect(scales[4], equals(1.0)); // 100px = edge
      });
    });
  });
}
