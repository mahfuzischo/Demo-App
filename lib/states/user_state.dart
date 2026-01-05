import 'package:demo_app/models/user_model.dart';

class UserState {
  final bool isAuthenticated;
  UserModel? user;

  UserState({this.user, this.isAuthenticated = false});

  UserState copyWith({UserModel? tempUser, bool? authenticated}) {
    return UserState(
      user: tempUser ?? user,
      isAuthenticated: authenticated ?? isAuthenticated,
    );
  }
}
