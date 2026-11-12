import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/note.dart';
import '../services/secure_storage_service.dart';

/// Repository metadata catatan dan isi terenkripsi.
class NoteRepository {
  /// Membuat repository dengan dependency opsional untuk pengujian.
  NoteRepository({
    SharedPreferencesAsync? preferences,
    SecureStorageService? storage,
  }) : _preferences = preferences ?? SharedPreferencesAsync(),
       _storage = storage ?? const SecureStorageService();

  static const _metadataKey = 'notes_metadata';
  final SharedPreferencesAsync _preferences;
  final SecureStorageService _storage;

  Future<List<Map<String, dynamic>>> _metadata() async {
    final raw = await _preferences.getString(_metadataKey);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list.map((item) => Map<String, dynamic>.from(item as Map)).toList();
  }

  /// Memuat metadata dan isi catatan tanpa menyimpan isi ke SharedPreferences.
  Future<List<Note>> loadNotes() async {
    final metadata = await _metadata();
    final notes = <Note>[];
    for (final item in metadata) {
      final id = item['id'] as String;
      final content = await _storage.getContent(id);
      if (content == null) {
        throw StateError('Isi catatan tidak tersedia di secure storage.');
      }
      notes.add(
        Note(
          id: id,
          title: item['title'] as String,
          content: content,
          date: DateTime.parse(item['date'] as String),
        ),
      );
    }
    return notes;
  }

  /// Menyimpan isi terenkripsi dahulu, lalu metadata sebagai JSON list.
  Future<void> addNote(Note note) async {
    final metadata = await _metadata();
    if (metadata.any((item) => item['id'] == note.id)) {
      throw StateError('ID catatan sudah ada.');
    }
    await _storage.saveContent(note.id, note.content);
    try {
      await _preferences.setString(
        _metadataKey,
        jsonEncode([
          ...metadata,
          {
            'id': note.id,
            'title': note.title,
            'date': note.date.toIso8601String(),
          },
        ]),
      );
    } catch (_) {
      await _storage.deleteContent(note.id);
      rethrow;
    }
  }

  /// Menghapus isi serta metadata catatan berdasarkan ID.
  Future<void> deleteNote(String id) async {
    final metadata = await _metadata();
    if (!metadata.any((item) => item['id'] == id)) return;
    await _storage.deleteContent(id);
    await _preferences.setString(
      _metadataKey,
      jsonEncode(metadata.where((item) => item['id'] != id).toList()),
    );
  }
}
