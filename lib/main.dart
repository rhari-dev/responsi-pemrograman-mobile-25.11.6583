import 'package:flutter/material.dart';

import 'config/app_config.dart';
import 'providers/app_provider.dart';
import 'screens/home_screen.dart';

/// Menjalankan aplikasi profil mahasiswa.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppConfig.load();
  runApp(const MyApp());
}

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
      builder: (context, child) => AppProviderWrapper(child: child!),
      home: const HomeScreen(),
    );
  }
}
