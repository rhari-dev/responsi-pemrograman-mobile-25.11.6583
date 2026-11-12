import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Akses isi catatan lewat penyimpanan terenkripsi perangkat.
class SecureStorageService {
  /// Membuat layanan dengan storage opsional untuk pengujian.
  const SecureStorageService({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  String _key(String noteId) {
    if (!RegExp(r'^[a-zA-Z0-9_-]+$').hasMatch(noteId)) {
      throw const FormatException('ID catatan tidak valid.');
    }
    return 'note_content_$noteId';
  }

  /// Menyimpan isi catatan terenkripsi dengan key `note_content_<id>`.
  Future<void> saveContent(String noteId, String content) =>
      _storage.write(key: _key(noteId), value: content);

  /// Membaca isi catatan; null jika belum tersimpan.
  Future<String?> getContent(String noteId) => _storage.read(key: _key(noteId));

  /// Menghapus isi catatan terenkripsi.
  Future<void> deleteContent(String noteId) =>
      _storage.delete(key: _key(noteId));
}
