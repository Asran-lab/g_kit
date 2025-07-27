/* 앱 전역 상수 */
const String kAppName = 'AppName';
const String kAppVersion = 'AppVersion';
const String kAppAuthor = 'AppAuthor';
const String kAppDescription = 'AppDescription';
const String kAppStoreUrl = 'AppStoreUrl';
const String kAppSupportEmail = 'AppSupportEmail';
const String kDefaultTargetPlatform = 'defaultTargetPlatform';

/* 앱 환경 설정 */
const String kEnvType = 'EnvType';
const String kBaseUrl = 'BaseUrl';
const String kBuildNumber = 'BuildNumber';
const String kBundleId = 'BundleId';
const String kPackageName = 'PackageName';
const String kAppLink = 'AppLink';
const String kSupportedLanguage = 'SupportedLanguage';

/* 환경 관련 */
const bool kIsDebug = bool.fromEnvironment('dart.vm.product') == false;
const bool kIsProduction = !kIsDebug;
