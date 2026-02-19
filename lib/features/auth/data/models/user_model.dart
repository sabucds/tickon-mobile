import '../../domain/entities/user.dart';

class UserModel {
  const UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String,
        firstName: json['firstName'] as String,
        lastName: json['lastName'] as String,
        username: json['username'] as String,
        email: json['email'] as String,
      );

  final String id;
  final String firstName;
  final String lastName;
  final String username;
  final String email;

  User toEntity() => User(
        id: id,
        email: email,
        name: '$firstName $lastName'.trim(),
      );
}
