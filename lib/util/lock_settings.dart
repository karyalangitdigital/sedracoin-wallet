// ignore_for_file: constant_identifier_names

import 'vault.dart';

class LockSettings {
  static const _sedra_lock = 'fsedra_lock_dev';
  static const _sedra_autolock = 'fsedra_autolock_dev';

  static const _true = 'true';
  static const _false = 'false';

  final Vault vault;
  LockSettings(this.vault);

  Future<void> setLock(bool value) =>
      vault.set(_sedra_lock, value ? _true : _false);

  Future<bool> getLock() async =>
      (await vault.get(_sedra_lock) ?? _true) == _true;

  Future<void> setAutoLock(bool value) =>
      vault.set(_sedra_autolock, value ? _true : _false);

  Future<bool> getAutoLock() async =>
      (await vault.get(_sedra_autolock) ?? _true) == _true;
}
