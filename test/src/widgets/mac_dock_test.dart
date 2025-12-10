import 'package:flutter/material.dart';
import 'package:flutter_macos_dock/src/enums/dock_position.dart';
import 'package:flutter_macos_dock/src/models/dock_item.dart';
import 'package:flutter_macos_dock/src/widgets/mac_dock.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MacDock', () {
    testWidgets('renders with required parameters', (tester) async {
      const items = [
        DockItem(id: 'test', icon: Icon(Icons.star)),
      ];

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MacDock(items: items),
          ),
        ),
      );

      expect(find.byType(MacDock), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('renders multiple items', (tester) async {
      const items = [
        DockItem(id: 'item1', icon: Icon(Icons.star)),
        DockItem(id: 'item2', icon: Icon(Icons.home)),
        DockItem(id: 'item3', icon: Icon(Icons.mail)),
      ];

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MacDock(items: items),
          ),
        ),
      );

      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.mail), findsOneWidget);
    });

    testWidgets('renders nothing when items list is empty', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MacDock(items: <DockItem>[]),
          ),
        ),
      );

      expect(find.byType(Row), findsNothing);
      expect(find.byType(Column), findsNothing);
    });

    testWidgets('uses Row for bottom position', (tester) async {
      const items = [
        DockItem(id: 'test', icon: Icon(Icons.star)),
      ];

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MacDock(
              items: items,
            ),
          ),
        ),
      );

      expect(find.byType(Row), findsOneWidget);
      expect(find.byType(Column), findsNothing);
    });

    testWidgets('uses Row for top position', (tester) async {
      const items = [
        DockItem(id: 'test', icon: Icon(Icons.star)),
      ];

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MacDock(
              items: items,
              position: DockPosition.top,
            ),
          ),
        ),
      );

      expect(find.byType(Row), findsOneWidget);
      expect(find.byType(Column), findsNothing);
    });

    testWidgets('uses Column for left position', (tester) async {
      const items = [
        DockItem(id: 'test', icon: Icon(Icons.star)),
      ];

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MacDock(
              items: items,
              position: DockPosition.left,
            ),
          ),
        ),
      );

      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(Row), findsNothing);
    });

    testWidgets('uses Column for right position', (tester) async {
      const items = [
        DockItem(id: 'test', icon: Icon(Icons.star)),
      ];

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MacDock(
              items: items,
              position: DockPosition.right,
            ),
          ),
        ),
      );

      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(Row), findsNothing);
    });

    testWidgets('applies default size to icons', (tester) async {
      const items = [
        DockItem(id: 'test', icon: Icon(Icons.star)),
      ];

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MacDock(items: items),
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(
        find.ancestor(
          of: find.byIcon(Icons.star),
          matching: find.byType(SizedBox),
        ),
      );

      expect(sizedBox.width, 48.0);
      expect(sizedBox.height, 48.0);
    });

    testWidgets('applies custom size to icons', (tester) async {
      const items = [
        DockItem(id: 'test', icon: Icon(Icons.star)),
      ];

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MacDock(
              items: items,
              size: 64,
            ),
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(
        find.ancestor(
          of: find.byIcon(Icons.star),
          matching: find.byType(SizedBox),
        ),
      );

      expect(sizedBox.width, 64);
      expect(sizedBox.height, 64);
    });

    testWidgets('invokes onTap callback when icon is tapped', (tester) async {
      var tapped = false;
      final items = [
        DockItem(
          id: 'test',
          icon: const Icon(Icons.star),
          onTap: () {
            tapped = true;
          },
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MacDock(items: items),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.star));
      await tester.pump();

      expect(tapped, true);
    });

    testWidgets('does not crash when onTap is null', (tester) async {
      const items = [
        DockItem(
          id: 'test',
          icon: Icon(Icons.star),
        ),
      ];

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MacDock(items: items),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.star));
      await tester.pump();
    });

    testWidgets('renders all icons with correct sizes', (tester) async {
      const items = [
        DockItem(id: 'item1', icon: Icon(Icons.star)),
        DockItem(id: 'item2', icon: Icon(Icons.home)),
        DockItem(id: 'item3', icon: Icon(Icons.mail)),
      ];

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MacDock(
              items: items,
              size: 50,
            ),
          ),
        ),
      );

      final sizedBoxes = tester.widgetList<SizedBox>(
        find.byType(SizedBox),
      );

      var count = 0;
      for (final sizedBox in sizedBoxes) {
        if (sizedBox.width == 50 && sizedBox.height == 50) {
          count++;
        }
      }

      expect(count, 3);
    });

    testWidgets('uses default position when not specified', (tester) async {
      const items = [
        DockItem(id: 'test', icon: Icon(Icons.star)),
      ];

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MacDock(items: items),
          ),
        ),
      );

      expect(find.byType(Row), findsOneWidget);
    });

    testWidgets('handles single item correctly', (tester) async {
      const items = [
        DockItem(id: 'single', icon: Icon(Icons.folder)),
      ];

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MacDock(items: items),
          ),
        ),
      );

      expect(find.byIcon(Icons.folder), findsOneWidget);
    });

    testWidgets('maintains item order', (tester) async {
      const items = [
        DockItem(id: 'first', icon: Icon(Icons.looks_one)),
        DockItem(id: 'second', icon: Icon(Icons.looks_two)),
        DockItem(id: 'third', icon: Icon(Icons.looks_3)),
      ];

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MacDock(items: items),
          ),
        ),
      );

      final row = tester.widget<Row>(find.byType(Row));
      expect(row.children.length, 3);
    });

    testWidgets('can render with very small size', (tester) async {
      const items = [
        DockItem(id: 'test', icon: Icon(Icons.star)),
      ];

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MacDock(
              items: items,
              size: 16,
            ),
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(
        find.ancestor(
          of: find.byIcon(Icons.star),
          matching: find.byType(SizedBox),
        ),
      );

      expect(sizedBox.width, 16);
      expect(sizedBox.height, 16);
    });

    testWidgets('can render with very large size', (tester) async {
      const items = [
        DockItem(id: 'test', icon: Icon(Icons.star)),
      ];

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MacDock(
              items: items,
              size: 128,
            ),
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(
        find.ancestor(
          of: find.byIcon(Icons.star),
          matching: find.byType(SizedBox),
        ),
      );

      expect(sizedBox.width, 128);
      expect(sizedBox.height, 128);
    });
  });
}
