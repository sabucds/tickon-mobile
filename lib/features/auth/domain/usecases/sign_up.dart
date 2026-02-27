import 'package:equatable/equatable.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignUp implements UseCase<User, SignUpParams> {
  final AuthRepository repository;

  const SignUp(this.repository);

  @override
  Future<User> call(SignUpParams params) async {
    return await repository.signUp(
      firstName: params.firstName,
      lastName: params.lastName,
      username: params.username,
      email: params.email,
      password: params.password,
    );
  }
}

class SignUpParams extends Equatable {
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String password;

  const SignUpParams({
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [firstName, lastName, username, email, password];
}
