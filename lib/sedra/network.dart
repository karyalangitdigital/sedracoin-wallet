import 'bip32/bip32.dart';

const String kSedraNetworkMainnet = 'mainnet';
const String kSedraNetworkTestnet = 'testnet';
const String kSedraNetworkSimnet = 'simnet';
const String kSedraNetworkDevnet = 'devnet';

const String kSedraNetworkIdMainnet = kSedraNetworkMainnet;
const String kSedraNetworkIdTestnet10 = kSedraNetworkTestnet;
const String kSedraNetworkIdSimnet = kSedraNetworkSimnet;
const String kSedraNetworkIdDevnet = kSedraNetworkDevnet;

const int kMainnetRpcPort = 22110;
const int kTestnetPpcPort = 22210;
const int kSimnetRpcPort = 22510;
const int kDevnetRpcPort = 22610;

enum SedraNetwork {
  mainnet,
  testnet,
  devnet,
  simnet;

  static SedraNetwork? tryParse(String network) {
    return switch (network) {
      kSedraNetworkMainnet => .mainnet,
      kSedraNetworkTestnet => .testnet,
      kSedraNetworkSimnet => .simnet,
      kSedraNetworkDevnet => .devnet,
      _ => null,
    };
  }

  String idWithSuffix([String suffix = '']) {
    if (suffix.isNotEmpty) {
      return '$name-$suffix';
    }
    return name;
  }

  int get defaultRpcPort => switch (this) {
    .mainnet => kMainnetRpcPort,
    .testnet => kTestnetPpcPort,
    .simnet => kSimnetRpcPort,
    .devnet => kDevnetRpcPort,
  };
}

SedraNetwork networkForPort(int port) => switch (port) {
  kMainnetRpcPort => .mainnet,
  kTestnetPpcPort => .testnet,
  kSimnetRpcPort => .simnet,
  kDevnetRpcPort => .devnet,
  _ => .mainnet,
};

SedraNetwork networkForKpub(String kpub) => switch (kpub.substring(0, 4)) {
  'kpub' => .mainnet,
  'ktub' => .testnet,
  'ksub' => .simnet,
  'kdub' => .devnet,
  _ => .mainnet,
};

NetworkType networkTypeForNetwork(SedraNetwork network) => switch (network) {
  .mainnet => sedraMainnet,
  .testnet => sedraTestnet,
  .devnet => sedraDevnet,
  .simnet => sedraSimnet,
};

final sedraMainnet = NetworkType(
  messagePrefix: 'Sedra Signed Message:\n',
  bech32: 'sedra',
  bip32: Bip32Type(
    public: 0x038f332e,
    private: 0x038f2ef4,
  ),
  wif: 0x80,
  pubKeyHash: 0x00,
  scriptHash: 0x05,
  opreturnSize: 80,
);

final sedraTestnet = NetworkType(
  messagePrefix: 'Sedra Signed Message:\n',
  bech32: 'sedratest',
  wif: 0xef,
  bip32: Bip32Type(
    public: 0x0390a241,
    private: 0x03909e07,
  ),
  pubKeyHash: 0x00,
  scriptHash: 0x05,
  opreturnSize: 80,
);

final sedraSimnet = NetworkType(
  messagePrefix: 'Sedra Signed Message:\n',
  bech32: 'sedrasim',
  wif: 0x64,
  bip32: Bip32Type(
    public: 0x0390467d,
    private: 0x03904242,
  ),
  pubKeyHash: 0x00,
  scriptHash: 0x05,
  opreturnSize: 80,
);

final sedraDevnet = NetworkType(
  messagePrefix: 'Sedra Signed Message:\n',
  bech32: 'sedradev',
  wif: 0xef,
  bip32: Bip32Type(
    public: 0x038b41ba,
    private: 0x038b3d80,
  ),
  pubKeyHash: 0x00,
  scriptHash: 0x05,
  opreturnSize: 80,
);
