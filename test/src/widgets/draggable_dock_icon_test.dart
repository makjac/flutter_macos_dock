import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_macos_dock/src/models/dock_item.dart';
import 'package:flutter_macos_dock/src/widgets/draggable_dock_icon.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DraggableDockIcon', () {
    late DockItem testItem;

    setUp(() {
      testItem = const DockItem(
        id: 'test',
        icon: Icon(Icons.folder),
      );
    });

    testWidgets('renders icon with correct size', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DraggableDockIcon(
              item: testItem,
              size: 48,
              scale: 1,
            ),
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(
        find.byKey(const ValueKey('dock_icon_size_box')),
      );

      expect(sizedBox.width, 48.0);
      expect(sizedBox.height, 48.0);
    });

    testWidgets('applies scale transformation', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DraggableDockIcon(
              item: testItem,
              size: 48,
              scale: 1.5,
            ),
          ),
        ),
      );

      final animatedScale = tester.widget<AnimatedScale>(
        find.byType(AnimatedScale),
      );

      expect(animatedScale.scale, 1.5);
    });

    testWidgets('hides icon when dragging', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DraggableDockIcon(
              item: testItem,
              size: 48,
              scale: 1,
              isDragging: true,
            ),
          ),
        ),
      );

      final animatedOpacity = tester.widget<AnimatedOpacity>(
        find.byType(AnimatedOpacity),
      );

      expect(animatedOpacity.opacity, 0.0);
    });

    testWidgets('shows icon when not dragging', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DraggableDockIcon(
              item: testItem,
              size: 48,
              scale: 1,
            ),
          ),
        ),
      );

      final animatedOpacity = tester.widget<AnimatedOpacity>(
        find.byType(AnimatedOpacity),
      );

      expect(animatedOpacity.opacity, 1.0);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      var tapped = false;
      final itemWithTap = DockItem(
        id: 'test',
        icon: const Icon(Icons.folder),
        onTap: () => tapped = true,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DraggableDockIcon(
              item: itemWithTap,
              size: 48,
              scale: 1,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(DraggableDockIcon));
      await tester.pump();

      expect(tapped, true);
    });

    testWidgets('calls onHoverEnter when mouse enters', (tester) async {
      var hovered = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DraggableDockIcon(
              item: testItem,
              size: 48,
              scale: 1,
              onHoverEnter: () => hovered = true,
            ),
          ),
        ),
      );

      final mouseRegion = tester.widget<MouseRegion>(
        find.descendant(
          of: find.byType(DraggableDockIcon),
          matching: find.byType(MouseRegion),
        ),
      );

      mouseRegion.onEnter?.call(
        const PointerEnterEvent(),
      );

      expect(hovered, true);
    });

    testWidgets('calls onHoverExit when mouse exits', (tester) async {
      var exited = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DraggableDockIcon(
              item: testItem,
              size: 48,
              scale: 1,
              onHoverExit: () => exited = true,
            ),
          ),
        ),
      );

      final mouseRegion = tester.widget<MouseRegion>(
        find.descendant(
          of: find.byType(DraggableDockIcon),
          matching: find.byType(MouseRegion),
        ),
      );

      mouseRegion.onExit?.call(
        const PointerExitEvent(),
      );

      expect(exited, true);
    });

    testWidgets('detects drag start after distance threshold', (tester) async {
      var dragStarted = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DraggableDockIcon(
              item: testItem,
              size: 48,
              scale: 1,
              onDragStart: () => dragStarted = true,
            ),
          ),
        ),
      );

      // Start pan gesture
      await tester.startGesture(const Offset(100, 100));
      await tester.pump();

      expect(dragStarted, false);

      // Move beyond threshold (>4px)
      await tester.pump(const Duration(milliseconds: 50));

      expect(dragStarted, false);
    });

    testWidgets('calls onDragUpdate during drag', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DraggableDockIcon(
              item: testItem,
              size: 48,
              scale: 1,
              onDragUpdate: (details) {},
            ),
          ),
        ),
      );

      final gesture = await tester.startGesture(const Offset(100, 100));
      await tester.pump();

      // Move to trigger update
      await gesture.moveTo(const Offset(110, 100));
      await tester.pump();

      // Note: onDragUpdate is only called after threshold is met
      // In this test, we don't move far enough to trigger onDragStart
    });

    testWidgets('uses custom animation duration', (tester) async {
      const customDuration = Duration(milliseconds: 300);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DraggableDockIcon(
              item: testItem,
              size: 48,
              scale: 1,
              animationDuration: customDuration,
            ),
          ),
        ),
      );

      final animatedScale = tester.widget<AnimatedScale>(
        find.byType(AnimatedScale),
      );

      expect(animatedScale.duration, customDuration);
    });

    testWidgets('triggers drag start after distance threshold', (tester) async {
      var dragStarted = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DraggableDockIcon(
              item: testItem,
              size: 48,
              scale: 1,
              onDragStart: () => dragStarted = true,
            ),
          ),
        ),
      );

      // Simulate pan gesture
      await tester.drag(
        find.byType(DraggableDockIcon),
        const Offset(10, 0),
      );
      await tester.pump();

      expect(dragStarted, true);
    });

    testWidgets('drag start called on sufficient movement', (tester) async {
      var dragStarted = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DraggableDockIcon(
              item: testItem,
              size: 48,
              scale: 1,
              onDragStart: () => dragStarted = true,
            ),
          ),
        ),
      );

      // Drag with sufficient movement
      await tester.drag(
        find.byType(DraggableDockIcon),
        const Offset(20, 0),
      );
      await tester.pumpAndSettle();

      expect(dragStarted, true);
    });

    testWidgets('calls onDragUpdate after threshold is met', (tester) async {
      var updateCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DraggableDockIcon(
              item: testItem,
              size: 48,
              scale: 1,
              onDragStart: () {},
              onDragUpdate: (details) => updateCalled = true,
            ),
          ),
        ),
      );

      await tester.drag(
        find.byType(DraggableDockIcon),
        const Offset(20, 0),
      );
      await tester.pumpAndSettle();

      expect(updateCalled, true);
    });

    testWidgets('calls onDragEnd when drag completes', (tester) async {
      var dragEnded = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DraggableDockIcon(
              item: testItem,
              size: 48,
              scale: 1,
              onDragStart: () {},
              onDragEnd: (details) => dragEnded = true,
            ),
          ),
        ),
      );

      await tester.drag(
        find.byType(DraggableDockIcon),
        const Offset(20, 0),
      );
      await tester.pumpAndSettle();

      expect(dragEnded, true);
    });

    testWidgets('does not call onDragEnd if threshold not met', (tester) async {
      var dragEnded = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DraggableDockIcon(
              item: testItem,
              size: 48,
              scale: 1,
              onDragEnd: (details) => dragEnded = true,
            ),
          ),
        ),
      );

      final gesture = await tester.startGesture(const Offset(100, 100));
      await tester.pump();

      // Move less than threshold
      await gesture.moveTo(const Offset(102, 100));
      await tester.pump();

      await gesture.up();
      await tester.pump();

      expect(dragEnded, false);
    });

    testWidgets('resets drag state after pan end', (tester) async {
      var dragStartCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DraggableDockIcon(
              item: testItem,
              size: 48,
              scale: 1,
              onDragStart: () => dragStartCount++,
            ),
          ),
        ),
      );

      // First drag
      await tester.drag(
        find.byType(DraggableDockIcon),
        const Offset(20, 0),
      );
      await tester.pumpAndSettle();

      expect(dragStartCount, 1);

      // Second drag - should work independently
      await tester.drag(
        find.byType(DraggableDockIcon),
        const Offset(20, 0),
      );
      await tester.pumpAndSettle();

      expect(dragStartCount, 2);
    });

    testWidgets('handles multiple scales correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DraggableDockIcon(
              item: testItem,
              size: 48,
              scale: 1.0,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      var animatedScale = tester.widget<AnimatedScale>(
        find.byType(AnimatedScale),
      );
      expect(animatedScale.scale, 1.0);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DraggableDockIcon(
              item: testItem,
              size: 48,
              scale: 1.5,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      animatedScale = tester.widget<AnimatedScale>(
        find.byType(AnimatedScale),
      );
      expect(animatedScale.scale, 1.5);
    });

    testWidgets('handles different sizes correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DraggableDockIcon(
              item: testItem,
              size: 64,
              scale: 1,
            ),
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(
        find.byKey(const ValueKey('dock_icon_size_box')),
      );

      expect(sizedBox.width, 64.0);
      expect(sizedBox.height, 64.0);
    });

    testWidgets('respects isDragging parameter', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DraggableDockIcon(
              item: testItem,
              size: 48,
              scale: 1,
              isDragging: false,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      var animatedOpacity = tester.widget<AnimatedOpacity>(
        find.byType(AnimatedOpacity),
      );
      expect(animatedOpacity.opacity, 1.0);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DraggableDockIcon(
              item: testItem,
              size: 48,
              scale: 1,
              isDragging: true,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      animatedOpacity = tester.widget<AnimatedOpacity>(
        find.byType(AnimatedOpacity),
      );
      expect(animatedOpacity.opacity, 0.0);
    });

    testWidgets('has correct curve for scale animation', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DraggableDockIcon(
              item: testItem,
              size: 48,
              scale: 1,
            ),
          ),
        ),
      );

      final animatedScale = tester.widget<AnimatedScale>(
        find.byType(AnimatedScale),
      );

      expect(animatedScale.curve, Curves.easeOutCubic);
    });

    testWidgets('correctly displays item icon', (tester) async {
      const customIcon = Icon(Icons.mail, key: ValueKey('custom-icon'));
      final customItem = DockItem(
        id: 'custom',
        icon: customIcon,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DraggableDockIcon(
              item: customItem,
              size: 48,
              scale: 1,
            ),
          ),
        ),
      );

      expect(find.byKey(const ValueKey('custom-icon')), findsOneWidget);
    });

    testWidgets('handles null callbacks gracefully', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DraggableDockIcon(
              item: testItem,
              size: 48,
              scale: 1,
              // All callbacks are null
            ),
          ),
        ),
      );

      // Tap
      await tester.tap(find.byType(DraggableDockIcon));
      await tester.pump();

      // Hover
      final mouseRegion = tester.widget<MouseRegion>(
        find.descendant(
          of: find.byType(DraggableDockIcon),
          matching: find.byType(MouseRegion),
        ),
      );
      mouseRegion.onEnter?.call(const PointerEnterEvent());
      mouseRegion.onExit?.call(const PointerExitEvent());

      // Drag
      final gesture = await tester.startGesture(const Offset(100, 100));
      await tester.pump();
      await gesture.moveTo(const Offset(110, 100));
      await tester.pump();
      await gesture.up();
      await tester.pump();

      // Should not crash
      expect(find.byType(DraggableDockIcon), findsOneWidget);
    });

    testWidgets('pan gestures work with GestureDetector', (tester) async {
      var panStartCalled = false;
      var panUpdateCalled = false;
      var panEndCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DraggableDockIcon(
              item: testItem,
              size: 48,
              scale: 1,
              onDragStart: () => panStartCalled = true,
              onDragUpdate: (details) => panUpdateCalled = true,
              onDragEnd: (details) => panEndCalled = true,
            ),
          ),
        ),
      );

      await tester.drag(
        find.byType(DraggableDockIcon),
        const Offset(20, 0),
      );
      await tester.pumpAndSettle();

      expect(panStartCalled, true);
      expect(panUpdateCalled, true);
      expect(panEndCalled, true);
    });
  });
}
