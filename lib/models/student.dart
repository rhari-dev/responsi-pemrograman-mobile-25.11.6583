/// Data profil mahasiswa yang ditampilkan di aplikasi.
class Student {
  /// Membuat data mahasiswa yang sudah diperiksa dan dirapikan.
  factory Student({
    required String name,
    required String nim,
    required String programStudi,
    required String email,
  }) {
    final cleanName = _clean(name);
    final cleanNim = _clean(nim);
    final cleanProgramStudi = _clean(programStudi);
    final cleanEmail = _clean(email);

    for (final error in [
      validateName(cleanName),
      validateNim(cleanNim),
      validateProgramStudi(cleanProgramStudi),
      validateEmail(cleanEmail),
    ]) {
      if (error != null) throw FormatException(error);
    }

    return Student._(cleanName, cleanNim, cleanProgramStudi, cleanEmail);
  }

  const Student._(this.name, this.nim, this.programStudi, this.email);

  /// Nama mahasiswa.
  final String name;

  /// Nomor induk mahasiswa.
  final String nim;

  /// Program studi mahasiswa.
  final String programStudi;

  /// Alamat email mahasiswa.
  final String email;

  static final RegExp _unsafeCharacters = RegExp(r'[<>\x00-\x1F\x7F]');

  static String _clean(String value) =>
      value.trim().replaceAll(RegExp(r' {2,}'), ' ');

  /// Memeriksa nama; mengembalikan pesan jika input tidak valid.
  static String? validateName(String? value) {
    final name = _clean(value ?? '');
    if (name.length < 2 || name.length > 80) {
      return 'Nama harus 2–80 karakter.';
    }
    if (_unsafeCharacters.hasMatch(name)) {
      return 'Nama mengandung karakter tidak diperbolehkan.';
    }
    return null;
  }

  /// Memeriksa NIM; mengembalikan pesan jika input tidak valid.
  static String? validateNim(String? value) {
    final nim = _clean(value ?? '');
    if (!RegExp(r'^[a-zA-Z0-9.-]{3,30}$').hasMatch(nim)) {
      return 'NIM harus 3–30 karakter (huruf, angka, titik, atau tanda hubung).';
    }
    return null;
  }

  /// Memeriksa program studi; mengembalikan pesan jika input tidak valid.
  static String? validateProgramStudi(String? value) {
    final programStudi = _clean(value ?? '');
    if (programStudi.length < 2 || programStudi.length > 100) {
      return 'Program studi harus 2–100 karakter.';
    }
    if (_unsafeCharacters.hasMatch(programStudi)) {
      return 'Program studi mengandung karakter tidak diperbolehkan.';
    }
    return null;
  }

  /// Memeriksa email; mengembalikan pesan jika input tidak valid.
  static String? validateEmail(String? value) {
    final email = _clean(value ?? '');
    if (email.length > 254 ||
        !RegExp(r'^[^\s@<>]+@[^\s@<>]+\.[^\s@<>]+$').hasMatch(email) ||
        _unsafeCharacters.hasMatch(email)) {
      return 'Masukkan alamat email yang valid.';
    }
    return null;
  }
}
