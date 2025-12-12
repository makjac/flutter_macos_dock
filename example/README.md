# MacDock Example

Interactive example demonstrating all features of the `flutter_macos_dock` package including magnification and drag-and-drop reordering.

## Features Demonstrated

### 🎯 Magnification Effect
- Hover over icons to see smooth macOS-style magnification
- Adjust magnification strength with slider (1.0 - 3.0x)
- Gaussian distribution creates natural scaling

### 🔄 Drag and Reorder
- **Click and hold** any icon to start dragging
- **Drag left or right** to reorder icons in real-time
- Icons automatically shift to create a gap
- **Release** to drop the icon in the new position
- Smooth animations with visual feedback

### 🗑️ Remove Items
- **Drag an icon up** (away from the dock) to remove it
- Icon fades when outside the drop zone
- **Release** to remove, with **undo** option

### 📐 Customization
- **Size**: Adjust icon size (32 - 96px)
- **Magnification**: Control zoom strength (1.0 - 3.0x)
- **Position**: Place dock at bottom, top, left, or right

## Running the Example

```bash
cd example
flutter run -d macos
```

Or from root directory:

```bash
flutter run -d macos example/lib/main.dart
```

## Usage

### Basic Setup

1. Import the package:

```dart
import 'package:flutter_macos_dock/flutter_macos_dock.dart';
```

2. Create a mutable list of dock items:

```dart
List<DockItem> items = [
  const DockItem(
    id: 'finder',
    icon: Icon(Icons.folder, color: Colors.blue),
    tooltip: 'Finder',
    showIndicator: true,
  ),
  const DockItem(
    id: 'mail',
    icon: Icon(Icons.mail, color: Colors.blue),
    tooltip: 'Mail',
    badge: DockBadge(count: 5),
  ),
];
```

3. Display the dock with drag-and-drop:

```dart
MacDock(
  items: items,
  position: DockPosition.bottom,
  size: 48.0,
  magnification: 2.0,
  onReorder: (oldIndex, newIndex) {
    setState(() {
      final item = items.removeAt(oldIndex);
      items.insert(newIndex, item);
    });
  },
  onRemove: (index, item) {
    setState(() {
      items.removeAt(index);
    });
  },
)
```

## Key Behaviors

- **Drag threshold**: 4px movement or 150ms hold time
- **Swap threshold**: 50% of icon width with 5% hysteresis
- **Remove threshold**: 60px above dock
- **Lift animation**: 16px height, 1.08x scale, 120ms duration
- **Reorder animation**: 220ms with cubic-bezier easing

## Troubleshooting

**Icons don't reorder?**
- Ensure items list is mutable (not `const`)
- Implement `onReorder` callback to update state

**Drag doesn't start?**
- Move cursor at least 4px or wait 150ms

## Interactive Controls

The example includes interactive controls to:

- Switch between dock positions (bottom, left, right, top)
- Adjust icon size from 24 to 128 pixels
