import 'package:flutter/widgets.dart';

import '../models/note.dart';
import '../models/student.dart';
import '../repositories/note_repository.dart';

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
    required this.isLoading,
    required this.storageError,
    required this.reloadNotes,
    required super.child,
  });

  /// Profil mahasiswa saat ini.
  final Student student;

  /// Daftar catatan yang tidak dapat diubah langsung oleh widget konsumen.
  final List<Note> notes;

  /// Mengganti profil mahasiswa.
  final void Function(Student) updateStudent;

  /// Menambah catatan lewat repository.
  final Future<void> Function(Note) addNote;

  /// Menghapus catatan berdasarkan ID lewat repository.
  final Future<void> Function(String) deleteNote;

  /// Apakah catatan sedang dimuat.
  final bool isLoading;

  /// Pesan aman jika penyimpanan tidak dapat diakses.
  final String? storageError;

  /// Mencoba memuat ulang catatan dari repository.
  final Future<void> Function() reloadNotes;

  /// Mengakses state aplikasi sekaligus mendaftarkan dependensi widget.
  static AppProvider of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<AppProvider>();
    assert(provider != null, 'AppProviderWrapper harus menjadi ancestor.');
    return provider!;
  }

  /// Memberi tahu konsumen jika profil, catatan, atau status berubah.
  @override
  bool updateShouldNotify(AppProvider oldWidget) =>
      student != oldWidget.student ||
      notes != oldWidget.notes ||
      isLoading != oldWidget.isLoading ||
      storageError != oldWidget.storageError;
}

/// Mengelola state dan menjadikan repository satu-satunya akses catatan.
class AppProviderWrapper extends StatefulWidget {
  /// Membungkus halaman aplikasi dengan state dan repository.
  const AppProviderWrapper({
    super.key,
    required this.child,
    this.initialStudent,
    this.noteRepository,
  });

  /// Halaman di bawah provider.
  final Widget child;

  /// Profil awal opsional.
  final Student? initialStudent;

  /// Repository opsional, misalnya untuk pengujian widget.
  final NoteRepository? noteRepository;

  /// Membuat state pembungkus.
  @override
  State<AppProviderWrapper> createState() => _AppProviderWrapperState();
}

class _AppProviderWrapperState extends State<AppProviderWrapper> {
  late Student _student;
  late final NoteRepository _repository;
  List<Note> _notes = [];
  bool _isLoading = true;
  String? _storageError;

  @override
  void initState() {
    super.initState();
    _repository = widget.noteRepository ?? NoteRepository();
    _student =
        widget.initialStudent ??
        Student(
          name: 'Mahasiswa Amikom',
          nim: '00000000',
          programStudi: 'Informatika',
          email: 'mahasiswa@example.com',
        );
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    setState(() {
      _isLoading = true;
      _storageError = null;
    });
    try {
      final notes = await _repository.loadNotes();
      if (!mounted) return;
      setState(() {
        _notes = notes;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _storageError = 'Catatan gagal dimuat. Coba lagi.';
      });
    }
  }

  void _updateStudent(Student student) => setState(() => _student = student);

  Future<void> _addNote(Note note) async {
    await _repository.addNote(note);
    if (mounted) setState(() => _notes = [..._notes, note]);
  }

  Future<void> _deleteNote(String id) async {
    if (!_notes.any((note) => note.id == id)) return;
    await _repository.deleteNote(id);
    if (mounted) {
      setState(() => _notes = _notes.where((note) => note.id != id).toList());
    }
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
      isLoading: _isLoading,
      storageError: _storageError,
      reloadNotes: _loadNotes,
      child: widget.child,
    );
  }
}
