import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/features/auth/domain/entities/auth_user.dart';
import 'package:social/features/auth/domain/repos/auth_repo.dart';
import 'package:social/features/auth/presentation/cubits/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo authRepo;
  AuthUser? _currUser;
  AuthUser? get currUser => _currUser;

  AuthCubit({required this.authRepo}) : super(AuthLoading()) {
    checkAuth();
  }

  Future<void> checkAuth() async {
    final currUser = await authRepo.getCurrUser();
    if (currUser == null) {
      emit(Unauthenticated());
      return;
    }
    _currUser = currUser;
    emit(Authenticated(user: currUser));
  }

  Future<void> signup(String name, String email, String password) async {
    try {
      emit(AuthLoading());
      final user = await authRepo.signup(name, email, password);
      _currUser = user;
      emit(Authenticated(user: user));
    } catch (e) {
      emit(AuthError(message: e.toString()));
      emit(Unauthenticated());
    }
  }

  Future<void> login(String email, String password) async {
    try {
      emit(AuthLoading());
      final user = await authRepo.login(email, password);
      _currUser = user;
      emit(Authenticated(user: user));
    } catch (e) {
      emit(AuthError(message: e.toString()));
      emit(Unauthenticated());
    }
  }

  void logout() {
    authRepo.logout();
    _currUser = null;
    emit(Unauthenticated());
  }
}
