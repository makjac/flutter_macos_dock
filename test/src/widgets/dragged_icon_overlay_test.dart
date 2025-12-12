import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_macos_dock/src/widgets/dragged_icon_overlay.dart';

void main() {
  group('DraggedIconOverlay', () {
    testWidgets('renders child widget', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                DraggedIconOverlay(
                  position: Offset(100, 100),
                  size: 48.0,
                  child: Icon(Icons.folder),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.folder), findsOneWidget);
    });

    testWidgets('positions widget at specified offset', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                DraggedIconOverlay(
                  position: Offset(150, 200),
                  size: 48.0,
                  child: Icon(Icons.folder),
                ),
              ],
            ),
          ),
        ),
      );

      final positioned = tester.widget<Positioned>(
        find.byType(Positioned),
      );

      expect(positioned.left, 150.0);
      expect(positioned.top, 200.0);
    });

    testWidgets('applies correct size to container', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                DraggedIconOverlay(
                  position: Offset(100, 100),
                  size: 64.0,
                  child: Icon(Icons.folder),
                ),
              ],
            ),
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(
        find.byKey(const ValueKey('dragged_icon_size_box')),
      );

      expect(sizedBox.width, 64.0);
      expect(sizedBox.height, 64.0);
    });

    testWidgets('shows lift transformation when lifted', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                DraggedIconOverlay(
                  position: Offset(100, 100),
                  size: 48.0,
                  isLifted: true,
                  child: Icon(Icons.folder),
                ),
              ],
            ),
          ),
        ),
      );

      final animatedContainer = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );

      expect(animatedContainer.transform, isNotNull);
    });

    testWidgets('no shadows applied to match macOS behavior', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                DraggedIconOverlay(
                  position: Offset(100, 100),
                  size: 48.0,
                  isLifted: true,
                  child: Icon(Icons.folder),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should use SizedBox, not Container with decoration
      expect(find.byType(SizedBox), findsWidgets);

      // Verify no Container with BoxDecoration exists
      final containers = tester.widgetList<Container>(
        find.byType(Container),
      );
      for (final container in containers) {
        final decoration = container.decoration as BoxDecoration?;
        expect(decoration?.boxShadow, isNull);
      }
    });

    testWidgets('reduces opacity when in removing state', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                DraggedIconOverlay(
                  position: Offset(100, 100),
                  size: 48.0,
                  isLifted: true,
                  isRemoving: true,
                  child: Icon(Icons.folder),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final animatedOpacity = tester.widget<AnimatedOpacity>(
        find.byType(AnimatedOpacity),
      );

      expect(animatedOpacity.opacity, 0.5);
    });

    testWidgets('normal opacity when not removing', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                DraggedIconOverlay(
                  position: Offset(100, 100),
                  size: 48.0,
                  isLifted: true,
                  isRemoving: false,
                  child: Icon(Icons.folder),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final animatedOpacity = tester.widget<AnimatedOpacity>(
        find.byType(AnimatedOpacity),
      );

      expect(animatedOpacity.opacity, 0.95);
    });

    testWidgets('applies initial scale with lift scale', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                DraggedIconOverlay(
                  position: Offset(100, 100),
                  size: 48.0,
                  isLifted: true,
                  initialScale: 1.5,
                  child: Icon(Icons.folder),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final animatedContainer = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );

      // Verify transform is applied (initialScale * liftScale = 1.5 * 1.08 = 1.62)
      expect(animatedContainer.transform, isNotNull);
    });

    testWidgets('uses correct animation duration', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                DraggedIconOverlay(
                  position: Offset(100, 100),
                  size: 48.0,
                  child: Icon(Icons.folder),
                ),
              ],
            ),
          ),
        ),
      );

      final animatedContainer = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );

      expect(
        animatedContainer.duration,
        const Duration(milliseconds: 120),
      );
    });

    testWidgets('uses easeOut curve', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                DraggedIconOverlay(
                  position: Offset(100, 100),
                  size: 48.0,
                  child: Icon(Icons.folder),
                ),
              ],
            ),
          ),
        ),
      );

      final animatedContainer = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );

      expect(animatedContainer.curve, Curves.easeOut);
    });
  });
}
