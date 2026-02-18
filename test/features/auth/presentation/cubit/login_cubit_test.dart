import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tickon/features/auth/domain/entities/user.dart';
import 'package:tickon/features/auth/domain/failures/auth_failure.dart';
import 'package:tickon/features/auth/domain/usecases/sign_in.dart';
import 'package:tickon/features/auth/presentation/cubit/login_cubit.dart';
import 'package:tickon/features/auth/presentation/cubit/login_state.dart';

class MockSignIn extends Mock implements SignIn {}

const _tUser = User(id: '1', email: 'user@test.com', name: 'Test User');
const _tEmail = 'user@test.com';
const _tPassword = 'secret';

void main() {
  late MockSignIn signIn;

  setUp(() {
    signIn = MockSignIn();
    registerFallbackValue(const SignInParams(email: '', password: ''));
  });

  blocTest<LoginCubit, LoginState>(
    'emits [Loading, Success] when sign in succeeds',
    build: () {
      when(() => signIn(any())).thenAnswer((_) async => _tUser);
      return LoginCubit(signIn);
    },
    act: (cubit) => cubit.signIn(email: _tEmail, password: _tPassword),
    expect: () => [
      const LoginLoading(),
      LoginSuccess(_tUser),
    ],
  );

  blocTest<LoginCubit, LoginState>(
    'emits [Loading, Failure] on InvalidCredentials',
    build: () {
      when(() => signIn(any())).thenThrow(const InvalidCredentials());
      return LoginCubit(signIn);
    },
    act: (cubit) => cubit.signIn(email: _tEmail, password: _tPassword),
    expect: () => [
      const LoginLoading(),
      const LoginFailure(InvalidCredentials()),
    ],
  );

  blocTest<LoginCubit, LoginState>(
    'emits [Loading, Failure] on ServerFailure',
    build: () {
      when(() => signIn(any())).thenThrow(const ServerFailure('error'));
      return LoginCubit(signIn);
    },
    act: (cubit) => cubit.signIn(email: _tEmail, password: _tPassword),
    expect: () => [
      const LoginLoading(),
      const LoginFailure(ServerFailure('error')),
    ],
  );
}
