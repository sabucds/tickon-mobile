import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tickon/features/auth/domain/entities/user.dart';
import 'package:tickon/features/auth/domain/repositories/auth_repository.dart';
import 'package:tickon/features/auth/domain/usecases/sign_in.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

const _tUser = User(id: '1', email: 'user@test.com', name: 'Test User');
const _tParams = SignInParams(email: 'user@test.com', password: 'secret');

void main() {
  late SignIn useCase;
  late MockAuthRepository repository;

  setUp(() {
    repository = MockAuthRepository();
    useCase = SignIn(repository);
  });

  test('returns User when repository succeeds', () async {
    when(() => repository.signIn(email: any(named: 'email'), password: any(named: 'password')))
        .thenAnswer((_) async => _tUser);

    final result = await useCase(_tParams);

    expect(result, _tUser);
    verify(() => repository.signIn(email: _tParams.email, password: _tParams.password)).called(1);
  });

  test('throws InvalidCredentials when repository throws it', () async {
    when(() => repository.signIn(email: any(named: 'email'), password: any(named: 'password')))
        .thenThrow(const InvalidCredentials());

    expect(() => useCase(_tParams), throwsA(isA<InvalidCredentials>()));
  });

  test('throws ServerFailure when repository throws it', () async {
    when(() => repository.signIn(email: any(named: 'email'), password: any(named: 'password')))
        .thenThrow(const ServerFailure('Internal error'));

    expect(() => useCase(_tParams), throwsA(isA<ServerFailure>()));
  });
}
