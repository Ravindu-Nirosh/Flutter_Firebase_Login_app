import '../auth/auth_provider.dart';
import '../auth/auth_user.dart';

class AuthServices implements AuthProvider {
  final AuthProvider authProvider;
  AuthServices(this.authProvider);

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) =>
      authProvider.createUser(
        email: email,
        password: password,
      );

  @override
  // TODO: implement currentUser
  AuthUser? get currentUser => authProvider.currentUser;

  @override
  Future<AuthUser> login({required String email, required String password}) =>
      authProvider.login(
        email: email,
        password: password,
      );

  @override
  Future<void> logout() => authProvider.logout();

  @override
  Future<void> sendEmailVerification() => authProvider.sendEmailVerification();
}
