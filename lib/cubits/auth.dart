import 'package:bloc/bloc.dart';

import '../models/signup.dart';
import '../services/auth_token.dart';
import '../services/signin_service.dart';
import '../services/signup_service.dart';

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

  AuthCubit() : super(_loggedOut) {
    refresh();
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
  Future<String?> login(String username, String password) async {
    final response = await _signInService.login(username, password);
    refresh();
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
