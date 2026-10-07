# Contributing to Sedra Wallet

Thanks for your interest in improving **Sedra Wallet**! This guide explains how to set up the project, follow the code style, and submit pull requests.

## Code of Conduct

By participating in this project, you agree to follow our [Code of Conduct](CODE_OF_CONDUCT.md). Please be respectful and constructive.

## Reporting Issues

- **Security vulnerabilities** → see [SECURITY.md](SECURITY.md). **Do not open a public issue.**
- **Bugs** → use the [Bug report template](https://github.com/karyalangitdigital/sedracoin-wallet/issues/new?template=bug_report.yml).
- **Feature requests** → use the [Feature request template](https://github.com/karyalangitdigital/sedracoin-wallet/issues/new?template=feature_request.yml).

## Development Setup

### Prerequisites

- Flutter SDK `>=3.44.0 <4.0.0` (stable channel) and Dart `>=3.12.0 <4.0.0`
- Android SDK 34+ and/or Xcode 15+ for platform builds
- JDK 17 for the Android Gradle build

### Bootstrap

```bash
git clone https://github.com/karyalangitdigital/sedracoin-wallet.git
cd sedracoin-wallet
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

### Regenerate code

After modifying any `@freezed` union, `@JsonSerializable` model, or ARB file:

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Run tests and static analysis

```bash
flutter analyze
flutter test
```

### Build release artifacts

```bash
flutter build apk --release         # Android
flutter build ios --release          # iOS (macOS host required)
```

Release signing reads `android/key.properties` and `android/app/google-services.json`. These files are gitignored — supply your own for production builds. For a fork or CI, either disable Firebase-dependent steps or provide your own Firebase project.

## Project Layout

The README's [Project Structure](README.md#project-structure) section describes the feature-first folder layout. As a rule of thumb: each folder under `lib/` is a self-contained feature (its own Notifier, View, ViewModel), with truly cross-cutting code under `lib/widgets/`, `lib/util/`, and `lib/core/`.

## Code Style

- **Lints** — `flutter_lints` is enabled via `analysis_options.yaml`. Run `flutter analyze` before pushing; CI will fail on errors.
- **Formatting** — Use `dart format .`. Line length is 80 by default.
- **State management** — Riverpod 2 / Flutter Riverpod. Prefer `ConsumerWidget` for pure views and `WidgetRef` when a widget needs providers.
- **Immutable models** — Use `freezed` + `json_serializable`. Do not hand-edit `*.g.dart` or `*.freezed.dart` files.
- **Localization** — **Never hardcode user-visible strings.** Add keys to `lib/l10n/arb/app_en.arb` (with descriptions) and provide translations for other locales. `flutter gen-l10n` runs as part of the build.
- **Naming** — Files use `snake_case.dart`; classes use `PascalCase`. Provider/Notifier suffixes should end in `Notifier` (stateful) or `Controller` (facade).
- **Widgets** — Keep widgets small; split a screen into `view`, `viewmodel`, and section widgets.

## Making Changes

1. Create a topic branch off `main`:
   ```bash
   git switch -c feature/short-name
   ```
2. Make small, focused commits using [Conventional Commits](https://www.conventionalcommits.org/):
   - `feat:` new feature
   - `fix:` bug fix
   - `refactor:` internal change, no functional change
   - `perf:` performance
   - `docs:` documentation
   - `test:` adding/adjusting tests
   - `chore:` build, tooling, deps
   - `l10n:` translation updates
3. Add or update tests under `test/` for anything that touches logic (parsers, notifiers, formatters, RPC).
4. Run the checks locally before pushing:
   ```bash
   dart format .
   flutter analyze
   flutter test
   ```
5. Push and open a Pull Request against `main`. Fill in the PR template.

## Pull Request Checklist

- [ ] CI is green (`analyze`, `test`, `build apk --debug`).
- [ ] No hardcoded user-facing strings — translations added via ARB files.
- [ ] Screenshots or GIFs included for user-visible UI changes.
- [ ] Related issues linked via `Closes #NNN` or `Refs #NNN`.
- [ ] `CHANGELOG.md` updated when the change is user-visible.

## Review Process

A maintainer will review your PR. Please be patient — small, focused PRs get merged first. Address review comments by pushing new commits (we squash-merge on `main`).

## Adding a Language

Sedra Wallet already ships with 20+ localizations. See [TRANSLATORS.md](TRANSLATORS.md) for the ARB-based workflow.

## License

By contributing to Sedra Wallet, you agree that your contributions will be licensed under the project's [MIT License](LICENSE).
