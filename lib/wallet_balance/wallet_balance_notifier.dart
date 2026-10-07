import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import '../database/boxes.dart';
import '../sedra/sedra.dart';
import '../util/safe_change_notifier.dart';
import '../wallet_address/wallet_address_aware.dart';

class WalletBalanceNotifier extends SafeChangeNotifier {
  final TypedBox<AddressBalance> _balanceBox;
  final WalletAddressAware addressAware;
  final RpcService rpc;

  final Map<String, BigInt> _balances = {};
  BigInt _totalBalance = .zero;

  WalletBalanceNotifier({
    required this._balanceBox,
    required this.addressAware,
    required this.rpc,
  }) {
    final balances = _balanceBox.getAll();
    for (final balance in balances.values) {
      if (!addressAware.containsAddress(balance.address)) {
        continue;
      }
      _balances[balance.address] = balance.balance;
    }
    _totalBalance = _balances.values.fold(.zero, (a, b) => a + b);
  }

  IMap<String, BigInt>? _cachedBalances;
  IMap<String, BigInt> get balances {
    _cachedBalances ??= _balances.toIMap();
    return _cachedBalances!;
  }

  Amount get totalBalance => Amount.raw(_totalBalance);

  IMap<String, AddressBalance> _lastRefreshChanges = IMap();
  IMap<String, AddressBalance> get lastRefreshChanges => _lastRefreshChanges;

  Amount balanceForAddress(String address) => .raw(_balances[address] ?? .zero);

  Future<void> refresh(Iterable<String> addresses) async {
    if (addresses.isEmpty) {
      return;
    }

    try {
      final entries = await rpc.getBalancesByAddresses(addresses);

      final changes = <String, AddressBalance>{};
      bool balancesUpdated = false;
      for (final entry in entries) {
        final newBalance = entry.balance;
        final oldBalance = _balances[entry.address] ?? .zero;

        if (newBalance != oldBalance) {
          changes[entry.address] = entry;
          _balances[entry.address] = newBalance;
          _totalBalance += newBalance - oldBalance;
          balancesUpdated = true;
        } else if (!_balances.containsKey(entry.address)) {
          _balances[entry.address] = newBalance;
          balancesUpdated = true;
        }
      }

      if (balancesUpdated) {
        _cachedBalances = null;
      }

      if (changes.isNotEmpty) {
        final balanceChanges = changes.map((_, value) {
          final key = addressAware.keyForAddress(value.address) ?? '';
          return MapEntry(key, value);
        });
        balanceChanges.remove('');
        await _balanceBox.setAll(balanceChanges);

        _lastRefreshChanges = changes.toIMap();
        notifyListeners();
      }
    } catch (_) {}
  }
}
