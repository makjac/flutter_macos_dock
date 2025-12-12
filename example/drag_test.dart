import 'package:flutter/material.dart';
import 'package:flutter_macos_dock/flutter_macos_dock.dart';

void main() {
  runApp(const DragTestApp());
}

class DragTestApp extends StatefulWidget {
  const DragTestApp({super.key});

  @override
  State<DragTestApp> createState() => _DragTestAppState();
}

class _DragTestAppState extends State<DragTestApp> {
  List<DockItem> items = [
    DockItem(
      id: 'finder',
      icon: const Icon(Icons.folder, color: Colors.blue, size: 40),
    ),
    DockItem(
      id: 'safari',
      icon: const Icon(Icons.public, color: Colors.blue, size: 40),
    ),
    DockItem(
      id: 'messages',
      icon: const Icon(Icons.message, color: Colors.green, size: 40),
    ),
    DockItem(
      id: 'mail',
      icon: const Icon(Icons.email, color: Colors.blue, size: 40),
    ),
    DockItem(
      id: 'calendar',
      icon: const Icon(Icons.calendar_today, color: Colors.red, size: 40),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey[900],
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'Test Drag-and-Drop Fixes:\n'
                  '✓ Icons now reorder correctly in both directions\n'
                  '✓ No shadows on grabbed icons\n'
                  '✓ Grabbed icons maintain magnification scale',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(),
              MacDock(
                items: items,
                size: 48,
                magnification: 2.0,
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    final item = items.removeAt(oldIndex);
                    items.insert(newIndex, item);
                  });
                  debugPrint('Reordered: $oldIndex → $newIndex');
                },
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
