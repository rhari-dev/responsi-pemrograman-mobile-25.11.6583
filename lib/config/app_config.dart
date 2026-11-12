import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Konfigurasi aplikasi yang diambil dari asset .env, bukan kode sumber.
class AppConfig {
  AppConfig._();

  /// Memuat konfigurasi saat aplikasi dimulai.
  static Future<void> load() => dotenv.load(fileName: '.env');

  /// Alamat dasar API publik; hanya HTTPS diizinkan.
  static Uri get baseUrl {
    final uri = Uri.tryParse(dotenv.env['BASE_URL'] ?? '');
    if (uri == null || uri.scheme != 'https' || uri.host.isEmpty) {
      throw const FormatException(
        'BASE_URL harus berupa URL HTTPS yang valid.',
      );
    }
    return uri;
  }

  /// Kunci dummy dari .env; jangan dicetak atau dikirim ke API publik.
  static String get apiKey => dotenv.env['API_KEY'] ?? '';
}
