import 'package:flutter_macos_dock/src/enums/dock_position.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DockPosition', () {
    test('has four values', () {
      expect(DockPosition.values.length, 4);
    });

    test('contains bottom value', () {
      expect(DockPosition.values, contains(DockPosition.bottom));
    });

    test('contains left value', () {
      expect(DockPosition.values, contains(DockPosition.left));
    });

    test('contains right value', () {
      expect(DockPosition.values, contains(DockPosition.right));
    });

    test('contains top value', () {
      expect(DockPosition.values, contains(DockPosition.top));
    });

    test('values are ordered correctly', () {
      expect(DockPosition.values[0], DockPosition.bottom);
      expect(DockPosition.values[1], DockPosition.left);
      expect(DockPosition.values[2], DockPosition.right);
      expect(DockPosition.values[3], DockPosition.top);
    });

    test('toString returns correct representation', () {
      expect(DockPosition.bottom.toString(), 'DockPosition.bottom');
      expect(DockPosition.left.toString(), 'DockPosition.left');
      expect(DockPosition.right.toString(), 'DockPosition.right');
      expect(DockPosition.top.toString(), 'DockPosition.top');
    });

    test('enum equality works correctly', () {
      expect(DockPosition.bottom, DockPosition.bottom);
      expect(DockPosition.bottom == DockPosition.left, false);
      expect(DockPosition.left, DockPosition.left);
      expect(DockPosition.right, DockPosition.right);
      expect(DockPosition.top, DockPosition.top);
    });

    test('name property returns correct string', () {
      expect(DockPosition.bottom.name, 'bottom');
      expect(DockPosition.left.name, 'left');
      expect(DockPosition.right.name, 'right');
      expect(DockPosition.top.name, 'top');
    });
  });
}
