# Contributing to flutter_macos_dock

Thank you for considering contributing to flutter_macos_dock! This document provides guidelines and instructions for contributing.

## Code of Conduct

Be respectful, inclusive, and professional in all interactions.

## Getting Started

1. Fork the repository
2. Clone your fork: `git clone https://github.com/your-username/flutter_macos_dock.git`
3. Create a feature branch: `git checkout -b feat/your-feature`
4. Make your changes
5. Run tests: `flutter test`
6. Commit using [conventional commits](COMMIT_REQUIREMENTS.md)
7. Push to your fork: `git push origin feat/your-feature`
8. Create a Pull Request

## Development Setup

### Prerequisites

- Flutter SDK (>=3.24.0)
- Dart SDK (^3.10.3)
- Git

### Installation

```bash
# Clone the repository
git clone https://github.com/makjac/flutter_macos_dock.git
cd flutter_macos_dock

# Install dependencies
flutter pub get

# Run tests
flutter test

# Run example
cd example
flutter run
```

## Development Workflow

### 1. Before Starting

- Check existing issues and PRs
- Discuss major changes in an issue first
- Ensure you're working on the latest code

### 2. Making Changes

```bash
# Update your local main
git checkout main
git pull upstream main

# Create feature branch
git checkout -b feat/your-feature

# Make changes
# ... edit files ...

# Format code
dart format .

# Analyze code
flutter analyze

# Run tests
flutter test --coverage
```

### 3. Commit Guidelines

Follow [Commit Requirements](COMMIT_REQUIREMENTS.md):

```bash
# Good commit
git commit -m "feat(models): add DockBadge model for icon badges

- Support text and numeric badges
- Configure text and background colors
- Include copyWith and equality operators"

# Bad commit
git commit -m "update stuff"
```

### 4. Testing Requirements

All contributions must include tests:

- **Unit tests**: For all new models and utilities
- **Widget tests**: For all new widgets
- **Coverage**: Minimum 90% coverage for new code

```bash
# Run tests with coverage
flutter test --coverage

# View coverage (macOS/Linux)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### 5. Documentation Requirements

- Add `///` documentation to all public APIs
- Update README.md if adding features
- Update CHANGELOG.md
- Add examples for new features

## Code Standards

### Linting

We use [very_good_analysis](https://pub.dev/packages/very_good_analysis):

```bash
flutter analyze
```

All code must pass with 0 issues.

### Formatting

```bash
# Format all files
dart format .

# Check formatting
dart format --set-exit-if-changed .
```

### Line Length

Maximum 80 characters per line.

### Documentation Style

```dart
/// A widget that displays a macOS-style dock.
///
/// This widget replicates the behavior and appearance of the macOS dock,
/// including magnification effects, auto-hide, and drag-to-reorder.
///
/// Parameters:
/// * [items] - List of DockItem objects to display in the dock
/// * [position] - Position of the dock on screen
///
/// References:
/// * [DockItem] for item configuration
/// * [DockPosition] for available positions
///
/// Example:
/// ```dart
/// MacDock(
///   items: [
///     DockItem(id: 'finder', icon: Icon(Icons.folder)),
///   ],
///   position: DockPosition.bottom,
/// )
/// ```
class MacDock extends StatelessWidget {
  // ...
}
```

## Pull Request Process

### 1. PR Title

Use conventional commit format:

```
feat: add magnification effect to dock icons
fix: correct icon alignment in vertical mode
docs: update installation instructions
```

### 2. PR Description Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Checklist
- [ ] Tests pass locally
- [ ] Code follows style guidelines
- [ ] Documentation updated
- [ ] Changelog updated
- [ ] No linter warnings
- [ ] Test coverage >= 90%

## Screenshots (if applicable)

## Related Issues
Closes #123
```

### 3. Review Process

- CI must pass
- At least one approving review required
- All conversations must be resolved
- Documentation must be complete

## Project Structure

```
flutter_macos_dock/
├── lib/
│   ├── flutter_macos_dock.dart       # Public API
│   └── src/
│       ├── enums/
│       │   └── dock_position.dart    # Enums
│       ├── models/
│       │   ├── dock_item.dart        # Data models
│       │   ├── dock_badge.dart
│       │   └── context_menu_item.dart
│       └── widgets/
│           └── mac_dock.dart         # Widgets
├── test/
│   └── src/                          # Mirror lib/ structure
├── example/
│   └── lib/
│       └── main.dart                 # Example app
└── .github/
    └── workflows/
        └── ci.yml                    # CI/CD
```

## Milestone Planning

Check [requirements.md](requirements.md) for:
- Current milestone goals
- Feature specifications
- Implementation checklist

## Reporting Issues

### Bug Reports

Include:
- Flutter version: `flutter --version`
- Platform: macOS/Windows/Linux/Web
- Minimal reproduction code
- Expected vs actual behavior
- Screenshots/recordings

### Feature Requests

Include:
- Clear use case
- Proposed API (if applicable)
- Examples from other libraries
- Implementation ideas

## Questions?

- Open a discussion
- Check existing issues
- Review documentation

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
