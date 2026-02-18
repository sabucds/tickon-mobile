import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

/// Stub implementation — returns a hardcoded user.
/// Replace with real API calls when the backend is ready.
class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<User> signIn({required String email, required String password}) async {
    await Future.delayed(const Duration(seconds: 1)); // simulate network
    return User(id: '1', email: email, name: email.split('@').first);
  }
}
