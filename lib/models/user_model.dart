class UserModel {
  final String email;
  final String password;
  final String token;

  UserModel({required this.email, required this.password, required this.token});

  factory UserModel.fromJSON(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      password: json['password'],
      token: json['token'],
    );
  }
}
