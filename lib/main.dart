import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'app_providers.dart';
import 'database/database.dart';
import 'util/platform.dart';
import 'util/sharedprefsutil.dart';

void main() {
  final bootLogger = Logger();

  // Run the whole bootstrap in a guarded zone so that asynchronous errors
  // (RPC, storage, platform channels) can never crash the isolate silently.
  runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Surface widget-framework errors in debug builds; keep the app alive
      // in release builds instead of crashing to a gray screen.
      FlutterError.onError = (details) {
        FlutterError.presentError(details);
        if (kInDebugMode) {
          bootLogger.e(
            "FlutterError: ${details.exception}\n${details.stack}",
          );
        }
      };

      // Capture async/platform errors that escape the widget tree.
      WidgetsBinding.instance.platformDispatcher.onError = (error, stack) {
        if (kInDebugMode) {
          bootLogger.e("PlatformError: $error\n$stack");
        }
        return true;
      };

      final sharedPrefs = await SharedPreferences.getInstance();
      final sharedPrefsUtil = SharedPrefsUtil(sharedPrefs);

      final theme = sharedPrefsUtil.getTheme().getTheme();
      SystemChrome.setSystemUIOverlayStyle(theme.statusBar);
      SystemChrome.setEnabledSystemUIMode(.edgeToEdge);

      // Setup logger
      if (kInDebugMode) {
        Logger.level = .debug;
        //debugRepaintRainbowEnabled = true;
      } else {
        Logger.level = .off;
      }

      await SystemChrome.setPreferredOrientations([.portraitUp]);

      // Init database
      await Database.init();

      runApp(
        ProviderScope(
          // observers: [
          //   const ProviderLogger(),
          // ],
          overrides: [
            sharedPrefsProvider.overrideWithValue(sharedPrefs),
          ],
          child: const App(),
        ),
      );
    },
    (error, stack) {
      // Last-resort handler: log and keep the process alive.
      debugPrint('Uncaught zone error: $error');
      debugPrintStack(stackTrace: stack);
    },
  );
}
