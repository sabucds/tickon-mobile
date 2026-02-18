import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';
import '../../domain/failures/auth_failure.dart';

sealed class LoginState extends Equatable {
  const LoginState();
}

class LoginInitial extends LoginState {
  const LoginInitial();

  @override
  List<Object?> get props => [];
}

class LoginLoading extends LoginState {
  const LoginLoading();

  @override
  List<Object?> get props => [];
}

class LoginSuccess extends LoginState {
  const LoginSuccess(this.user);

  final User user;

  @override
  List<Object?> get props => [user];
}

class LoginFailure extends LoginState {
  const LoginFailure(this.failure);

  final AuthFailure failure;

  @override
  List<Object?> get props => [failure];
}
