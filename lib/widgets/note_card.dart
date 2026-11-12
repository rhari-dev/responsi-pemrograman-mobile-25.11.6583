import 'package:flutter/material.dart';

import '../models/note.dart';

/// Kartu ringkas untuk satu catatan kuliah.
class NoteCard extends StatelessWidget {
  /// Membuat kartu catatan dengan aksi lihat dan hapus.
  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onDelete,
  });

  /// Catatan yang ditampilkan.
  final Note note;

  /// Aksi untuk melihat isi catatan.
  final VoidCallback onTap;

  /// Aksi untuk meminta penghapusan catatan.
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final date = note.date.toLocal();
    final formattedDate =
        '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/${date.year}';

    return Card(
      child: ListTile(
        title: Text(note.title),
        subtitle: Text(formattedDate),
        onTap: onTap,
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          tooltip: 'Hapus catatan',
          onPressed: onDelete,
        ),
      ),
    );
  }
}
