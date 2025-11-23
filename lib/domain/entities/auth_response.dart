import 'package:equatable/equatable.dart';
import 'user.dart';

class AuthResponse extends Equatable {
  final String accessToken;
  final String? refreshToken;
  final User user;
  final String? message;

  const AuthResponse({
    required this.accessToken,
    this.refreshToken,
    required this.user,
    this.message,
  });

  @override
  List<Object?> get props => [accessToken, refreshToken, user, message];
}
