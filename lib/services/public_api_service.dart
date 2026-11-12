import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:http/http.dart' as http;

import '../config/app_config.dart';

/// Mengambil daftar pengguna dari API publik tanpa mengirim data sensitif.
class PublicApiService {
  /// Membuat layanan dengan HTTP client opsional untuk pengujian.
  PublicApiService({http.Client? client})
    : _client = client ?? http.Client(),
      _ownsClient = client == null;

  final http.Client _client;
  final bool _ownsClient;

  /// Mengambil nama pengguna dengan timeout dan error yang aman ditampilkan.
  Future<List<String>> fetchUserNames() async {
    try {
      final response = await _client
          .get(AppConfig.baseUrl.resolve('/users'))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) {
        throw const PublicApiException('Server gagal memuat data.');
      }
      final users = jsonDecode(response.body) as List<dynamic>;
      return users
          .map((item) => (item as Map<String, dynamic>)['name'] as String)
          .toList();
    } on TimeoutException {
      throw const PublicApiException('Permintaan terlalu lama. Coba lagi.');
    } on SocketException {
      throw const PublicApiException('Tidak ada koneksi internet.');
    } on HttpException {
      throw const PublicApiException('Koneksi ke server gagal.');
    } on FormatException {
      throw const PublicApiException('Format data server tidak valid.');
    } on PublicApiException {
      rethrow;
    } catch (_) {
      throw const PublicApiException('Data gagal dimuat. Coba lagi.');
    }
  }

  /// Menutup client jika layanan membuatnya sendiri.
  void dispose() {
    if (_ownsClient) _client.close();
  }
}

/// Error API yang aman ditampilkan tanpa membocorkan respons server.
class PublicApiException implements Exception {
  /// Membuat error dengan pesan tanpa data sensitif.
  const PublicApiException(this.message);

  /// Pesan untuk pengguna.
  final String message;
}
