/// Position of the dock on the screen.
///
/// This enum defines the four possible positions where the dock can be
/// placed on the screen, matching the behavior of the macOS Dock.
///
/// The position affects the layout direction of dock items:
/// * [bottom] and [top] render items horizontally
/// * [left] and [right] render items vertically
///
/// Example:
/// ```dart
/// MacDock(
///   items: items,
///   position: DockPosition.bottom,
/// )
/// ```
enum DockPosition {
  /// Dock positioned at the bottom of the screen.
  ///
  /// Items are arranged horizontally from left to right.
  bottom,

  /// Dock positioned on the left side of the screen.
  ///
  /// Items are arranged vertically from top to bottom.
  left,

  /// Dock positioned on the right side of the screen.
  ///
  /// Items are arranged vertically from top to bottom.
  right,

  /// Dock positioned at the top of the screen.
  ///
  /// Items are arranged horizontally from left to right.
  top,
}
