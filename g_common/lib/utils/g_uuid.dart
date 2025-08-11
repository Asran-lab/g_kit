import 'dart:math';

Random _random = Random.secure();

String _bytesToHex(List<int> bytes) {
  final buffer = StringBuffer();
  for (int i = 0; i < bytes.length; i++) {
    final hex = bytes[i].toRadixString(16).padLeft(2, '0');
    buffer.write(hex);
    // Add hyphens at UUID positions
    if ([3, 5, 7, 9].contains(i)) buffer.write('-');
  }
  return buffer.toString();
}

/// v4 UUID 생성
/// ex) GUuid.generate()
class GUuid {
  static String generate() {
    final bytes = List<int>.generate(16, (_) => _random.nextInt(256));

    // RFC 4122 compliance
    bytes[6] = (bytes[6] & 0x0F) | 0x40; // Version 4
    bytes[8] = (bytes[8] & 0x3F) | 0x80; // Variant 10

    return _bytesToHex(bytes);
  }
}

/// v4 UUID 생성
/// ex) generateUUID()
String generateUUID() {
  return GUuid.generate();
}
