/// App 對後端的環境設定。
///
/// 依 docs/Eco-Sensing_App_驗證機制_開發參考.md §4.1：base URL 不可寫死，
/// 須可依環境切換。預設指向部署後正式環境；本機測試時以
/// `--dart-define=API_BASE_URL=http://10.0.2.2:8000`（Android 模擬器）等值覆寫。
class AppConfig {
  const AppConfig._();

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://uie47061-eco-sensing-backend.hf.space',
  );
}
