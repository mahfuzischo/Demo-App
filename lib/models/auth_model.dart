class AuthModel {
  final String email;
  final String password;
  final String token;

  AuthModel({required this.email, required this.password, required this.token});

  factory AuthModel.fromJSON(Map<String, dynamic> json) {
    return AuthModel(
      email: json['email'],
      password: json['password'],
      token: json['token'],
    );
  }
}
