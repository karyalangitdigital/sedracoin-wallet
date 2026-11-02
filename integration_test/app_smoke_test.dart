import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:sedra_wallet/main.dart' as app;

/// End-to-end smoke test run on a real device/emulator:
///
/// `flutter test integration_test -d <device-id>`
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('app boots and renders the first screen without crashing', (
    tester,
  ) async {
    app.main();

    // Let the splash, database init and first frames settle.
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 2));

    // The widget tree must contain at least one MaterialApp and no error
    // widget (the red screen of death).
    expect(find.byType(MaterialApp), findsWidgets);
    expect(find.byType(ErrorWidget), findsNothing);
  });
}
