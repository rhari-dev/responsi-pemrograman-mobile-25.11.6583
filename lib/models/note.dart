/// Catatan kuliah beserta isi yang hanya berada di memori pada Soal 3.
class Note {
  /// Membuat catatan baru.
  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
  });

  /// Identitas unik catatan.
  final String id;

  /// Judul catatan.
  final String title;

  /// Isi catatan.
  final String content;

  /// Waktu pembuatan catatan.
  final DateTime date;
}
