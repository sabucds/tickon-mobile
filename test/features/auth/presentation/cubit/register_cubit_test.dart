import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tickon/features/auth/domain/entities/user.dart';
import 'package:tickon/features/auth/domain/repositories/auth_repository.dart';
import 'package:tickon/features/auth/domain/usecases/sign_in.dart';
import 'package:tickon/features/auth/domain/usecases/sign_up.dart';
import 'package:tickon/features/auth/presentation/cubit/register_cubit.dart';
import 'package:tickon/features/auth/presentation/cubit/register_state.dart';

class MockSignUp extends Mock implements SignUp {}

class MockSignIn extends Mock implements SignIn {}

const _tUser = User(
  id: '1',
  email: 'john@example.com',
  name: 'John Doe',
);

void main() {
  late MockSignUp mockSignUp;
  late MockSignIn mockSignIn;
  late RegisterCubit cubit;

  setUp(() {
    mockSignUp = MockSignUp();
    mockSignIn = MockSignIn();
    registerFallbackValue(const SignUpParams(
      firstName: '',
      lastName: '',
      username: '',
      email: '',
      password: '',
    ));
    registerFallbackValue(const SignInParams(email: '', password: ''));
  });

  tearDown(() {
    cubit.close();
  });

  blocTest<RegisterCubit, RegisterState>(
    'emits [loading, success] when registration and login succeed',
    build: () {
      when(() => mockSignUp(any())).thenAnswer((_) async => _tUser);
      when(() => mockSignIn(any())).thenAnswer((_) async => _tUser);
      cubit = RegisterCubit(
        signUpUseCase: mockSignUp,
        signInUseCase: mockSignIn,
      );
      return cubit;
    },
    act: (RegisterCubit cubit) => cubit.register(
      firstName: 'John',
      lastName: 'Doe',
      username: 'johndoe',
      email: 'john@example.com',
      password: 'Password123!',
    ),
    expect: () => [
      const RegisterLoading(),
      RegisterSuccess(_tUser),
    ],
  );

  blocTest<RegisterCubit, RegisterState>(
    'emits [loading, failure] when registration fails with DuplicateEmail',
    build: () {
      when(() => mockSignUp(any())).thenThrow(const DuplicateEmail());
      cubit = RegisterCubit(
        signUpUseCase: mockSignUp,
        signInUseCase: mockSignIn,
      );
      return cubit;
    },
    act: (RegisterCubit cubit) => cubit.register(
      firstName: 'John',
      lastName: 'Doe',
      username: 'johndoe',
      email: 'john@example.com',
      password: 'Password123!',
    ),
    expect: () => [
      const RegisterLoading(),
      const RegisterFailure(DuplicateEmail()),
    ],
  );

  blocTest<RegisterCubit, RegisterState>(
    'emits [loading, failure] when registration fails with DuplicateUsername',
    build: () {
      when(() => mockSignUp(any())).thenThrow(const DuplicateUsername());
      cubit = RegisterCubit(
        signUpUseCase: mockSignUp,
        signInUseCase: mockSignIn,
      );
      return cubit;
    },
    act: (RegisterCubit cubit) => cubit.register(
      firstName: 'John',
      lastName: 'Doe',
      username: 'johndoe',
      email: 'john@example.com',
      password: 'Password123!',
    ),
    expect: () => [
      const RegisterLoading(),
      const RegisterFailure(DuplicateUsername()),
    ],
  );

  blocTest<RegisterCubit, RegisterState>(
    'emits [loading, failure] when registration fails with ValidationFailure',
    build: () {
      when(() => mockSignUp(any())).thenThrow(
        const ValidationFailure({'email': 'Invalid email'}),
      );
      cubit = RegisterCubit(
        signUpUseCase: mockSignUp,
        signInUseCase: mockSignIn,
      );
      return cubit;
    },
    act: (RegisterCubit cubit) => cubit.register(
      firstName: 'John',
      lastName: 'Doe',
      username: 'johndoe',
      email: 'invalid',
      password: 'Password123!',
    ),
    expect: () => [
      const RegisterLoading(),
      const RegisterFailure(ValidationFailure({'email': 'Invalid email'})),
    ],
  );

  blocTest<RegisterCubit, RegisterState>(
    'emits [loading, failure] when auto-login fails after successful registration',
    build: () {
      when(() => mockSignUp(any())).thenAnswer((_) async => _tUser);
      when(() => mockSignIn(any())).thenThrow(const InvalidCredentials());
      cubit = RegisterCubit(
        signUpUseCase: mockSignUp,
        signInUseCase: mockSignIn,
      );
      return cubit;
    },
    act: (RegisterCubit cubit) => cubit.register(
      firstName: 'John',
      lastName: 'Doe',
      username: 'johndoe',
      email: 'john@example.com',
      password: 'Password123!',
    ),
    expect: () => [
      const RegisterLoading(),
      const RegisterFailure(InvalidCredentials()),
    ],
  );
}
