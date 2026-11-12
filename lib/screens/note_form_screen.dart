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

  @override
  void dispose() {
    _title.dispose();
    _content.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final now = DateTime.now();
    AppProvider.of(context).addNote(
      Note(
        id: now.microsecondsSinceEpoch.toString(),
        title: Validators.sanitize(_title.text),
        content: Validators.sanitize(_content.text),
        date: now,
      ),
    );
    Navigator.pop(context, true);
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
                  onPressed: _save,
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
