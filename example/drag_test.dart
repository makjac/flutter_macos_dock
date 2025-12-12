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
    const DockItem(
      id: 'finder',
      icon: Icon(Icons.folder, color: Colors.blue, size: 40),
    ),
    const DockItem(
      id: 'safari',
      icon: Icon(Icons.public, color: Colors.blue, size: 40),
    ),
    const DockItem(
      id: 'messages',
      icon: Icon(Icons.message, color: Colors.green, size: 40),
    ),
    const DockItem(
      id: 'mail',
      icon: Icon(Icons.email, color: Colors.blue, size: 40),
    ),
    const DockItem(
      id: 'calendar',
      icon: Icon(Icons.calendar_today, color: Colors.red, size: 40),
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
                padding: EdgeInsets.all(20),
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
                magnification: 2,
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
