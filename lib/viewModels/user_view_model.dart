import 'dart:convert';

import 'package:demo_app/data/secure_storage.dart';
import 'package:demo_app/models/user_model.dart';
import 'package:demo_app/states/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class UserViewModel extends Notifier<UserState> {
  @override
  UserState build() {
    // TODO: implement build
    return UserState();
  }

  SecureStorage storage = SecureStorage();

  Future<void> getUser() async {
    final String endpoint = '/student/auth/getUser';
    final url = Uri.parse('${dotenv.env['base_url']}$endpoint');
    final token = await storage.readToken();
    final response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'Authorization': 'bearer ${token}',
      },
    );

    if (response.statusCode == 200) {
      // storage.writeToken(token) // need to add code to remember credentials in the login screen
      final tData = jsonDecode(response.body);
      final data = UserModel.fromJson(tData);
      debugPrint("data: $data");
      state = state.copyWith(tempUser: data, authenticated: true);
    } else {
      debugPrint("Login failed with status code: ${response.statusCode}");
    }
  }
}

final userViewModelProvider = NotifierProvider<UserViewModel, UserState>(() {
  return UserViewModel();
});
