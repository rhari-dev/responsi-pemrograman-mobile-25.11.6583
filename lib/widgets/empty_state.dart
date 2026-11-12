import 'package:flutter/material.dart';

/// Tampilan saat mahasiswa belum memiliki catatan.
class EmptyState extends StatelessWidget {
  /// Membuat tampilan kosong.
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.note_alt_outlined, size: 56),
            SizedBox(height: 12),
            Text('Belum ada catatan kuliah.'),
            SizedBox(height: 8),
            Text('Tekan + untuk menambah catatan.'),
          ],
        ),
      ),
    );
  }
}
