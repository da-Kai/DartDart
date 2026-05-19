# Contributing

- [Contributing](#contributing)
  - [Contributor License Agreement](#contributor-license-agreement)
  - [Contributor Code of Conduct](#contributor-code-of-conduct)
  - [How to Contribute](#how-to-contribute)
  - [Project Setup](#project-setup)
  - [Code Style \& Linting](#code-style--linting)
  - [Testing](#testing)
  - [Bug Reports, Issues and Questions](#bug-reports-issues-and-questions)

## Contributor License Agreement

By contributing, you agree to the Licenses of this repository:
[GNU Affero General Public License version 3](../LICENSE)

## Contributor Code of Conduct

By contributing, you agree to respect the [Code of Conduct](../CODE_OF_CONDUCT.md) of this repository.

## How to Contribute

We welcome contributions of all sizes:
- Bug fixes, performance improvements, and refactors
- New features and documentation
- Tests, tooling, and CI improvements
- Issue triage and reproducible examples

## Project Setup

Requirements:
- Dart SDK >= 3.5.0
- Flutter >= 3.27.0
- Git

Install dependencies:
- `flutter pub get`

Run the app:
- `flutter run`

Run analyzer:
- `flutter analyze`

Format code:
- `dart format .

## Code Style & Linting

This project uses `flutter_lints` plus additional rules in `analysis_options.yaml`. Key rules to follow:
- Use single quotes: prefer `'` over `"`.
- Always use package imports: `package:your_pkg/...` (avoid relative imports).
- Declare explicit return types for all public methods/functions.
- Add `@override` where applicable.
- Avoid `print` and `debugPrint`. Prefer `dart:developer` `log()` for diagnostics.
- Avoid empty `else` blocks and empty statements.
- Do not rely on `runtimeType.toString()` (avoid type-to-string).
- Keep imports ordered and minimal.

Commands:
- Analyze: `flutter analyze`
- Auto-fix (where possible): `dart fix --apply`
- Format: `dart format .`

## Testing

- Unit/widget tests: `flutter test`
- With coverage: `flutter test --coverage`
- Add tests for:
    - New features and bug fixes
    - Edge cases and regressions
- Keep tests deterministic and fast.

## Bug Reports, Issues and Questions

A great way to contribute to the project is to send a detailed report when you encounter an issue. We always appreciate a well-written, thorough bug report, and will thank you for it!
