import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/failures/auth_failure.dart';
import '../../domain/usecases/sign_in.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._signIn) : super(const LoginInitial());

  final SignIn _signIn;

  Future<void> signIn({required String email, required String password}) async {
    emit(const LoginLoading());
    try {
      final user = await _signIn(SignInParams(email: email, password: password));
      emit(LoginSuccess(user));
    } on AuthFailure catch (failure) {
      emit(LoginFailure(failure));
    }
  }
}
