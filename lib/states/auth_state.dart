import 'package:demo_app/models/auth_model.dart';
import 'package:demo_app/models/user_model.dart';

class AuthState {
  final bool isAuthenticated;
  AuthModel? auth;

  AuthState({this.auth, this.isAuthenticated = false});

  AuthState copyWith({AuthModel? authData, bool? authenticated}) {
    return AuthState(
      auth: authData ?? auth,
      isAuthenticated: authenticated ?? isAuthenticated,
    );
  }
}
