abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

// ✅ Token valide trouvé au démarrage ou login réussi
class AuthAuthenticated extends AuthState {}

// ✅ Pas de token ou déconnexion
class AuthUnauthenticated extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthFailure extends AuthState {
  final String error;
  AuthFailure(this.error);
}