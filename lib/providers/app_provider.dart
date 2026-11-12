import 'package:flutter/widgets.dart';

import '../models/note.dart';
import '../models/student.dart';

/// Menyediakan profil dan catatan bagi widget di bawahnya.
class AppProvider extends InheritedWidget {
  /// Membuat penyedia state aplikasi.
  const AppProvider({
    super.key,
    required this.student,
    required this.notes,
    required this.updateStudent,
    required this.addNote,
    required this.deleteNote,
    required super.child,
  });

  /// Profil mahasiswa saat ini.
  final Student student;

  /// Daftar catatan yang tidak dapat diubah langsung oleh widget konsumen.
  final List<Note> notes;

  /// Mengganti profil mahasiswa.
  final void Function(Student) updateStudent;

  /// Menambah catatan.
  final void Function(Note) addNote;

  /// Menghapus catatan berdasarkan ID.
  final void Function(String) deleteNote;

  /// Mengakses state aplikasi sekaligus mendaftarkan dependensi widget.
  static AppProvider of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<AppProvider>();
    assert(provider != null, 'AppProviderWrapper harus menjadi ancestor.');
    return provider!;
  }

  /// Memberi tahu konsumen jika profil atau daftar catatan berubah.
  @override
  bool updateShouldNotify(AppProvider oldWidget) =>
      student != oldWidget.student || notes != oldWidget.notes;
}

/// Menyimpan state aplikasi di memori dan membagikannya lewat [AppProvider].
class AppProviderWrapper extends StatefulWidget {
  /// Membungkus halaman aplikasi; profil awal boleh diganti untuk pengujian.
  const AppProviderWrapper({
    super.key,
    required this.child,
    this.initialStudent,
  });

  /// Halaman di bawah provider.
  final Widget child;

  /// Profil awal opsional.
  final Student? initialStudent;

  /// Membuat state pembungkus.
  @override
  State<AppProviderWrapper> createState() => _AppProviderWrapperState();
}

class _AppProviderWrapperState extends State<AppProviderWrapper> {
  late Student _student;
  List<Note> _notes = [];

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

  void _updateStudent(Student student) => setState(() => _student = student);

  void _addNote(Note note) => setState(() => _notes = [..._notes, note]);

  void _deleteNote(String id) {
    if (!_notes.any((note) => note.id == id)) return;
    setState(() => _notes = _notes.where((note) => note.id != id).toList());
  }

  /// Meneruskan state dan callback ke subtree.
  @override
  Widget build(BuildContext context) {
    return AppProvider(
      student: _student,
      notes: List.unmodifiable(_notes),
      updateStudent: _updateStudent,
      addNote: _addNote,
      deleteNote: _deleteNote,
      child: widget.child,
    );
  }
}
