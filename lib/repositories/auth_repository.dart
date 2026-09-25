class EmailTakenException implements Exception {}

class InvalidCredentialsException implements Exception {}

abstract class AuthRepository {
  Future<void> login(String email, String password);
  Future<void> signUp(String email, String password);
}

/// Replace with your real API / Supabase implementation.
class FakeAuthRepository implements AuthRepository {
  @override
  Future<void> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    if (password != 'Password1') throw InvalidCredentialsException();
  }

  @override
  Future<void> signUp(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    if (email == 'taken@mail.com') throw EmailTakenException();
  }
}
