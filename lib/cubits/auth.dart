import 'package:bloc/bloc.dart';

import '../models/users/signup.dart';
import '../services/auth/auth_token.dart';
import '../services/auth/signin_service.dart';
import '../services/auth/signup_service.dart';

class AuthState {
  final bool authenticated;
  final String? username;
  final String? type;

  const AuthState({
    this.authenticated = false,
    this.username,
    this.type,
  });
}

class AuthCubit extends Cubit<AuthState> {
  /// Initial/default state
  static const _loggedOut = AuthState();

  final _signInService = SignInService();
  final _signUpService = SignupService();

  AuthCubit({
    AuthState? initialState,
    bool refreshNow = true,
  }) : super(initialState ?? _loggedOut) {
    if (refreshNow) refresh();
  }

  /// Reload authentication state
  Future<void> refresh() async {
    if (!AuthTokenUtils.isLoggedIn()) return emit(_loggedOut);

    final Signup info;
    try {
      info = await SignupService().getUserSelfInfo();
    } on Exception {
      AuthTokenUtils.setAuthToken(null);
      return emit(_loggedOut);
    }

    emit(AuthState(
      authenticated: AuthTokenUtils.isLoggedIn(),
      username: info.username,
      type: info.type,
    ));
  }

  /// Try to log in with credentials.
  ///
  /// If the request fails, the response is passed through.
  Future<String?> login(
    String username,
    String password, {
    bool awaitRefresh = false,
  }) async {
    final response = await _signInService.login(username, password);
    if (awaitRefresh) {
      await refresh();
    } else {
      refresh();
    }
    return response;
  }

  /// End the current session.
  ///
  /// If the request fails, the response is passed through.
  Future<String?> logout() async {
    final response = await SignInService().logout();
    refresh();
    return response;
  }

  /// Create a new user profile with the given credentials.
  ///
  /// If the request fails, the response is passed through.
  Future<String?> register(String username, String password) async {
    final response = await _signUpService.createProfile(username, password);
    refresh();
    return response;
  }
}
