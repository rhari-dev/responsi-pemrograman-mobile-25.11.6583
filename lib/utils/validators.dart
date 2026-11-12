/// Aturan validasi dan sanitasi input catatan kuliah.
class Validators {
  Validators._();

  /// Membuang karakter berbahaya dan spasi di awal/akhir input.
  static String sanitize(String input) =>
      input.replaceAll(RegExp('[<>"\']'), '').trim();

  /// Memeriksa judul hasil sanitasi (3 sampai 50 karakter).
  static String? validateTitle(String? value) {
    final title = sanitize(value ?? '');
    if (title.length < 3) return 'Judul minimal 3 karakter.';
    if (title.length > 50) return 'Judul maksimal 50 karakter.';
    if (RegExp(r'[\x00-\x1F\x7F]').hasMatch(title)) {
      return 'Judul mengandung karakter tidak diperbolehkan.';
    }
    return null;
  }

  /// Memeriksa isi hasil sanitasi (10 sampai 1000 karakter).
  static String? validateContent(String? value) {
    final content = sanitize(value ?? '');
    if (content.length < 10) return 'Isi catatan minimal 10 karakter.';
    if (content.length > 1000) return 'Isi catatan maksimal 1000 karakter.';
    if (RegExp(r'[\x00-\x08\x0B\x0C\x0E-\x1F\x7F]').hasMatch(content)) {
      return 'Isi catatan mengandung karakter tidak diperbolehkan.';
    }
    return null;
  }
}
