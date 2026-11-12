import 'package:flutter/material.dart';

import '../models/student.dart';
import '../widgets/profile_card.dart';

/// Halaman profil mahasiswa dengan penyuntingan data sementara.
class ProfileScreen extends StatefulWidget {
  /// Membuat halaman profil, dengan data awal opsional.
  const ProfileScreen({super.key, this.initialStudent});

  /// Data awal profil; jika kosong, contoh data ditampilkan.
  final Student? initialStudent;

  /// Membuat state halaman profil.
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Student _student;

  @override
  void initState() {
    super.initState();
    _student =
        widget.initialStudent ??
        Student(
          name: 'Mahasiswa Amikom',
          nim: '00000000',
          programStudi: 'Informatika',
          email: 'mahasiswa@example.com',
        );
  }

  Future<void> _editProfile() async {
    final edited = await showDialog<Student>(
      context: context,
      builder: (context) => _EditProfileDialog(student: _student),
    );
    if (!mounted || edited == null) return;
    setState(() => _student = edited);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Mahasiswa')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ProfileCard(student: _student),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: _editProfile,
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Edit Profil'),
              ),
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
