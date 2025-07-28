extension ListExtension<T> on List<T> {
  List<T> get safe => this;

  T? get firstOrNull => isEmpty ? null : first;
  T? get lastOrNull => isEmpty ? null : last;

  List<T> distinctBy(bool Function(T a, T b) comparator) {
    final result = <T>[];
    for (final item in this) {
      if (!result.any((e) => comparator(e, item))) {
        result.add(item);
      }
    }
    return result;
  }

  List<T> whereNotNull() => where((e) => e != null).toList();

  List<T> whereNull() => where((e) => e == null).toList();
}
