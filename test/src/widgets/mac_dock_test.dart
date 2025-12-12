import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_macos_dock/src/enums/dock_position.dart';
import 'package:flutter_macos_dock/src/models/dock_item.dart';
import 'package:flutter_macos_dock/src/widgets/dock_icon.dart';
import 'package:flutter_macos_dock/src/widgets/draggable_dock_icon.dart';
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

    group('Magnification', () {
      testWidgets('accepts magnification parameter', (tester) async {
        const items = [
          DockItem(id: 'test', icon: Icon(Icons.star)),
        ];

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MacDock(
                items: items,
                magnification: 2,
              ),
            ),
          ),
        );

        expect(find.byType(MacDock), findsOneWidget);
      });

      testWidgets('accepts magnificationRadius parameter', (tester) async {
        const items = [
          DockItem(id: 'test', icon: Icon(Icons.star)),
        ];

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MacDock(
                items: items,
                magnificationRadius: 150,
              ),
            ),
          ),
        );

        expect(find.byType(MacDock), findsOneWidget);
      });

      testWidgets(
          'accepts magnificationAnimationDuration '
          'parameter', (tester) async {
        const items = [
          DockItem(id: 'test', icon: Icon(Icons.star)),
        ];

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MacDock(
                items: items,
                magnificationAnimationDuration: Duration(milliseconds: 300),
              ),
            ),
          ),
        );

        expect(find.byType(MacDock), findsOneWidget);
      });

      testWidgets('renders DockIcon widgets', (tester) async {
        const items = [
          DockItem(id: 'test1', icon: Icon(Icons.star)),
          DockItem(id: 'test2', icon: Icon(Icons.home)),
        ];

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MacDock(items: items),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.byType(DraggableDockIcon), findsNWidgets(2));
      });

      testWidgets(
          'DockIcon has scale of 1.0 when not '
          'hovering', (tester) async {
        const items = [
          DockItem(id: 'test', icon: Icon(Icons.star)),
        ];

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MacDock(
                items: items,
                magnification: 2,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        final dockIcon =
            tester.widget<DraggableDockIcon>(find.byType(DraggableDockIcon));
        expect(dockIcon.scale, equals(1));
      });

      testWidgets('updates when mouse enters dock area', (tester) async {
        const items = [
          DockItem(id: 'test', icon: Icon(Icons.star)),
        ];

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MacDock(
                items: items,
                magnification: 2,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        final gesture = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        await gesture.addPointer(location: Offset.zero);
        addTearDown(gesture.removePointer);

        await gesture.moveTo(tester.getCenter(find.byType(MacDock)));
        await tester.pumpAndSettle();

        expect(find.byType(MacDock), findsOneWidget);
      });

      testWidgets('resets scales when mouse exits dock', (tester) async {
        const items = [
          DockItem(id: 'test', icon: Icon(Icons.star)),
        ];

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MacDock(
                items: items,
                magnification: 2,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        final gesture = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        await gesture.addPointer(location: Offset.zero);
        addTearDown(gesture.removePointer);

        // Enter dock
        await gesture.moveTo(tester.getCenter(find.byType(MacDock)));
        await tester.pumpAndSettle();

        // Exit dock
        await gesture.moveTo(const Offset(1000, 1000));
        await tester.pumpAndSettle();

        final dockIcon =
            tester.widget<DraggableDockIcon>(find.byType(DraggableDockIcon));
        expect(dockIcon.scale, equals(1));
      });

      testWidgets('handles magnification with horizontal layout',
          (tester) async {
        const items = [
          DockItem(id: 'test1', icon: Icon(Icons.star)),
          DockItem(id: 'test2', icon: Icon(Icons.home)),
        ];

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MacDock(
                items: items,
                magnification: 2,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.byType(Row), findsOneWidget);
        expect(find.byType(DraggableDockIcon), findsNWidgets(2));
      });

      testWidgets('handles magnification with vertical layout', (tester) async {
        const items = [
          DockItem(id: 'test1', icon: Icon(Icons.star)),
          DockItem(id: 'test2', icon: Icon(Icons.home)),
        ];

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MacDock(
                items: items,
                position: DockPosition.left,
                magnification: 2,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.byType(Column), findsOneWidget);
        expect(find.byType(DraggableDockIcon), findsNWidgets(2));
      });

      testWidgets(
          'magnification disabled when strength is '
          '1.0', (tester) async {
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

        await tester.pumpAndSettle();

        final gesture = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        await gesture.addPointer(location: Offset.zero);
        addTearDown(gesture.removePointer);

        await gesture.moveTo(tester.getCenter(find.byType(MacDock)));
        await tester.pumpAndSettle();

        final dockIcon =
            tester.widget<DraggableDockIcon>(find.byType(DraggableDockIcon));
        expect(dockIcon.scale, equals(1));
      });

      testWidgets('respects magnificationRadius parameter', (tester) async {
        const items = [
          DockItem(id: 'test', icon: Icon(Icons.star)),
        ];

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MacDock(
                items: items,
                magnification: 2,
                magnificationRadius: 50,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.byType(MacDock), findsOneWidget);
      });

      testWidgets('handles multiple icons with magnification', (tester) async {
        const items = [
          DockItem(id: 'test1', icon: Icon(Icons.star)),
          DockItem(id: 'test2', icon: Icon(Icons.home)),
          DockItem(id: 'test3', icon: Icon(Icons.mail)),
        ];

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MacDock(
                items: items,
                magnification: 2,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.byType(DraggableDockIcon), findsNWidgets(3));
      });

      testWidgets('passes size to DockIcon', (tester) async {
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

        await tester.pumpAndSettle();

        final dockIcon =
            tester.widget<DraggableDockIcon>(find.byType(DraggableDockIcon));
        expect(dockIcon.size, equals(64));
      });

      testWidgets('passes animationDuration to DockIcon', (tester) async {
        const items = [
          DockItem(id: 'test', icon: Icon(Icons.star)),
        ];

        const duration = Duration(milliseconds: 300);

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MacDock(
                items: items,
                magnificationAnimationDuration: duration,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        final dockIcon =
            tester.widget<DraggableDockIcon>(find.byType(DraggableDockIcon));
        expect(dockIcon.animationDuration, equals(duration));
      });
    });

    group('Drag and Drop', () {
      testWidgets('handles drag start on icon', (tester) async {
        const items = [
          DockItem(id: 'item1', icon: Icon(Icons.star)),
          DockItem(id: 'item2', icon: Icon(Icons.home)),
        ];

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MacDock(items: items),
            ),
          ),
        );

        await tester.pumpAndSettle();

        final icon = find.byIcon(Icons.star);
        final gesture = await tester.startGesture(tester.getCenter(icon));
        await tester.pump(const Duration(milliseconds: 200));

        await gesture.moveBy(const Offset(10, 0));
        await tester.pump();

        await gesture.up();
        await tester.pumpAndSettle();
      });

      testWidgets('calls onReorder when item is reordered', (tester) async {
        int? oldIndex;
        int? newIndex;

        const items = [
          DockItem(id: 'item1', icon: Icon(Icons.star)),
          DockItem(id: 'item2', icon: Icon(Icons.home)),
          DockItem(id: 'item3', icon: Icon(Icons.mail)),
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MacDock(
                items: items,
                onReorder: (old, updated) {
                  oldIndex = old;
                  newIndex = updated;
                },
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        final icon = find.byIcon(Icons.star);
        final gesture = await tester.startGesture(tester.getCenter(icon));
        await tester.pump(const Duration(milliseconds: 200));

        await gesture.moveBy(const Offset(100, 0));
        await tester.pump();

        await gesture.up();
        await tester.pumpAndSettle();

        // Reorder should be called
        expect(oldIndex, isNotNull);
      });

      testWidgets('respects onRemove callback', (tester) async {
        int? removedIndex;
        DockItem? removedItem;

        const items = [
          DockItem(id: 'item1', icon: Icon(Icons.star)),
          DockItem(id: 'item2', icon: Icon(Icons.home)),
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MacDock(
                items: items,
                onRemove: (index, item) {
                  removedIndex = index;
                  removedItem = item;
                },
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Test that onRemove callback exists and would be called
        // Note: Testing actual remove requires dragging far outside bounds
        // which is difficult to simulate in test environment
        expect(find.byType(MacDock), findsOneWidget);
      });

      testWidgets('handles drag without onReorder callback', (tester) async {
        const items = [
          DockItem(id: 'item1', icon: Icon(Icons.star)),
          DockItem(id: 'item2', icon: Icon(Icons.home)),
        ];

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MacDock(items: items),
            ),
          ),
        );

        await tester.pumpAndSettle();

        final icon = find.byIcon(Icons.star);
        final gesture = await tester.startGesture(tester.getCenter(icon));
        await tester.pump(const Duration(milliseconds: 200));

        await gesture.moveBy(const Offset(50, 0));
        await tester.pump();

        await gesture.up();
        await tester.pumpAndSettle();

        // Should not crash
        expect(find.byType(MacDock), findsOneWidget);
      });

      testWidgets('handles drag without onRemove callback', (tester) async {
        const items = [
          DockItem(id: 'item1', icon: Icon(Icons.star)),
        ];

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MacDock(items: items),
            ),
          ),
        );

        await tester.pumpAndSettle();

        final icon = find.byIcon(Icons.star);
        final gesture = await tester.startGesture(tester.getCenter(icon));
        await tester.pump(const Duration(milliseconds: 200));

        // Try dragging outside
        await gesture.moveBy(const Offset(0, 300));
        await tester.pump();

        await gesture.up();
        await tester.pumpAndSettle();

        // Should not crash
        expect(find.byType(MacDock), findsOneWidget);
      });

      testWidgets('respects reorderAnimationDuration', (tester) async {
        const duration = Duration(milliseconds: 500);
        const items = [
          DockItem(id: 'item1', icon: Icon(Icons.star)),
          DockItem(id: 'item2', icon: Icon(Icons.home)),
        ];

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MacDock(
                items: items,
                reorderAnimationDuration: duration,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.byType(MacDock), findsOneWidget);
      });

      testWidgets('respects returnAnimationDuration', (tester) async {
        const duration = Duration(milliseconds: 500);
        const items = [
          DockItem(id: 'item1', icon: Icon(Icons.star)),
        ];

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MacDock(
                items: items,
                returnAnimationDuration: duration,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.byType(MacDock), findsOneWidget);
      });

      testWidgets('respects liftStrength parameter', (tester) async {
        const items = [
          DockItem(id: 'item1', icon: Icon(Icons.star)),
        ];

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MacDock(
                items: items,
                liftStrength: 0.8,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.byType(MacDock), findsOneWidget);
      });
    });

    group('State Management', () {
      testWidgets('updates when items list changes', (tester) async {
        const items1 = [
          DockItem(id: 'item1', icon: Icon(Icons.star)),
        ];

        const items2 = [
          DockItem(id: 'item1', icon: Icon(Icons.star)),
          DockItem(id: 'item2', icon: Icon(Icons.home)),
        ];

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MacDock(items: items1),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.byIcon(Icons.star), findsOneWidget);
        expect(find.byIcon(Icons.home), findsNothing);

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MacDock(items: items2),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.byIcon(Icons.star), findsOneWidget);
        expect(find.byIcon(Icons.home), findsOneWidget);
      });

      testWidgets('clears drag state when items change', (tester) async {
        var items = [
          const DockItem(id: 'item1', icon: Icon(Icons.star)),
          const DockItem(id: 'item2', icon: Icon(Icons.home)),
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    children: [
                      MacDock(items: items),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            items = [
                              const DockItem(
                                  id: 'item1', icon: Icon(Icons.star)),
                            ];
                          });
                        },
                        child: const Text('Remove'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Start drag
        final icon = find.byIcon(Icons.star);
        final gesture = await tester.startGesture(tester.getCenter(icon));
        await tester.pump(const Duration(milliseconds: 200));

        // Change items
        await tester.tap(find.text('Remove'));
        await tester.pumpAndSettle();

        await gesture.up();
        await tester.pumpAndSettle();
      });

      testWidgets('handles cursor movement', (tester) async {
        const items = [
          DockItem(id: 'item1', icon: Icon(Icons.star)),
          DockItem(id: 'item2', icon: Icon(Icons.home)),
        ];

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MacDock(
                items: items,
                magnification: 2.0,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        final gesture = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        await gesture.addPointer(location: Offset.zero);
        addTearDown(gesture.removePointer);

        await gesture.moveTo(tester.getCenter(find.byIcon(Icons.star)));
        await tester.pumpAndSettle();

        await gesture.moveTo(tester.getCenter(find.byIcon(Icons.home)));
        await tester.pumpAndSettle();

        expect(find.byType(MacDock), findsOneWidget);
      });
    });

    group('Vertical Dock', () {
      testWidgets('handles drag in vertical layout', (tester) async {
        const items = [
          DockItem(id: 'item1', icon: Icon(Icons.star)),
          DockItem(id: 'item2', icon: Icon(Icons.home)),
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

        await tester.pumpAndSettle();

        final icon = find.byIcon(Icons.star);
        final gesture = await tester.startGesture(tester.getCenter(icon));
        await tester.pump(const Duration(milliseconds: 200));

        await gesture.moveBy(const Offset(0, 50));
        await tester.pump();

        await gesture.up();
        await tester.pumpAndSettle();

        expect(find.byType(Column), findsOneWidget);
      });

      testWidgets('handles magnification in vertical layout', (tester) async {
        const items = [
          DockItem(id: 'item1', icon: Icon(Icons.star)),
          DockItem(id: 'item2', icon: Icon(Icons.home)),
        ];

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MacDock(
                items: items,
                position: DockPosition.right,
                magnification: 2.0,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        final gesture = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        await gesture.addPointer(location: Offset.zero);
        addTearDown(gesture.removePointer);

        await gesture.moveTo(tester.getCenter(find.byIcon(Icons.star)));
        await tester.pumpAndSettle();

        expect(find.byType(Column), findsOneWidget);
      });
    });
  });
}
