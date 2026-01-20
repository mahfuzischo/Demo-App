import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final secureStorage = const FlutterSecureStorage();

  static const token_key = 'auth_token';

  Future<void> writeToken(String token) async {
    await secureStorage.write(key: token_key, value: token);
  }

  Future<void> saveCredentials(String email, String password) async {
    await secureStorage.write(key: token_key, value: email);
    await secureStorage.write(key: token_key, value: password);
  }

  Future<String?> readToken() async {
    String? data = await secureStorage.read(key: token_key);
    return data;
  }

  Future<bool> getTokenBool() async {
    final token = await readToken();
    return token != null ? true : false;
  }

  Future<void> deleteToken() async {
    await secureStorage.delete(key: token_key);
  }
}
