import 'package:g_model/g_model.dart';

enum GStorageType implements GBaseType {
  prefs(name: 'prefs', isSecure: false),
  secure(name: 'secure', isSecure: true);

  final String name;
  final bool isSecure;

  const GStorageType({
    required this.name,
    required this.isSecure,
  });

  static GStorageType fromString(String name) {
    return GStorageType.values.firstWhere((e) => e.name == name);
  }

  static GStorageType fromBool(bool isSecure) {
    return isSecure ? GStorageType.secure : GStorageType.prefs;
  }

  static bool isSecured(GStorageType type) => type.isSecure;
}
