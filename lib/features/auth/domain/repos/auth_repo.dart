import 'package:social/features/auth/domain/entities/auth_user.dart';

abstract class AuthRepo {
  Future<AuthUser> signup(String name, String email, String password);
  Future<AuthUser> login(String email, String password);
  Future<void> logout();
  Future<AuthUser?> getCurrUser();
}
