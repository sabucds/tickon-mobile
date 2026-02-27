import '../entities/user.dart';
import '../failures/auth_failure.dart';

export '../failures/auth_failure.dart';

/// Throws an [AuthFailure] subclass on error.
abstract class AuthRepository {
  Future<User> signIn({required String email, required String password});

  Future<User> signUp({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String password,
  });
}
