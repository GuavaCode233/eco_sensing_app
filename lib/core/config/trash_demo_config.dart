/// 前端只使用 publishable / anon key，不可放 service_role key。
class TrashDemoConfig {
  const TrashDemoConfig._();

  static const supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://svshoobbhjciypwvdgob.supabase.co',
  );
  static const supabaseKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
    defaultValue: 'sb_publishable_yfMQr_dLGK9xyQ5cd-NhXw_7kLgqdnO',
  );
  static bool get isConfigured =>
      Uri.tryParse(supabaseUrl)?.hasAuthority == true &&
      supabaseUrl.startsWith('https://') &&
      supabaseKey.isNotEmpty;
}
