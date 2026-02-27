import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tickon/features/auth/domain/entities/user.dart';
import 'package:tickon/features/auth/domain/repositories/auth_repository.dart';
import 'package:tickon/features/auth/domain/usecases/sign_up.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepository;
  late SignUp useCase;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = SignUp(mockRepository);
  });

  const testUser = User(
    id: 'test-id',
    email: 'john@example.com',
    name: 'John Doe',
  );

  const testParams = SignUpParams(
    firstName: 'John',
    lastName: 'Doe',
    username: 'johndoe',
    email: 'john@example.com',
    password: 'Password123!',
  );

  test('should call repository.signUp with correct parameters', () async {
    // Arrange
    when(() => mockRepository.signUp(
          firstName: any(named: 'firstName'),
          lastName: any(named: 'lastName'),
          username: any(named: 'username'),
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenAnswer((_) async => testUser);

    // Act
    await useCase(testParams);

    // Assert
    verify(() => mockRepository.signUp(
          firstName: 'John',
          lastName: 'Doe',
          username: 'johndoe',
          email: 'john@example.com',
          password: 'Password123!',
        )).called(1);
  });

  test('should return User on successful registration', () async {
    // Arrange
    when(() => mockRepository.signUp(
          firstName: any(named: 'firstName'),
          lastName: any(named: 'lastName'),
          username: any(named: 'username'),
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenAnswer((_) async => testUser);

    // Act
    final result = await useCase(testParams);

    // Assert
    expect(result, testUser);
  });

  test('should throw AuthFailure when repository throws', () async {
    // Arrange
    when(() => mockRepository.signUp(
          firstName: any(named: 'firstName'),
          lastName: any(named: 'lastName'),
          username: any(named: 'username'),
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenThrow(const DuplicateEmail());

    // Act & Assert
    expect(
      () => useCase(testParams),
      throwsA(isA<DuplicateEmail>()),
    );
  });
}
