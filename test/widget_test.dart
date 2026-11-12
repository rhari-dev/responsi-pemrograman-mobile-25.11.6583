import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsi_profil_mahasiswa/main.dart';
import 'package:responsi_profil_mahasiswa/models/student.dart';

/// Menguji model mahasiswa dan interaksi halaman profil.
void main() {
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
}
