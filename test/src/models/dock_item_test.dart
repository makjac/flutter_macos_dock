import 'package:flutter/material.dart';
import 'package:flutter_macos_dock/src/models/context_menu_item.dart';
import 'package:flutter_macos_dock/src/models/dock_badge.dart';
import 'package:flutter_macos_dock/src/models/dock_item.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DockItem', () {
    test('can be instantiated with required parameters only', () {
      const icon = Icon(Icons.home);
      const dockItem = DockItem(
        id: 'home',
        icon: icon,
      );

      expect(dockItem, isNotNull);
      expect(dockItem.id, 'home');
      expect(dockItem.icon, icon);
      expect(dockItem.tooltip, isNull);
      expect(dockItem.onTap, isNull);
      expect(dockItem.onRemove, isNull);
      expect(dockItem.contextMenuItems, isNull);
      expect(dockItem.badge, isNull);
      expect(dockItem.showIndicator, false);
      expect(dockItem.data, isNull);
    });

    test('can be instantiated with all parameters', () {
      const icon = Icon(Icons.mail);
      const badge = DockBadge(count: 5);
      void onTap() {}
      void onRemove() {}
      void menuCallback() {}
      final menuItem = ContextMenuItem(
        label: 'Open',
        onTap: menuCallback,
      );

      final dockItem = DockItem(
        id: 'mail',
        icon: icon,
        tooltip: 'Mail',
        onTap: onTap,
        onRemove: onRemove,
        contextMenuItems: [menuItem],
        badge: badge,
        showIndicator: true,
        data: const {'key': 'value'},
      );

      expect(dockItem.id, 'mail');
      expect(dockItem.icon, icon);
      expect(dockItem.tooltip, 'Mail');
      expect(dockItem.onTap, onTap);
      expect(dockItem.onRemove, onRemove);
      expect(dockItem.contextMenuItems, [menuItem]);
      expect(dockItem.badge, badge);
      expect(dockItem.showIndicator, true);
      expect(dockItem.data, {'key': 'value'});
    });

    test('onTap callback is invoked correctly', () {
      var tapped = false;
      final dockItem = DockItem(
        id: 'test',
        icon: const Icon(Icons.star),
        onTap: () {
          tapped = true;
        },
      );

      dockItem.onTap?.call();
      expect(tapped, true);
    });

    test('onRemove callback is invoked correctly', () {
      var removed = false;
      final dockItem = DockItem(
        id: 'test',
        icon: const Icon(Icons.star),
        onRemove: () {
          removed = true;
        },
      );

      dockItem.onRemove?.call();
      expect(removed, true);
    });

    test('copyWith returns new instance with updated id', () {
      const original = DockItem(
        id: 'old',
        icon: Icon(Icons.star),
      );
      final updated = original.copyWith(id: 'new');

      expect(updated.id, 'new');
      expect(updated.icon, original.icon);
      expect(updated, isNot(same(original)));
    });

    test('copyWith returns new instance with updated icon', () {
      const original = DockItem(
        id: 'test',
        icon: Icon(Icons.star),
      );
      const newIcon = Icon(Icons.home);
      final updated = original.copyWith(icon: newIcon);

      expect(updated.icon, newIcon);
      expect(updated.id, original.id);
    });

    test('copyWith preserves original values when not overridden', () {
      const badge = DockBadge(count: 5);
      void callback() {}
      final menuItem = ContextMenuItem(
        label: 'Test',
        onTap: callback,
      );

      final original = DockItem(
        id: 'test',
        icon: const Icon(Icons.star),
        tooltip: 'Test tooltip',
        onTap: callback,
        onRemove: callback,
        contextMenuItems: [menuItem],
        badge: badge,
        showIndicator: true,
        data: 'test data',
      );

      final updated = original.copyWith(tooltip: 'Updated');

      expect(updated.id, original.id);
      expect(updated.icon, original.icon);
      expect(updated.tooltip, 'Updated');
      expect(updated.onTap, original.onTap);
      expect(updated.onRemove, original.onRemove);
      expect(updated.contextMenuItems, original.contextMenuItems);
      expect(updated.badge, original.badge);
      expect(updated.showIndicator, original.showIndicator);
      expect(updated.data, original.data);
    });

    test('copyWith with no parameters returns equivalent item', () {
      const original = DockItem(
        id: 'test',
        icon: Icon(Icons.star),
        tooltip: 'Test',
      );
      final updated = original.copyWith();

      expect(updated.id, original.id);
      expect(updated.icon, original.icon);
      expect(updated.tooltip, original.tooltip);
    });

    test('equality works for identical instances', () {
      void callback() {}
      const icon = Icon(Icons.star);
      final item1 = DockItem(
        id: 'test',
        icon: icon,
        tooltip: 'Test',
        onTap: callback,
      );
      final item2 = DockItem(
        id: 'test',
        icon: icon,
        tooltip: 'Test',
        onTap: callback,
      );

      expect(item1, item2);
      expect(item1.hashCode, item2.hashCode);
    });

    test('equality returns false for different ids', () {
      const item1 = DockItem(id: 'test1', icon: Icon(Icons.star));
      const item2 = DockItem(id: 'test2', icon: Icon(Icons.star));

      expect(item1, isNot(item2));
    });

    test('equality returns false for different icons', () {
      const item1 = DockItem(id: 'test', icon: Icon(Icons.star));
      const item2 = DockItem(id: 'test', icon: Icon(Icons.home));

      expect(item1, isNot(item2));
    });

    test('equality returns false for different tooltips', () {
      const item1 = DockItem(
        id: 'test',
        icon: Icon(Icons.star),
        tooltip: 'Tooltip1',
      );
      const item2 = DockItem(
        id: 'test',
        icon: Icon(Icons.star),
        tooltip: 'Tooltip2',
      );

      expect(item1, isNot(item2));
    });

    test('equality returns false for different showIndicator', () {
      const item1 = DockItem(
        id: 'test',
        icon: Icon(Icons.star),
        showIndicator: true,
      );
      const item2 = DockItem(
        id: 'test',
        icon: Icon(Icons.star),
      );

      expect(item1, isNot(item2));
    });

    test('equality returns false for different badges', () {
      const item1 = DockItem(
        id: 'test',
        icon: Icon(Icons.star),
        badge: DockBadge(count: 1),
      );
      const item2 = DockItem(
        id: 'test',
        icon: Icon(Icons.star),
        badge: DockBadge(count: 2),
      );

      expect(item1, isNot(item2));
    });

    test('equality returns false for different context menu items', () {
      void callback() {}
      final menuItem1 = ContextMenuItem(label: 'Item1', onTap: callback);
      final menuItem2 = ContextMenuItem(label: 'Item2', onTap: callback);

      final item1 = DockItem(
        id: 'test',
        icon: const Icon(Icons.star),
        contextMenuItems: [menuItem1],
      );
      final item2 = DockItem(
        id: 'test',
        icon: const Icon(Icons.star),
        contextMenuItems: [menuItem2],
      );

      expect(item1, isNot(item2));
    });

    test('equality works with null context menu items', () {
      const icon = Icon(Icons.star);
      const item1 = DockItem(
        id: 'test',
        icon: icon,
      );
      const item2 = DockItem(
        id: 'test',
        icon: icon,
      );

      expect(item1, item2);
    });

    test('equality returns false for different data', () {
      const item1 = DockItem(
        id: 'test',
        icon: Icon(Icons.star),
        data: 'data1',
      );
      const item2 = DockItem(
        id: 'test',
        icon: Icon(Icons.star),
        data: 'data2',
      );

      expect(item1, isNot(item2));
    });

    test('equality returns true for identical object', () {
      const item = DockItem(id: 'test', icon: Icon(Icons.star));

      expect(item, item);
    });

    test('hashCode is consistent', () {
      const item = DockItem(id: 'test', icon: Icon(Icons.star));

      expect(item.hashCode, item.hashCode);
    });

    test('can have empty id', () {
      const item = DockItem(id: '', icon: Icon(Icons.star));

      expect(item.id, '');
    });

    test('can have multiple context menu items', () {
      void callback() {}
      final menuItem1 = ContextMenuItem(label: 'Item1', onTap: callback);
      final menuItem2 = ContextMenuItem(label: 'Item2', onTap: callback);
      final menuItem3 = ContextMenuItem(label: 'Item3', onTap: callback);

      final item = DockItem(
        id: 'test',
        icon: const Icon(Icons.star),
        contextMenuItems: [menuItem1, menuItem2, menuItem3],
      );

      expect(item.contextMenuItems?.length, 3);
    });

    test('can have empty context menu items list', () {
      const item = DockItem(
        id: 'test',
        icon: Icon(Icons.star),
        contextMenuItems: <ContextMenuItem>[],
      );

      expect(item.contextMenuItems, isEmpty);
    });
  });
}
