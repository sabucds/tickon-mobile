import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/sign_in.dart';
import '../../domain/usecases/sign_up.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit({
    required this.signUpUseCase,
    required this.signInUseCase,
  }) : super(const RegisterInitial());

  final SignUp signUpUseCase;
  final SignIn signInUseCase;

  Future<void> register({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String password,
  }) async {
    emit(const RegisterLoading());
    try {
      // Register the user
      await signUpUseCase(SignUpParams(
        firstName: firstName,
        lastName: lastName,
        username: username,
        email: email,
        password: password,
      ));

      // Auto-login after successful registration
      final user = await signInUseCase(SignInParams(
        email: email,
        password: password,
      ));

      emit(RegisterSuccess(user));
    } on AuthFailure catch (failure) {
      emit(RegisterFailure(failure));
    }
  }
}
