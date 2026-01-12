import 'dart:convert';

import 'package:demo_app/data/secure_storage.dart';
import 'package:demo_app/models/channel_model.dart';
import 'package:demo_app/states/channel_state.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class ChannelViewModel extends Notifier<ChannelState> {
  @override
  build() {
    return ChannelState();
  }

  SecureStorage storage = SecureStorage();

  Future<List<ChannelModel>> getChannelList(int communityId) async {
    final String endpoint = '/public/communities/$communityId/spaces';
    final url = Uri.parse('${dotenv.env['base_url']}$endpoint');
    final token = await storage.readToken();
    state = state.copyWith(loadingState: true);
    final response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'Authorization': 'bearer ${token!}',
      },
    );
    if (response.statusCode == 200) {
      print('Status code: 200');
      final tData = jsonDecode(response.body) as List;
      final data = tData.map((m) => ChannelModel.fromJSON(m)).toList();
      print('data: $data');
      state = state.copyWith(channelList: data, loadingState: false);
      return data;
    } else {
      state = state.copyWith(
        err: 'Error loading channel list',
        loadingState: false,
      );
      return [];
    }
  }
}

final ChannelViewModelProvider =
    NotifierProvider<ChannelViewModel, ChannelState>(() {
      return ChannelViewModel();
    });
