# MacDock Example

This example demonstrates the basic usage of the `flutter_macos_dock` package.

## Features Demonstrated

- Basic dock rendering with icons
- Four dock positions: bottom, left, right, top
- Adjustable icon size
- Multiple dock items

## Running the Example

```bash
cd example
flutter run
```

## Usage

The example shows how to:

1. Import the package:

```dart
import 'package:flutter_macos_dock/flutter_macos_dock.dart';
```

1. Create dock items:

```dart
const items = [
  DockItem(
    id: 'finder',
    icon: Icon(Icons.folder),
    tooltip: 'Finder',
  ),
];
```

1. Display the dock:

```dart
MacDock(
  items: items,
  position: DockPosition.bottom,
  size: 48.0,
)
```

## Interactive Controls

The example includes interactive controls to:

- Switch between dock positions (bottom, left, right, top)
- Adjust icon size from 24 to 128 pixels
