import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_macos_dock/src/models/dock_item.dart';
import 'package:flutter_macos_dock/src/widgets/dock_icon.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DockIcon', () {
    testWidgets('renders icon from DockItem', (tester) async {
      const testIcon = Icon(CupertinoIcons.folder);
      const item = DockItem(
        id: 'test',
        icon: testIcon,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DockIcon(
              item: item,
              size: 48,
              scale: 1,
            ),
          ),
        ),
      );

      expect(find.byIcon(CupertinoIcons.folder), findsOneWidget);
    });

    testWidgets('applies correct size', (tester) async {
      const testIcon = Icon(CupertinoIcons.folder);
      const item = DockItem(
        id: 'test',
        icon: testIcon,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DockIcon(
              item: item,
              size: 64,
              scale: 1,
            ),
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(
        find.ancestor(
          of: find.byIcon(CupertinoIcons.folder),
          matching: find.byType(SizedBox),
        ),
      );

      expect(sizedBox.width, equals(64));
      expect(sizedBox.height, equals(64));
    });

    testWidgets('applies correct scale', (tester) async {
      const testIcon = Icon(CupertinoIcons.folder);
      const item = DockItem(
        id: 'test',
        icon: testIcon,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DockIcon(
              item: item,
              size: 48,
              scale: 1.5,
            ),
          ),
        ),
      );

      final animatedScale = tester.widget<AnimatedScale>(
        find.byType(AnimatedScale),
      );

      expect(animatedScale.scale, equals(1.5));
    });

    testWidgets('invokes onTap callback when tapped', (tester) async {
      var tapped = false;
      const testIcon = Icon(CupertinoIcons.folder);
      final item = DockItem(
        id: 'test',
        icon: testIcon,
        onTap: () => tapped = true,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DockIcon(
              item: item,
              size: 48,
              scale: 1,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(DockIcon));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets('invokes onHoverEnter when mouse enters', (tester) async {
      var hovered = false;
      const testIcon = Icon(CupertinoIcons.folder);
      const item = DockItem(
        id: 'test',
        icon: testIcon,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DockIcon(
              item: item,
              size: 48,
              scale: 1,
              onHoverEnter: () => hovered = true,
            ),
          ),
        ),
      );

      final gesture = await tester.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      await gesture.moveTo(tester.getCenter(find.byType(DockIcon)));
      await tester.pumpAndSettle();

      expect(hovered, isTrue);
    });

    testWidgets('invokes onHoverExit when mouse exits', (tester) async {
      var exited = false;
      const testIcon = Icon(CupertinoIcons.folder);
      const item = DockItem(
        id: 'test',
        icon: testIcon,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DockIcon(
              item: item,
              size: 48,
              scale: 1,
              onHoverExit: () => exited = true,
            ),
          ),
        ),
      );

      final gesture = await tester.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      // Enter the widget
      await gesture.moveTo(tester.getCenter(find.byType(DockIcon)));
      await tester.pumpAndSettle();

      // Exit the widget
      await gesture.moveTo(const Offset(1000, 1000));
      await tester.pumpAndSettle();

      expect(exited, isTrue);
    });

    testWidgets('animates scale changes smoothly', (tester) async {
      const testIcon = Icon(CupertinoIcons.folder);
      const item = DockItem(
        id: 'test',
        icon: testIcon,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DockIcon(
              item: item,
              size: 48,
              scale: 1,
              animationDuration: Duration(milliseconds: 100),
            ),
          ),
        ),
      );

      // Initial scale
      var animatedScale = tester.widget<AnimatedScale>(
        find.byType(AnimatedScale),
      );
      expect(animatedScale.scale, equals(1));

      // Change scale
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DockIcon(
              item: item,
              size: 48,
              scale: 2,
              animationDuration: Duration(milliseconds: 100),
            ),
          ),
        ),
      );

      // Animation should be in progress
      await tester.pump(const Duration(milliseconds: 50));

      // Final scale after animation completes
      await tester.pumpAndSettle();
      animatedScale = tester.widget<AnimatedScale>(
        find.byType(AnimatedScale),
      );
      expect(animatedScale.scale, equals(2));
    });

    testWidgets('handles null onTap gracefully', (tester) async {
      const testIcon = Icon(CupertinoIcons.folder);
      const item = DockItem(
        id: 'test',
        icon: testIcon,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DockIcon(
              item: item,
              size: 48,
              scale: 1,
            ),
          ),
        ),
      );

      // Should not throw when tapped without onTap
      await tester.tap(find.byType(DockIcon));
      await tester.pumpAndSettle();

      // Verify widget still exists
      expect(find.byType(DockIcon), findsOneWidget);
    });

    testWidgets('handles null onHoverEnter gracefully', (tester) async {
      const testIcon = Icon(CupertinoIcons.folder);
      const item = DockItem(
        id: 'test',
        icon: testIcon,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DockIcon(
              item: item,
              size: 48,
              scale: 1,
            ),
          ),
        ),
      );

      final gesture = await tester.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      // Should not throw when hovering without onHoverEnter
      await gesture.moveTo(tester.getCenter(find.byType(DockIcon)));
      await tester.pumpAndSettle();

      // Verify widget still exists
      expect(find.byType(DockIcon), findsOneWidget);
    });

    testWidgets('handles null onHoverExit gracefully', (tester) async {
      const testIcon = Icon(CupertinoIcons.folder);
      const item = DockItem(
        id: 'test',
        icon: testIcon,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DockIcon(
              item: item,
              size: 48,
              scale: 1,
            ),
          ),
        ),
      );

      final gesture = await tester.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      await gesture.moveTo(tester.getCenter(find.byType(DockIcon)));
      await tester.pumpAndSettle();

      // Should not throw when exiting without onHoverExit
      await gesture.moveTo(const Offset(1000, 1000));
      await tester.pumpAndSettle();

      // Verify widget still exists
      expect(find.byType(DockIcon), findsOneWidget);
    });

    testWidgets('respects custom animation duration', (tester) async {
      const testIcon = Icon(CupertinoIcons.folder);
      const item = DockItem(
        id: 'test',
        icon: testIcon,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DockIcon(
              item: item,
              size: 48,
              scale: 1,
              animationDuration: Duration(milliseconds: 500),
            ),
          ),
        ),
      );

      final animatedScale = tester.widget<AnimatedScale>(
        find.byType(AnimatedScale),
      );

      expect(
        animatedScale.duration,
        equals(const Duration(milliseconds: 500)),
      );
    });

    testWidgets('applies scale of 1.0 correctly', (tester) async {
      const testIcon = Icon(CupertinoIcons.folder);
      const item = DockItem(
        id: 'test',
        icon: testIcon,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DockIcon(
              item: item,
              size: 48,
              scale: 1,
            ),
          ),
        ),
      );

      final animatedScale = tester.widget<AnimatedScale>(
        find.byType(AnimatedScale),
      );

      expect(animatedScale.scale, equals(1));
    });

    testWidgets('applies scale of 2.0 correctly', (tester) async {
      const testIcon = Icon(CupertinoIcons.folder);
      const item = DockItem(
        id: 'test',
        icon: testIcon,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DockIcon(
              item: item,
              size: 48,
              scale: 2,
            ),
          ),
        ),
      );

      final animatedScale = tester.widget<AnimatedScale>(
        find.byType(AnimatedScale),
      );

      expect(animatedScale.scale, equals(2));
    });

    testWidgets('uses easeOutCubic curve', (tester) async {
      const testIcon = Icon(CupertinoIcons.folder);
      const item = DockItem(
        id: 'test',
        icon: testIcon,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DockIcon(
              item: item,
              size: 48,
              scale: 1.5,
            ),
          ),
        ),
      );

      final animatedScale = tester.widget<AnimatedScale>(
        find.byType(AnimatedScale),
      );

      expect(animatedScale.curve, equals(Curves.easeOutCubic));
    });
  });
}
