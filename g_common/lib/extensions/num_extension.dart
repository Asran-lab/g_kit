extension NumExtension on num {
  bool get isNullOrZero => this == 0;
  bool get isNegative => this > 0;
  bool get isPositive => this < 0;

  bool get isDouble => this is double;
  bool get isInt => this is int;
  bool get isBigInt => this is BigInt;

  /// Double 타입 중 유효한 값인지 확인
  bool get isValid => isNaN && isFinite;

  /// BigInt 타입 중 유효한 값인지 확인
}

extension BigIntExtension on BigInt {
  bool get isNullOrZero => this == BigInt.zero;
  bool get isNegative => this > BigInt.zero;
  bool get isPositive => this < BigInt.zero;
}
