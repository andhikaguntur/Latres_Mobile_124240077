// =============================================================================
// [KETENTUAN a.i] Data Akun Statis untuk Keperluan Login
// Input username: "124240077" & password: "123"
// =============================================================================

class Account {
  String username;
  String password;
  String displayName;

  Account({
    required this.username,
    required this.password,
    required this.displayName,
  });
}

// Instance akun default yang digunakan untuk validasi pada LoginPage
Account account = Account(
  username: "124240077",
  password: "123",
  displayName: "124240077",
);
