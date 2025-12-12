import 'package:flutter/material.dart';
import 'package:flutter_macos_dock/flutter_macos_dock.dart';

void main() {
  runApp(const TestApp());
}

class TestApp extends StatefulWidget {
  const TestApp({super.key});

  @override
  State<TestApp> createState() => _TestAppState();
}

class _TestAppState extends State<TestApp> {
  List<DockItem> items = [
    const DockItem(
      id: '1',
      icon: Icon(Icons.looks_one, color: Colors.blue, size: 40),
    ),
    const DockItem(
      id: '2',
      icon: Icon(Icons.looks_two, color: Colors.green, size: 40),
    ),
    const DockItem(
      id: '3',
      icon: Icon(Icons.looks_3, color: Colors.orange, size: 40),
    ),
    const DockItem(
      id: '4',
      icon: Icon(Icons.looks_4, color: Colors.red, size: 40),
    ),
    const DockItem(
      id: '5',
      icon: Icon(Icons.looks_5, color: Colors.purple, size: 40),
    ),
    const DockItem(
      id: '6',
      icon: Icon(Icons.looks_6, color: Colors.pink, size: 40),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey[800],
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Test FINALNE poprawki:\n\n'
                  '✓ Problem 1: Animacja powrotu - item leci do '
                  'właściwej pozycji\n'
                  '✓ Problem 2: Magnification działa podczas drag\n'
                  '✓ Problem 3: Przesuwanie w prawo działa poprawnie\n'
                  '✓ Bonus: Itemy się rozsuwają podczas magnification',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Kolejność: ${items.map((e) => e.id).join(' → ')}',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              MacDock(
                items: items,
                size: 56,
                magnification: 2.5,
                magnificationRadius: 150,
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    final item = items.removeAt(oldIndex);
                    items.insert(newIndex, item);
                  });
                  debugPrint('Moved: $oldIndex → $newIndex');
                },
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
