import 'dart:convert';

import 'package:demo_app/data/secure_storage.dart';
import 'package:demo_app/models/user_model.dart';
import 'package:demo_app/states/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class AuthenticationViewModel extends Notifier<UserState> {
  @override
  UserState build() {
    getToken();
    return UserState();
  }

  SecureStorage storage = SecureStorage();

  Future<void> getToken() async {
    final hasToken = await storage.getTokenBool();
    if (hasToken) {
      state = state.copyWith(authenticated: true);
    }
  }

  //  Future<void> login(String email, String password, bool rememberMe) async {
  Future<void> login(String email, String password) async {
    final String endpoint = 'student/auth/login';
    final url = Uri.parse('${dotenv.env['base_url']}$endpoint');
    final response = await http.post(
      url,
      headers: {'content-type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      // storage.writeToken(token) // need to add code to remember credentials in the login screen
      final data = jsonDecode(response.body);
      await storage.writeToken(data['token']);
      final userData = UserModel(
        email: email,
        password: password,
        token: data['token'],
      );
      state = state.copyWith(tempUser: userData, authenticated: true);
    } else {
      debugPrint("Login failed with status code: ${response.statusCode}");
    }
  }

  void logout() {
    storage.deleteToken();
    state = state.copyWith(authenticated: false);
  }
}

final authenticationViewModelProvider =
    NotifierProvider<AuthenticationViewModel, UserState>(() {
      return AuthenticationViewModel();
    });
