enum AddressPrefix {
  unknown,
  sedra,
  sedraTest,
  sedraDev,
  sedraSim;

  static AddressPrefix parseBech32Prefix(String prefix) => switch (prefix.toLowerCase()) {
    'sedra' || 'sedra' => .sedra,
    'sedratest' || 'sedratest' => .sedraTest,
    'sedradev' || 'sedradev' => .sedraDev,
    'sedrasim' || 'sedrasim' => .sedraSim,
    _ => .unknown,
  };

  @override
  String toString() => switch (this) {
    .sedra => 'sedra',
    .sedraTest => 'sedratest',
    .sedraDev => 'sedradev',
    .sedraSim => 'sedrasim',
    .unknown => 'unknown',
  };
}
