import 'dart:convert';

import 'package:demo_app/data/secure_storage.dart';
import 'package:demo_app/models/comment_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class CommentRepo {
  final SecureStorage _storage = SecureStorage();
  Future<List<CommentModel>> getComments(int feedId) async {
    final String endpoint = '/student/comment/getComment/$feedId';
    final url = Uri.parse('${dotenv.env['base_url']}$endpoint');
    final token = await _storage.readToken();

    final response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'Authorization': 'bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final tempData = jsonDecode(response.body) as List;
      final data = tempData.map((m) => CommentModel.fromJSON(m)).toList();
      return data;
    } else {
      throw Exception(
        'Failed to load comments with status code: ${response.statusCode}',
      );
    }
  }
}
