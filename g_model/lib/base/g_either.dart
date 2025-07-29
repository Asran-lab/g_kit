sealed class GEither<L, R> {
  const GEither();
  factory GEither.left(L l) => Left(l);
  factory GEither.right(R r) => Right(r);

  /// JSON 형식의 데이터를 Either 타입으로 변환
  factory GEither.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('left')) {
      return GEither.left(json['left']);
    } else {
      return GEither.right(json['right']);
    }
  }

  T fold<T>(T Function(L) left, T Function(R) right) => switch (this) {
    Left(:final value) => left(value),
    Right(:final value) => right(value),
  };
  bool isLeft() => switch (this) {
    Left() => true,
    Right() => false,
  };
  bool isRight() => !isLeft();
}

/// 오류 값을 반환하는 타입
class Left<L, R> extends GEither<L, R> {
  final L _l;
  const Left(this._l);
  L get value => _l;
}

/// 성공 값을 반환하는 타입
class Right<L, R> extends GEither<L, R> {
  final R _r;
  const Right(this._r);
  R get value => _r;
}

extension EitherX<L, R> on GEither<L, R> {
  R? get rightOrNull => isRight() ? (this as Right<L, R>).value : null;
  L? get leftOrNull => isLeft() ? (this as Left<L, R>).value : null;
  GEither<L, R2> mapRight<R2>(R2 Function(R value) transform) => switch (this) {
    Left() => this as GEither<L, R2>,
    Right(:final value) => Right(transform(value)),
  };
  GEither<L2, R> mapLeft<L2>(L2 Function(L value) transform) => switch (this) {
    Left(:final value) => Left(transform(value)),
    Right() => this as GEither<L2, R>,
  };
}
