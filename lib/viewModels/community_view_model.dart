import 'dart:convert';

import 'package:demo_app/data/secure_storage.dart';
import 'package:demo_app/states/community_state.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class CommunityViewModel extends Notifier<CommunityState> {
  bool isLoading = false;
  @override
  build() {
    getCommunityList();
    state = state.copyWith(loadingState: true);
    return CommunityState();
  }

  SecureStorage storage = SecureStorage();

  Future<void> getCommunityList() async {
    final String endpoint =
        '/student/community/getEnrolledCommunityList?str&page=1&limit=10';
    final url = Uri.parse('${dotenv.env['base_url']}${endpoint}');
    final token = await storage.readToken();
    print('token: ${token}');
    final response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'Authorization': 'Bearer ${token}',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      state = state.copyWith(communityList: data, loadingState: false);
      print('data fetched: $data}');
    } else {
      print(
        'failed to load community list. Status code: ${response.statusCode}',
      );
      state = state.copyWith(
        err: 'Error loading community list',
        loadingState: false,
      );
    }
  }
}

final CommunityViewModelProvider =
    NotifierProvider<CommunityViewModel, CommunityState>(() {
      return CommunityViewModel();
    });
