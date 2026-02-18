sealed class AuthFailure {
  const AuthFailure();
}

class InvalidCredentials extends AuthFailure {
  const InvalidCredentials();
}

class ServerFailure extends AuthFailure {
  const ServerFailure(this.message);

  final String message;
}
