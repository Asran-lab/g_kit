enum GAuthStrategyType {
  shortCode,
  oauth,
  wallet,
  passkey;

  String get name => switch (this) {
        GAuthStrategyType.shortCode => 'short_code',
        GAuthStrategyType.oauth => 'oauth',
        GAuthStrategyType.wallet => 'wallet',
        GAuthStrategyType.passkey => 'passkey',
      };

  static GAuthStrategyType fromName(String name) => switch (name) {
        'short_code' => GAuthStrategyType.shortCode,
        'oauth' => GAuthStrategyType.oauth,
        'wallet' => GAuthStrategyType.wallet,
        'passkey' => GAuthStrategyType.passkey,
        _ => throw ArgumentError('Unknown auth strategy type: $name'),
      };
}
