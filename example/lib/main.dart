import 'package:flutter/material.dart';
import 'package:flutter_macos_dock/flutter_macos_dock.dart';

void main() {
  runApp(const MyApp());
}

/// Example application demonstrating the MacDock widget.
class MyApp extends StatelessWidget {
  /// Creates the example app.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MacDock Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const DockExamplePage(),
    );
  }
}

/// Example page showing MacDock in different configurations.
class DockExamplePage extends StatefulWidget {
  /// Creates the dock example page.
  const DockExamplePage({super.key});

  @override
  State<DockExamplePage> createState() => _DockExamplePageState();
}

class _DockExamplePageState extends State<DockExamplePage> {
  DockPosition _position = DockPosition.bottom;
  double _size = 48;

  final List<DockItem> _items = const [
    DockItem(
      id: 'finder',
      icon: Icon(Icons.folder, color: Colors.blue),
      tooltip: 'Finder',
      showIndicator: true,
    ),
    DockItem(
      id: 'safari',
      icon: Icon(Icons.language, color: Colors.blue),
      tooltip: 'Safari',
    ),
    DockItem(
      id: 'mail',
      icon: Icon(Icons.mail, color: Colors.blue),
      tooltip: 'Mail',
      badge: DockBadge(count: 5),
    ),
    DockItem(
      id: 'messages',
      icon: Icon(Icons.message, color: Colors.green),
      tooltip: 'Messages',
      badge: DockBadge(count: 3),
    ),
    DockItem(
      id: 'calendar',
      icon: Icon(Icons.calendar_today, color: Colors.red),
      tooltip: 'Calendar',
    ),
    DockItem(
      id: 'photos',
      icon: Icon(Icons.photo_library, color: Colors.orange),
      tooltip: 'Photos',
    ),
    DockItem(
      id: 'music',
      icon: Icon(Icons.music_note, color: Colors.pink),
      tooltip: 'Music',
      showIndicator: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MacDock Example'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: _buildDockDemo(),
            ),
          ),
          _buildControls(),
        ],
      ),
    );
  }

  Widget _buildDockDemo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: MacDock(
        items: _items,
        position: _position,
        size: _size,
      ),
    );
  }

  Widget _buildControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Position',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              ChoiceChip(
                label: const Text('Bottom'),
                selected: _position == DockPosition.bottom,
                onSelected: (selected) {
                  if (selected) {
                    setState(() => _position = DockPosition.bottom);
                  }
                },
              ),
              ChoiceChip(
                label: const Text('Left'),
                selected: _position == DockPosition.left,
                onSelected: (selected) {
                  if (selected) {
                    setState(() => _position = DockPosition.left);
                  }
                },
              ),
              ChoiceChip(
                label: const Text('Right'),
                selected: _position == DockPosition.right,
                onSelected: (selected) {
                  if (selected) {
                    setState(() => _position = DockPosition.right);
                  }
                },
              ),
              ChoiceChip(
                label: const Text('Top'),
                selected: _position == DockPosition.top,
                onSelected: (selected) {
                  if (selected) {
                    setState(() => _position = DockPosition.top);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Icon Size',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: _size,
                  min: 24,
                  max: 128,
                  divisions: 26,
                  label: _size.round().toString(),
                  onChanged: (value) {
                    setState(() => _size = value);
                  },
                ),
              ),
              SizedBox(
                width: 50,
                child: Text(
                  '${_size.round()}',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
