# Plan: Auth — login view (full feature slice)

## Layers created
- `lib/core/usecase/usecase.dart` — abstract UseCase base + NoParams
- `lib/features/auth/domain/entities/user.dart`
- `lib/features/auth/domain/failures/auth_failure.dart` — sealed: InvalidCredentials, ServerFailure
- `lib/features/auth/domain/repositories/auth_repository.dart` — abstract interface
- `lib/features/auth/domain/usecases/sign_in.dart`
- `lib/features/auth/data/repositories/auth_repository_impl.dart` — stub (hardcoded success)
- `lib/features/auth/presentation/cubit/login_state.dart`
- `lib/features/auth/presentation/cubit/login_cubit.dart`
- `lib/features/auth/presentation/widgets/login_form.dart`
- `lib/features/auth/presentation/pages/login_page.dart`

## Decisions
- No Either: use case throws AuthFailure, cubit catches it
- No get_it yet: LoginPage manually wires AuthRepositoryImpl → SignIn → LoginCubit
- AuthRepositoryImpl is a stub (1s delay, hardcoded User)
- Validation is client-side in LoginForm (non-empty check only)

## Packages added
- flutter_bloc ^9.0.0, equatable ^2.0.6
- dev: bloc_test ^10.0.0, mocktail ^1.0.4

## Next steps
- Add go_router for navigation (post-login route)
- Add get_it DI to remove manual wiring from LoginPage
- Replace stub with real API datasource when backend is ready
