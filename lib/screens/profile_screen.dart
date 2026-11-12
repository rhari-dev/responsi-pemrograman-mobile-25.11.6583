import 'package:flutter/material.dart';

import '../models/student.dart';
import '../providers/app_provider.dart';
import '../widgets/profile_card.dart';
import 'note_form_screen.dart';
import 'public_users_screen.dart';

/// Halaman profil mahasiswa yang membaca data dari [AppProvider].
class ProfileScreen extends StatelessWidget {
  /// Membuat halaman profil.
  const ProfileScreen({super.key});

  Future<void> _editProfile(BuildContext context, Student student) async {
    final edited = await showDialog<Student>(
      context: context,
      builder: (context) => _EditProfileDialog(student: student),
    );
    if (!context.mounted || edited == null) return;
    AppProvider.of(context).updateStudent(edited);
  }

  Future<void> _openNoteForm(BuildContext context) async {
    await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const NoteFormScreen()),
    );
  }

  /// Membangun tampilan profil serta pintu masuk form catatan.
  @override
  Widget build(BuildContext context) {
    final provider = AppProvider.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Mahasiswa')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ProfileCard(student: provider.student),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: () => _editProfile(context, provider.student),
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Edit Profil'),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => _openNoteForm(context),
                icon: const Icon(Icons.note_add_outlined),
                label: const Text('Tambah Catatan'),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => Navigator.push<void>(
                  context,
                  MaterialPageRoute(builder: (_) => const PublicUsersScreen()),
                ),
                icon: const Icon(Icons.public),
                label: const Text('Daftar Pengguna'),
              ),
              if (provider.isLoading) ...[
                const SizedBox(height: 20),
                const Center(child: CircularProgressIndicator()),
              ],
              if (provider.storageError != null) ...[
                const SizedBox(height: 20),
                Text(provider.storageError!),
                TextButton(
                  onPressed: provider.reloadNotes,
                  child: const Text('Coba lagi'),
                ),
              ],
              if (provider.notes.isNotEmpty) ...[
                const SizedBox(height: 20),
                Text(
                  'Catatan (${provider.notes.length})',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                for (final note in provider.notes)
                  ListTile(title: Text(note.title)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _EditProfileDialog extends StatefulWidget {
  const _EditProfileDialog({required this.student});

  final Student student;

  @override
  State<_EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<_EditProfileDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _nim;
  late final TextEditingController _programStudi;
  late final TextEditingController _email;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.student.name);
    _nim = TextEditingController(text: widget.student.nim);
    _programStudi = TextEditingController(text: widget.student.programStudi);
    _email = TextEditingController(text: widget.student.email);
  }

  @override
  void dispose() {
    _name.dispose();
    _nim.dispose();
    _programStudi.dispose();
    _email.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final updated = Student(
      name: _name.text,
      nim: _nim.text,
      programStudi: _programStudi.text,
      email: _email.text,
    );
    Navigator.pop(context, updated);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Profil'),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _name,
                  decoration: const InputDecoration(labelText: 'Nama'),
                  textCapitalization: TextCapitalization.words,
                  maxLength: 80,
                  validator: Student.validateName,
                ),
                TextFormField(
                  controller: _nim,
                  decoration: const InputDecoration(labelText: 'NIM'),
                  maxLength: 30,
                  validator: Student.validateNim,
                ),
                TextFormField(
                  controller: _programStudi,
                  decoration: const InputDecoration(labelText: 'Program Studi'),
                  textCapitalization: TextCapitalization.words,
                  maxLength: 100,
                  validator: Student.validateProgramStudi,
                ),
                TextFormField(
                  controller: _email,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  maxLength: 254,
                  validator: Student.validateEmail,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        FilledButton(onPressed: _save, child: const Text('Simpan')),
      ],
    );
  }
}
