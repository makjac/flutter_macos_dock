# flutter_macos_dock

A Flutter package that replicates the macOS Dock behavior and appearance
with extensive customization options.

## Features

- **Basic Dock Rendering**: Display icons in a macOS-style dock
- **Four Position Options**: Bottom, left, right, and top dock positions
- **Configurable Icon Size**: Adjust dock icon sizes
- **Data Models**: Comprehensive models for dock items, badges, and menus
- **Type-Safe API**: Strongly typed configuration options
- **Zero Dependencies**: Built using only Flutter SDK widgets

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_macos_dock: ^0.0.1
```

## Getting Started

Import the package:

```dart
import 'package:flutter_macos_dock/flutter_macos_dock.dart';
```

## Usage

### Basic Example

Create a simple dock with icons:

```dart
MacDock(
  items: [
    DockItem(
      id: 'finder',
      icon: Icon(Icons.folder, color: Colors.blue),
      tooltip: 'Finder',
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
    ),
  ],
  position: DockPosition.bottom,
  size: 48.0,
)
```

### Different Positions

Position the dock at different screen edges:

```dart
// Bottom (default)
MacDock(
  items: items,
  position: DockPosition.bottom,
)

// Left side
MacDock(
  items: items,
  position: DockPosition.left,
)

// Right side
MacDock(
  items: items,
  position: DockPosition.right,
)

// Top
MacDock(
  items: items,
  position: DockPosition.top,
)
```

### Custom Icon Sizes

Adjust the size of dock icons:

```dart
MacDock(
  items: items,
  size: 64.0, // Larger icons
)
```

### With Badges and Indicators

Add badges and open indicators to dock items:

```dart
DockItem(
  id: 'mail',
  icon: Icon(Icons.mail),
  tooltip: 'Mail',
  badge: DockBadge(
    count: 5,
    backgroundColor: Colors.red,
    textColor: Colors.white,
  ),
  showIndicator: true, // Shows dot indicator
)
```

### With Tap Callbacks

Handle icon taps:

```dart
DockItem(
  id: 'finder',
  icon: Icon(Icons.folder),
  tooltip: 'Finder',
  onTap: () {
    print('Finder tapped');
  },
)
```

## API Reference

### MacDock

The main widget for displaying a macOS-style dock.

**Parameters:**

- `items` (required): List of `DockItem` objects to display
- `position`: Position of the dock (default: `DockPosition.bottom`)
- `size`: Base size of dock icons in logical pixels (default: 48.0)

### DockItem

Configuration for a single dock item.

**Parameters:**

- `id` (required): Unique identifier for the item
- `icon` (required): Widget representing the icon
- `tooltip`: Optional text displayed on hover
- `onTap`: Optional callback when icon is tapped
- `onRemove`: Optional callback when dragged outside dock
- `contextMenuItems`: Optional list of context menu items
- `badge`: Optional badge configuration
- `showIndicator`: Whether to show open indicator (default: false)
- `data`: Optional custom data

### DockPosition

Enum defining dock position:

- `DockPosition.bottom`
- `DockPosition.left`
- `DockPosition.right`
- `DockPosition.top`

### DockBadge

Configuration for a badge on a dock icon.

**Parameters:**

- `text`: Optional text label
- `count`: Optional numerical count
- `backgroundColor`: Badge background color
- `textColor`: Badge text color

## Example

For a complete example with interactive controls, see the
[example](example/) directory.

To run the example:

```bash
cd example
flutter run
```

## Milestone 1 Status

This release includes:

- ✅ Core package structure
- ✅ Data models (DockItem, DockBadge, ContextMenuItem)
- ✅ DockPosition enum
- ✅ Basic MacDock widget with icon rendering
- ✅ Support for all four dock positions
- ✅ Comprehensive test coverage (90%+)
- ✅ Full API documentation
- ✅ Interactive example app

## Roadmap

Future milestones will include:

- Magnification effects on hover
- Drag and drop with reordering
- Tooltips and context menus
- Auto-hide functionality
- Background blur and customization
- Animation configurations
- And more!

## License

See [LICENSE](LICENSE) file for details.
