## 0.2.0

### Milestone 3: Drag and Drop with Reordering

* Full drag-and-drop support with threshold detection (4px distance or 150ms hold)
* Icon reordering with smooth animations
* Remove items by dragging outside dock bounds
* Return animation when dropping items
* Magnification offset calculation to prevent icon overlap
* Lift effect during magnification (icons move towards cursor)
* ID-based item tracking for stable reordering
* DraggableDockIcon widget with pan gesture detection
* DraggedIconOverlay widget for dragged item rendering
* ReorderCalculator utility for swap logic
* Configurable animation durations:
  * `reorderAnimationDuration` (default 220ms)
  * `returnAnimationDuration` (default 300ms)
* `liftStrength` parameter for magnification lift effect (default 0.5)
* `onReorder` callback for handling reorder events
* `onRemove` callback for handling item removal

## 0.1.0

### Milestone 2: Magnification and Hover Effects

* Magnification effect with distance-based scaling
* Hover detection using MouseRegion
* Smooth animations with Curves.easeOutCubic
* Configurable magnification strength (1.0x - 2.5x)
* Configurable magnification radius (default 100px)
* MagnificationCalculator utility for scale computation
* DockIcon widget for individual icon rendering with AnimatedScale

## 0.0.1

### Initial release: Core Structure and Basic Rendering

* Basic MacDock widget with icon rendering
* Support for four dock positions (bottom, left, right, top)
* Core data models (DockItem, DockBadge, ContextMenuItem)
* DockPosition enum
* Configurable icon size
* Comprehensive API documentation
* Interactive example application
