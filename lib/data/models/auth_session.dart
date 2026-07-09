import 'package:tranzgoo/data/models/app_user.dart';

class AuthSession {
  final String token;
  final AppUser user;

  const AuthSession({
    required this.token,
    required this.user,
  });

  factory AuthSession.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'];

    if (userJson is! Map<String, dynamic>) {
      throw const FormatException('The server did not return user details.');
    }

    return AuthSession(
      token: json['token']?.toString() ?? '',
      user: AppUser.fromJson(userJson),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'user': user.toJson(),
    };
  }
}
