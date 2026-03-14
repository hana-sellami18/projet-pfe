import '../data/models/user_model.dart';

abstract class AuthEvent {}

class AppStarted extends AuthEvent {}

class RegisterSubmitted extends AuthEvent {
  final UserModel user;
  RegisterSubmitted(this.user);
}

class LoginSubmitted extends AuthEvent {
  final String email;
  final String password;
  LoginSubmitted(this.email, this.password);
}

// ✅ Déconnexion
class LogoutRequested extends AuthEvent {}