import 'package:flutter/material.dart';
import 'package:flutter_macos_dock/src/models/dock_badge.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DockBadge', () {
    test('can be instantiated with no parameters', () {
      const badge = DockBadge();
      expect(badge, isNotNull);
      expect(badge.text, isNull);
      expect(badge.count, isNull);
      expect(badge.backgroundColor, isNull);
      expect(badge.textColor, isNull);
    });

    test('can be instantiated with text', () {
      const badge = DockBadge(text: 'New');
      expect(badge.text, 'New');
      expect(badge.count, isNull);
    });

    test('can be instantiated with count', () {
      const badge = DockBadge(count: 5);
      expect(badge.count, 5);
      expect(badge.text, isNull);
    });

    test('can be instantiated with colors', () {
      const badge = DockBadge(
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      expect(badge.backgroundColor, Colors.red);
      expect(badge.textColor, Colors.white);
    });

    test('can be instantiated with all parameters', () {
      const badge = DockBadge(
        text: 'Alert',
        count: 10,
        backgroundColor: Colors.blue,
        textColor: Colors.yellow,
      );
      expect(badge.text, 'Alert');
      expect(badge.count, 10);
      expect(badge.backgroundColor, Colors.blue);
      expect(badge.textColor, Colors.yellow);
    });

    test('copyWith returns new instance with updated values', () {
      const original = DockBadge(text: 'Old', count: 1);
      final updated = original.copyWith(text: 'New');

      expect(updated.text, 'New');
      expect(updated.count, 1);
      expect(updated, isNot(same(original)));
    });

    test('copyWith preserves original values when not overridden', () {
      const original = DockBadge(
        text: 'Test',
        count: 5,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      final updated = original.copyWith(count: 10);

      expect(updated.text, 'Test');
      expect(updated.count, 10);
      expect(updated.backgroundColor, Colors.red);
      expect(updated.textColor, Colors.white);
    });

    test('copyWith with no parameters returns equivalent badge', () {
      const original = DockBadge(text: 'Test');
      final updated = original.copyWith();

      expect(updated.text, original.text);
      expect(updated.count, original.count);
      expect(updated.backgroundColor, original.backgroundColor);
      expect(updated.textColor, original.textColor);
    });

    test('equality works correctly for identical instances', () {
      const badge1 = DockBadge(text: 'Test', count: 5);
      const badge2 = DockBadge(text: 'Test', count: 5);

      expect(badge1, badge2);
      expect(badge1.hashCode, badge2.hashCode);
    });

    test('equality returns false for different text', () {
      const badge1 = DockBadge(text: 'Test1');
      const badge2 = DockBadge(text: 'Test2');

      expect(badge1, isNot(badge2));
    });

    test('equality returns false for different count', () {
      const badge1 = DockBadge(count: 1);
      const badge2 = DockBadge(count: 2);

      expect(badge1, isNot(badge2));
    });

    test('equality returns false for different backgroundColor', () {
      const badge1 = DockBadge(backgroundColor: Colors.red);
      const badge2 = DockBadge(backgroundColor: Colors.blue);

      expect(badge1, isNot(badge2));
    });

    test('equality returns false for different textColor', () {
      const badge1 = DockBadge(textColor: Colors.black);
      const badge2 = DockBadge(textColor: Colors.white);

      expect(badge1, isNot(badge2));
    });

    test('equality works with null values', () {
      const badge1 = DockBadge();
      const badge2 = DockBadge();

      expect(badge1, badge2);
      expect(badge1.hashCode, badge2.hashCode);
    });

    test('equality returns true for identical object', () {
      const badge = DockBadge(text: 'Test');

      expect(badge, badge);
    });

    test('hashCode is consistent', () {
      const badge = DockBadge(text: 'Test', count: 5);

      expect(badge.hashCode, badge.hashCode);
    });

    test('hashCode differs for different badges', () {
      const badge1 = DockBadge(text: 'Test1');
      const badge2 = DockBadge(text: 'Test2');

      expect(badge1.hashCode, isNot(badge2.hashCode));
    });
  });
}
