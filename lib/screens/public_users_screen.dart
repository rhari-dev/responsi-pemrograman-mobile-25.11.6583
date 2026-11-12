import 'package:flutter/material.dart';

import '../services/public_api_service.dart';

/// Halaman daftar nama pengguna dari API publik.
class PublicUsersScreen extends StatefulWidget {
  /// Membuat halaman API dengan layanan opsional untuk pengujian.
  const PublicUsersScreen({super.key, this.service});

  /// Layanan untuk meminta data publik.
  final PublicApiService? service;

  /// Membuat state halaman.
  @override
  State<PublicUsersScreen> createState() => _PublicUsersScreenState();
}

class _PublicUsersScreenState extends State<PublicUsersScreen> {
  late final PublicApiService _service;
  late Future<List<String>> _users;

  @override
  void initState() {
    super.initState();
    _service = widget.service ?? PublicApiService();
    _users = _service.fetchUserNames();
  }

  @override
  void dispose() {
    if (widget.service == null) _service.dispose();
    super.dispose();
  }

  void _retry() => setState(() => _users = _service.fetchUserNames());

  /// Membangun daftar, indikator muat, dan pesan kegagalan API.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Pengguna')),
      body: FutureBuilder<List<String>>(
        future: _users,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            final error = snapshot.error;
            final message = error is PublicApiException
                ? error.message
                : 'Data gagal dimuat. Coba lagi.';
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(message),
                  TextButton(onPressed: _retry, child: const Text('Coba lagi')),
                ],
              ),
            );
          }
          final users = snapshot.data!;
          if (users.isEmpty) {
            return const Center(child: Text('Belum ada data.'));
          }
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) => ListTile(
              leading: const Icon(Icons.person_outline),
              title: Text(users[index]),
            ),
          );
        },
      ),
    );
  }
}
