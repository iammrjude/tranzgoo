class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://tranzgoo.vercel.app',
  );

  static const Duration timeout = Duration(seconds: 30);

  static Uri uri(String path) {
    final cleanBaseUrl = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    final cleanPath = path.startsWith('/') ? path : '/$path';

    return Uri.parse('$cleanBaseUrl$cleanPath');
  }
}
