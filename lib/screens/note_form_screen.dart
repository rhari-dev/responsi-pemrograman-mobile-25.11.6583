import 'package:flutter/material.dart';

import '../models/note.dart';
import '../providers/app_provider.dart';
import '../utils/validators.dart';

/// Form untuk membuat catatan kuliah dengan validasi input.
class NoteFormScreen extends StatefulWidget {
  /// Membuat form catatan.
  const NoteFormScreen({super.key});

  /// Membuat state form catatan.
  @override
  State<NoteFormScreen> createState() => _NoteFormScreenState();
}

class _NoteFormScreenState extends State<NoteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _content = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _title.dispose();
    _content.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving || !_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final now = DateTime.now();
    try {
      await AppProvider.of(context).addNote(
        Note(
          id: now.microsecondsSinceEpoch.toString(),
          title: Validators.sanitize(_title.text),
          content: Validators.sanitize(_content.text),
          date: now,
        ),
      );
      if (mounted) Navigator.pop(context, true);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Catatan gagal disimpan. Coba lagi.')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  /// Membuat form judul dan isi catatan.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Catatan')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _title,
                  decoration: const InputDecoration(
                    labelText: 'Judul catatan',
                    border: OutlineInputBorder(),
                  ),
                  maxLength: 50,
                  validator: Validators.validateTitle,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _content,
                  decoration: const InputDecoration(
                    labelText: 'Isi catatan',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  minLines: 5,
                  maxLines: 10,
                  maxLength: 1000,
                  validator: Validators.validateContent,
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: _saving ? null : _save,
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('Simpan Catatan'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
