import 'dart:async';

import 'package:flutter/services.dart';

/// Security helper for copying sensitive wallet data (addresses, URIs) to
/// the clipboard.
///
/// Clipboard-stealing malware reads the clipboard shortly after a copy, so
/// the address only needs to live there long enough for the user to share it
/// in person. After [kClipboardAutoClearDelay] we wipe the clipboard — but
/// only if its content still matches what we put there, so anything the user
/// copied in the meantime is left untouched.
class ClipboardUtil {
  ClipboardUtil._();

  static const kClipboardAutoClearDelay = Duration(seconds: 60);

  static Timer? _autoClearTimer;

  static Future<void> copyAndAutoClear(String text) async {
    await Clipboard.setData(ClipboardData(text: text));

    _autoClearTimer?.cancel();
    _autoClearTimer = Timer(kClipboardAutoClearDelay, () async {
      final current = await Clipboard.getData('text/plain');
      if (current?.text == text) {
        await Clipboard.setData(const ClipboardData(text: ''));
      }
    });
  }
}
