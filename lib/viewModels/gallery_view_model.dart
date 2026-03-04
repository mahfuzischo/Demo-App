import 'dart:convert';

import 'package:demo_app/data/secure_storage.dart';
import 'package:demo_app/models/gallery_model.dart';
import 'package:demo_app/states/gallery_state.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class GalleryViewModel extends Notifier<GalleryState> {
  @override
  build() {
    return GalleryState();
  }

  SecureStorage storage = SecureStorage();

  Future<void> fetchGallery(String galleryFileType) async {
    final String endpoint =
        "/teacher/gallery/getGalleryItemsFromLibary?type=${galleryFileType}&page&pageSize&parent_id=0&str";

    final url = Uri.parse("${dotenv.env["base_url"]}$endpoint");
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
      final tData = jsonDecode(response.body) as Map<String, dynamic>;
      final galleryData = GalleryModel.fromJSON(tData);

      state = state.copyWith(itemList: galleryData.data, loadingState: false);
    } else {
      state = state.copyWith(
        err: "Error loading gallery items",
        loadingState: false,
      );
      debugPrint(
        "Failed to load gallery data with status code: ${response.statusCode}",
      );
    }
  }

  Future<void> uploadToGallery(String filePath, String fileType) async {
    final endpoint = '/teacher/gallery/uploadFile';
    final url = Uri.parse('${dotenv.env['base_url']}$endpoint');
    final token = await storage.readToken();
    state = state.copyWith(loadingState: true);
    final request = http.MultipartRequest('POST', url);

    request.headers['Authorization'] = 'Bearer $token';

    request.files.add(await http.MultipartFile.fromPath(fileType, filePath));

    final streamedResponse = await request.send();

    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      state = state.copyWith(loadingState: false, err: null);

      debugPrint('File uploaded successfully.');
    } else {
      state = state.copyWith(
        loadingState: false,
        err: 'Failed to create post. Status code: ${response.statusCode}',
      );
      debugPrint('Failed to create post. Status code: ${response.statusCode}');
    }
  }

  void clearGallery() {
    state = state.copyWith(itemList: null);
  }
}

final galleryViewModelProvider =
    NotifierProvider<GalleryViewModel, GalleryState>(() {
      return GalleryViewModel();
    });
