import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart'; // also exports AuthFailure subtypes
import '../datasources/auth_local_data_source.dart';
import '../models/login_response_model.dart';
import '../models/register_request_model.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({ApiClient? client, AuthLocalDataSource? localDataSource})
      : _client = client ?? ApiClient(),
        _local = localDataSource ?? AuthLocalDataSourceImpl();

  final ApiClient _client;
  final AuthLocalDataSource _local;

  @override
  Future<User> signIn({required String email, required String password}) async {
    try {
      final deviceId = await _local.getDeviceId();

      final response = await _client.post<Map<String, dynamic>>(
        '/api/identity/v1/auth/login',
        data: {
          'usernameOrEmail': email,
          'password': password,
          'deviceId': deviceId,
        },
      );

      final model = LoginResponseModel.fromJson(response.data!);
      await _local.saveTokens(
        accessToken: model.accessToken,
        refreshToken: model.refreshToken,
      );

      final meResponse = await _client.get<Map<String, dynamic>>(
        '/api/identity/v1/users/me',
        options: Options(headers: {'Authorization': 'Bearer ${model.accessToken}'}),
      );

      return UserModel.fromJson(meResponse.data!).toEntity();
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) throw const InvalidCredentials();
      throw ServerFailure(e.message ?? 'Request failed');
    }
  }

  @override
  Future<User> signUp({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final request = RegisterRequestModel(
        firstName: firstName,
        lastName: lastName,
        username: username,
        email: email,
        password: password,
      );

      final response = await _client.post<Map<String, dynamic>>(
        '/api/identity/v1/users',
        data: request.toJson(),
      );

      return UserModel.fromJson(response.data!).toEntity();
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        // Parse error message to determine duplicate field
        final message = e.response?.data['message'] as String? ?? '';
        if (message.toLowerCase().contains('email')) {
          throw const DuplicateEmail();
        } else if (message.toLowerCase().contains('username')) {
          throw const DuplicateUsername();
        }
        throw ServerFailure(message);
      } else if (e.response?.statusCode == 400) {
        final errors = e.response?.data['errors'] as Map<String, dynamic>? ?? {};
        throw ValidationFailure(errors.map((key, value) => MapEntry(key, value.toString())));
      }
      throw ServerFailure(e.message ?? 'Request failed');
    }
  }
}
