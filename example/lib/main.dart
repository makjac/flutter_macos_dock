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
  double _magnification = 1.5;
  double _liftStrength = 0.5;
  double _magnificationRadius = 100;
  int _magnificationDuration = 200;
  int _reorderDuration = 220;
  int _returnDuration = 300;
  bool _showControls = true;

  final List<DockItem> _items = [
    const DockItem(
      id: 'finder',
      icon: Icon(Icons.folder, color: Colors.blue),
      tooltip: 'Finder',
      showIndicator: true,
    ),
    const DockItem(
      id: 'safari',
      icon: Icon(Icons.language, color: Colors.blue),
      tooltip: 'Safari',
    ),
    const DockItem(
      id: 'mail',
      icon: Icon(Icons.mail, color: Colors.blue),
      tooltip: 'Mail',
      badge: DockBadge(count: 5),
    ),
    const DockItem(
      id: 'messages',
      icon: Icon(Icons.message, color: Colors.green),
      tooltip: 'Messages',
      badge: DockBadge(count: 3),
    ),
    const DockItem(
      id: 'calendar',
      icon: Icon(Icons.calendar_today, color: Colors.red),
      tooltip: 'Calendar',
    ),
    const DockItem(
      id: 'photos',
      icon: Icon(Icons.photo_library, color: Colors.orange),
      tooltip: 'Photos',
    ),
    const DockItem(
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
        actions: [
          IconButton(
            icon: Icon(
              _showControls ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () {
              setState(() => _showControls = !_showControls);
            },
            tooltip: _showControls ? 'Hide controls' : 'Show controls',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildDockDemo(),
          ),
          if (_showControls) _buildControls(),
        ],
      ),
    );
  }

  Widget _buildDockDemo() {
    // Determine alignment based on position
    Alignment alignment;
    switch (_position) {
      case DockPosition.bottom:
        alignment = Alignment.bottomCenter;
      case DockPosition.top:
        alignment = Alignment.topCenter;
      case DockPosition.left:
        alignment = Alignment.centerLeft;
      case DockPosition.right:
        alignment = Alignment.centerRight;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Align(
        alignment: alignment,
        child: MacDock(
          items: _items,
          position: _position,
          size: _size,
          magnification: _magnification,
          liftStrength: _liftStrength,
          magnificationRadius: _magnificationRadius,
          magnificationAnimationDuration: Duration(
            milliseconds: _magnificationDuration,
          ),
          reorderAnimationDuration: Duration(milliseconds: _reorderDuration),
          returnAnimationDuration: Duration(milliseconds: _returnDuration),
          onReorder: (oldIndex, newIndex) {
            setState(() {
              final item = _items.removeAt(oldIndex);
              _items.insert(newIndex, item);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Moved item from position $oldIndex to $newIndex',
                ),
                duration: const Duration(seconds: 1),
              ),
            );
          },
          onRemove: (index, item) {
            setState(() {
              _items.removeAt(index);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Removed ${item.tooltip ?? item.id}'),
                duration: const Duration(seconds: 2),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () {
                    setState(() {
                      _items.insert(index, item);
                    });
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.6,
      ),
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
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
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
            const SizedBox(height: 16),
            const Text(
              'Magnification',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: _magnification,
                    min: 1,
                    max: 2.5,
                    divisions: 15,
                    label: _magnification.toStringAsFixed(1),
                    onChanged: (value) {
                      setState(() => _magnification = value);
                    },
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: Text(
                    '${_magnification.toStringAsFixed(1)}x',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Lift Strength',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: _liftStrength,
                    divisions: 20,
                    label: _liftStrength.toStringAsFixed(2),
                    onChanged: (value) {
                      setState(() => _liftStrength = value);
                    },
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: Text(
                    _liftStrength.toStringAsFixed(2),
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Magnification Radius',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: _magnificationRadius,
                    min: 50,
                    max: 300,
                    divisions: 50,
                    label: _magnificationRadius.round().toString(),
                    onChanged: (value) {
                      setState(() => _magnificationRadius = value);
                    },
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: Text(
                    '${_magnificationRadius.round()}',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Magnification Duration (ms)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: _magnificationDuration.toDouble(),
                    min: 50,
                    max: 500,
                    divisions: 45,
                    label: _magnificationDuration.toString(),
                    onChanged: (value) {
                      setState(() => _magnificationDuration = value.round());
                    },
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: Text(
                    '$_magnificationDuration',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Reorder Duration (ms)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: _reorderDuration.toDouble(),
                    min: 50,
                    max: 500,
                    divisions: 45,
                    label: _reorderDuration.toString(),
                    onChanged: (value) {
                      setState(() => _reorderDuration = value.round());
                    },
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: Text(
                    '$_reorderDuration',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Return Animation Duration (ms)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: _returnDuration.toDouble(),
                    min: 100,
                    max: 1000,
                    divisions: 90,
                    label: _returnDuration.toString(),
                    onChanged: (value) {
                      setState(() => _returnDuration = value.round());
                    },
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: Text(
                    '$_returnDuration',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Hover over the dock to see the magnification effect. '
                'Drag icons to reorder.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blue[700],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
