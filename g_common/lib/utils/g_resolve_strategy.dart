import 'package:g_model/g_model.dart';

T resolveStrategy<T>({
  Map<GBaseType, T>? strategies,
  T? defaultStrategy,
  GBaseType? type,
}) {
  final strategy = strategies?[type] ?? defaultStrategy;
  if (strategy == null) {
    throw Exception('Strategy not found for type: $type');
  }
  return strategy as T;
}
