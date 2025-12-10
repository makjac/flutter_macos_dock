import 'package:flutter/material.dart';
import 'package:flutter_macos_dock/src/models/context_menu_item.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ContextMenuItem', () {
    test('can be instantiated with required parameters', () {
      final menuItem = ContextMenuItem(
        label: 'Open',
        onTap: () {},
      );

      expect(menuItem, isNotNull);
      expect(menuItem.label, 'Open');
      expect(menuItem.onTap, isNotNull);
      expect(menuItem.icon, isNull);
    });

    test('can be instantiated with icon', () {
      const icon = Icon(Icons.open_in_new);
      final menuItem = ContextMenuItem(
        label: 'Open',
        onTap: () {},
        icon: icon,
      );

      expect(menuItem.icon, icon);
    });

    test('onTap callback is invoked correctly', () {
      var tapped = false;
      final menuItem = ContextMenuItem(
        label: 'Test',
        onTap: () {
          tapped = true;
        },
      );

      menuItem.onTap();
      expect(tapped, true);
    });

    test('copyWith returns new instance with updated label', () {
      final original = ContextMenuItem(
        label: 'Old Label',
        onTap: () {},
      );
      final updated = original.copyWith(label: 'New Label');

      expect(updated.label, 'New Label');
      expect(updated.onTap, original.onTap);
      expect(updated, isNot(same(original)));
    });

    test('copyWith returns new instance with updated onTap', () {
      void callback1() {}
      void callback2() {}

      final original = ContextMenuItem(
        label: 'Test',
        onTap: callback1,
      );
      final updated = original.copyWith(onTap: callback2);

      expect(updated.label, 'Test');
      expect(updated.onTap, callback2);
    });

    test('copyWith returns new instance with updated icon', () {
      const icon1 = Icon(Icons.open_in_new);
      const icon2 = Icon(Icons.close);

      final original = ContextMenuItem(
        label: 'Test',
        onTap: () {},
        icon: icon1,
      );
      final updated = original.copyWith(icon: icon2);

      expect(updated.icon, icon2);
    });

    test('copyWith preserves original values when not overridden', () {
      const icon = Icon(Icons.star);
      void callback() {}

      final original = ContextMenuItem(
        label: 'Test',
        onTap: callback,
        icon: icon,
      );
      final updated = original.copyWith();

      expect(updated.label, original.label);
      expect(updated.onTap, original.onTap);
      expect(updated.icon, original.icon);
    });

    test('equality works for identical callbacks', () {
      void callback() {}

      final menuItem1 = ContextMenuItem(
        label: 'Test',
        onTap: callback,
      );
      final menuItem2 = ContextMenuItem(
        label: 'Test',
        onTap: callback,
      );

      expect(menuItem1, menuItem2);
      expect(menuItem1.hashCode, menuItem2.hashCode);
    });

    test('equality returns false for different labels', () {
      void callback() {}

      final menuItem1 = ContextMenuItem(
        label: 'Test1',
        onTap: callback,
      );
      final menuItem2 = ContextMenuItem(
        label: 'Test2',
        onTap: callback,
      );

      expect(menuItem1, isNot(menuItem2));
    });

    test('equality returns false for different callbacks', () {
      void callback1() {}
      void callback2() {}

      final menuItem1 = ContextMenuItem(
        label: 'Test',
        onTap: callback1,
      );
      final menuItem2 = ContextMenuItem(
        label: 'Test',
        onTap: callback2,
      );

      expect(menuItem1, isNot(menuItem2));
    });

    test('equality returns false for different icons', () {
      void callback() {}
      const icon1 = Icon(Icons.open_in_new);
      const icon2 = Icon(Icons.close);

      final menuItem1 = ContextMenuItem(
        label: 'Test',
        onTap: callback,
        icon: icon1,
      );
      final menuItem2 = ContextMenuItem(
        label: 'Test',
        onTap: callback,
        icon: icon2,
      );

      expect(menuItem1, isNot(menuItem2));
    });

    test('equality returns true for identical object', () {
      final menuItem = ContextMenuItem(
        label: 'Test',
        onTap: () {},
      );

      expect(menuItem, menuItem);
    });

    test('hashCode is consistent', () {
      final menuItem = ContextMenuItem(
        label: 'Test',
        onTap: () {},
      );

      expect(menuItem.hashCode, menuItem.hashCode);
    });

    test('can have empty label', () {
      final menuItem = ContextMenuItem(
        label: '',
        onTap: () {},
      );

      expect(menuItem.label, '');
    });

    test('can have special characters in label', () {
      final menuItem = ContextMenuItem(
        label: 'Test & Special!',
        onTap: () {},
      );

      expect(menuItem.label, 'Test & Special!');
    });
  });
}
