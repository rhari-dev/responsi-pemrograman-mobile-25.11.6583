import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:responsi_profil_mahasiswa/providers/app_provider.dart';
import 'package:responsi_profil_mahasiswa/screens/profile_screen.dart';
import 'package:responsi_profil_mahasiswa/services/secure_storage_service.dart';
import 'package:responsi_profil_mahasiswa/main.dart';
import 'package:responsi_profil_mahasiswa/models/student.dart';
import 'package:responsi_profil_mahasiswa/utils/validators.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Menguji model mahasiswa dan interaksi halaman profil.
void main() {
  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    FlutterSecureStorage.setMockInitialValues({});
  });
  test('Student merapikan input dan menolak karakter berbahaya', () {
    final student = Student(
      name: '  Budi   Santoso  ',
      nim: '  12345678  ',
      programStudi: '  Informatika  ',
      email: '  budi@example.com  ',
    );

    expect(student.name, 'Budi Santoso');
    expect(student.nim, '12345678');
    expect(student.programStudi, 'Informatika');
    expect(student.email, 'budi@example.com');
    expect(Student.validateName('<script>'), isNotNull);
    expect(Student.validateEmail('bukan-email'), isNotNull);
  });

  testWidgets('Profil tampil dan bisa diedit', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Mahasiswa Amikom'), findsOneWidget);
    expect(find.text('NIM: 00000000'), findsOneWidget);
    expect(find.text('Informatika'), findsOneWidget);
    expect(find.text('mahasiswa@example.com'), findsOneWidget);
    expect(find.text('MA'), findsOneWidget);

    await tester.tap(find.text('Edit Profil'));
    await tester.pumpAndSettle();
    expect(find.byType(TextFormField), findsNWidgets(4));

    await tester.enterText(find.byType(TextFormField).first, '<script>');
    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();
    expect(
      find.text('Nama mengandung karakter tidak diperbolehkan.'),
      findsOneWidget,
    );

    await tester.enterText(find.byType(TextFormField).first, 'Budi Santoso');
    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();
    expect(find.text('Budi Santoso'), findsOneWidget);
    expect(find.text('BS'), findsOneWidget);
  });

  test('Validasi batas judul dan isi, lalu sanitasi karakter', () {
    expect(Validators.validateTitle('ab'), isNotNull);
    expect(Validators.validateTitle('a' * 51), isNotNull);
    expect(Validators.validateTitle('abc'), isNull);
    expect(Validators.validateContent('123456789'), isNotNull);
    expect(Validators.validateContent('a' * 1001), isNotNull);
    expect(Validators.validateContent('a' * 10), isNull);
    expect(Validators.sanitize('  <judul> "aman" \'ok\'  '), 'judul aman ok');
    expect(Validators.validateContent('isi\x00catatan valid'), isNotNull);
  });

  testWidgets('Form catatan validasi lalu menyimpan di provider', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('Tambah Catatan'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Simpan Catatan'));
    await tester.pumpAndSettle();
    expect(find.text('Judul minimal 3 karakter.'), findsOneWidget);
    expect(find.text('Isi catatan minimal 10 karakter.'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).first, '  <Kuliah>  ');
    await tester.enterText(
      find.byType(TextFormField).last,
      '  Catatan kuliah pertama  ',
    );
    await tester.tap(find.text('Simpan Catatan'));
    await tester.pumpAndSettle();

    expect(find.text('Kuliah'), findsOneWidget);
    expect(find.text('Catatan (1)'), findsOneWidget);

    final stored = (await SharedPreferencesAsync().getString(
      'notes_metadata',
    ))!;
    expect(stored, contains('Kuliah'));
    expect(stored, isNot(contains('Catatan kuliah pertama')));

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    expect(find.text('Kuliah'), findsOneWidget);
    expect(find.text('Catatan (1)'), findsOneWidget);
  });

  testWidgets('Provider menghapus catatan dari kedua storage', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('Tambah Catatan'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, 'Kuliah');
    await tester.enterText(
      find.byType(TextFormField).last,
      'Isi catatan kuliah',
    );
    await tester.tap(find.text('Simpan Catatan'));
    await tester.pumpAndSettle();

    final providerContext = tester.element(find.byType(ProfileScreen));
    final provider = AppProvider.of(providerContext);
    final id = provider.notes.single.id;
    await provider.deleteNote(id);
    await tester.pumpAndSettle();
    expect(AppProvider.of(providerContext).notes, isEmpty);
    expect(await const SecureStorageService().getContent(id), isNull);
  });
}
