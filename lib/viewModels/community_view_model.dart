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
    final int page = state.page + 1;
    final String endpoint =
        '/student/community/getEnrolledCommunityList?str&page=$page&limit=10';
    final url = Uri.parse('${dotenv.env['base_url']}$endpoint');
    final token = await storage.readToken();
    state = state.copyWith(loadingState: true);
    final response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final int totalPage = jsonDecode(response.body)['meta']['total'];
      final tempData = jsonDecode(response.body)['data'] as List;
      final data = tempData
          .map((json) => CommunityModel.fromJSON(json))
          .toList();
      print('data fetched: ${data.length}}');
      state = state.copyWith(
        communityList: [...state.communities ?? [], ...data],
        currentPage: page,
        loadingState: false,
      );
      print('total page: ${totalPage}');
      if (state.communities!.length == totalPage) {
        print('inside if condition');
        state = state.copyWith(hasMaxed: true);
        print(state.maxFetched);
      }
      print("total communities: ${state.communities!.length}");
      print("has maxed: ${state.maxFetched}");
    } else {
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
