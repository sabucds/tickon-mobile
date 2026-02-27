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

class DuplicateEmail extends AuthFailure {
  const DuplicateEmail();
}

class DuplicateUsername extends AuthFailure {
  const DuplicateUsername();
}

class ValidationFailure extends AuthFailure {
  const ValidationFailure(this.errors);

  final Map<String, String> errors;
}
