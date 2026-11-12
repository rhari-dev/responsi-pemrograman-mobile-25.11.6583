import 'package:flutter/material.dart';

import 'screens/profile_screen.dart';

/// Menjalankan aplikasi profil mahasiswa.
void main() => runApp(const MyApp());

/// Akar aplikasi untuk tugas profil mahasiswa.
class MyApp extends StatelessWidget {
  /// Membuat akar aplikasi.
  const MyApp({super.key});

  /// Membangun tema dan halaman awal aplikasi.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profil Mahasiswa',
      theme: ThemeData(colorSchemeSeed: Colors.deepPurple, useMaterial3: true),
      home: const ProfileScreen(),
    );
  }
}
