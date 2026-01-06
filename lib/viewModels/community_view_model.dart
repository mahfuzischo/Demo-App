import 'dart:convert';

import 'package:demo_app/data/secure_storage.dart';
import 'package:demo_app/models/community_model.dart';
import 'package:demo_app/states/community_state.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class CommunityViewModel extends Notifier<CommunityState> {
  // bool isLoading = false;
  @override
  build() {
    return CommunityState();
  }

  SecureStorage storage = SecureStorage();

  Future<void> getCommunityList() async {
    print("inside getCommunity()");
    final String endpoint =
        '/student/community/getEnrolledCommunityList?str&page=1&limit=10';
    final url = Uri.parse('${dotenv.env['base_url']}${endpoint}');
    final token = await storage.readToken();
    state = state.copyWith(loadingState: true);
    final response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'Authorization': 'Bearer ${token}',
      },
    );

    if (response.statusCode == 200) {
      final tempData = jsonDecode(response.body)['data'] as List;
      final data = tempData
          .map((json) => CommunityModel.fromJSON(json))
          .toList();
      print('data fetched: ${data.length}}');
      state = state.copyWith(communityList: data, loadingState: false);
    } else {
      print(
        'failed to load community list. Status code: ${response.statusCode}',
      );
      state = state.copyWith(
        err: 'Error loading community list',
        loadingState: false,
      );
    }
    print(
      'failed to load community list. Status code: ${response.statusCode}, this was printed outside if-else funtion',
    );
  }
}

final CommunityViewModelProvider =
    NotifierProvider<CommunityViewModel, CommunityState>(() {
      return CommunityViewModel();
    });
