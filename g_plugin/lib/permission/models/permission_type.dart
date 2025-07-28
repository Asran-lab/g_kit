/// 권한 타입 enum
///
/// 플랫폼별로 지원되는 권한들을 정의합니다.
enum PermissionType {
  // 공통 권한 (모든 플랫폼에서 지원)
  camera,
  microphone,
  storage,
  location,
  notification,

  // Android 특화 권한
  androidPhone,
  androidSms,
  androidContacts,
  androidCalendar,
  androidSensors,
  androidActivityRecognition,

  // iOS 특화 권한
  iosPhotos,
  iosCalendar,
  iosReminders,
  iosContacts,
  iosMediaLibrary,
  iosSpeech,
  iosHealth,

  // macOS 특화 권한
  macosPhotos,
  macosCalendar,
  macosReminders,
  macosContacts,
  macosMediaLibrary,
  macosSpeech,
  macosHealth,

  // Web 특화 권한
  webClipboard,
  webPayment,
  webUsb,
  webBluetooth,
}
