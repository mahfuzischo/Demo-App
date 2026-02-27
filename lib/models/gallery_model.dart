import 'dart:convert';

// ============== 1. MAIN GALLERY MODEL ==============
class GalleryModel {
  final MetaModel meta; // Pagination info
  final List<GalleryItemModel> data; // The items
  final List<Map<String, dynamic>>
  items; // Index array (can simplify if not needed)

  GalleryModel({required this.meta, required this.data, required this.items});

  factory GalleryModel.fromJSON(Map<String, dynamic> json) {
    return GalleryModel(
      meta: MetaModel.fromJSON(json['meta'] ?? {}),
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => GalleryItemModel.fromJSON(e))
              .toList() ??
          [],
      items:
          (json['items'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [],
    );
  }

  // Helper getters
  // int get totalCount => meta.total;
  // int get currentPage => meta.currentPage;
  // bool get hasMore => meta.hasNextPage;
  // List<GalleryItemModel> get videos => data.where((i) => i.isVideo).toList();
  // List<GalleryItemModel> get images => data.where((i) => i.isImage).toList();
}

// ============== 2. PAGINATION META ==============
class MetaModel {
  final int total;
  final int perPage;
  final int currentPage;
  final int lastPage;
  final int firstPage;
  final String? firstPageUrl;
  final String? lastPageUrl;
  final String? nextPageUrl;
  final String? previousPageUrl;

  MetaModel({
    required this.total,
    required this.perPage,
    required this.currentPage,
    required this.lastPage,
    required this.firstPage,
    this.firstPageUrl,
    this.lastPageUrl,
    this.nextPageUrl,
    this.previousPageUrl,
  });

  factory MetaModel.fromJSON(Map<String, dynamic> json) {
    return MetaModel(
      total: json['total'] ?? 0,
      perPage: json['per_page'] ?? 10,
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      firstPage: json['first_page'] ?? 1,
      firstPageUrl: json['first_page_url'],
      lastPageUrl: json['last_page_url'],
      nextPageUrl: json['next_page_url'],
      previousPageUrl: json['previous_page_url'],
    );
  }

  bool get hasNextPage => nextPageUrl != null;
  bool get hasPreviousPage => previousPageUrl != null;
}

// ============== 3. GALLERY ITEM ==============
class GalleryItemModel {
  final int id;
  final String? videoId;
  final String fileName;
  final String fileType; // "video" or "image"
  final ItemMetaModel meta;
  final DateTime createdAt;
  final String originalName;
  final int creatorId;
  final String uploadBy;
  final bool marked;

  GalleryItemModel({
    required this.id,
    this.videoId,
    required this.fileName,
    required this.fileType,
    required this.meta,
    required this.createdAt,
    required this.originalName,
    required this.creatorId,
    required this.uploadBy,
    required this.marked,
  });

  factory GalleryItemModel.fromJSON(Map<String, dynamic> json) {
    // Parse the meta string into a Map
    final metaString = json['meta'] as String?;
    final metaMap = metaString != null
        ? jsonDecode(metaString) as Map<String, dynamic>
        : <String, dynamic>{};

    return GalleryItemModel(
      id: json['id'] ?? 0,
      videoId: json['video_id'],
      fileName: json['file_name'] ?? '',
      fileType: json['file_type'] ?? '',
      meta: ItemMetaModel.fromJSON(metaMap),
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      originalName: json['original_name'] ?? '',
      creatorId: json['creator_id'] ?? 0,
      uploadBy: json['upload_by'] ?? '',
      marked: json['marked'] ?? false,
    );
  }

  bool get isVideo => fileType == 'video';
  bool get isImage => fileType == 'image';
}

// ============== 4. ITEM META (Video/Image Details) ==============
class ItemMetaModel {
  // Common
  final String fileName;
  final String originalName;
  final String fileType;

  // Video only
  final String? playLink;
  final String? hlsLink;
  final String? thumbnailLink;
  final String? webpLink;
  final String? videoID;
  final int? length;
  final int? size;
  final String? extname;
  final bool? isNew;

  // Image only
  final String? fileLink;

  ItemMetaModel({
    required this.fileName,
    required this.originalName,
    required this.fileType,
    this.playLink,
    this.hlsLink,
    this.thumbnailLink,
    this.webpLink,
    this.videoID,
    this.length,
    this.size,
    this.extname,
    this.isNew,
    this.fileLink,
  });

  factory ItemMetaModel.fromJSON(Map<String, dynamic> json) {
    return ItemMetaModel(
      fileName: json['file_name'] ?? '',
      originalName: json['original_name'] ?? '',
      fileType: json['file_type'] ?? '',
      // Video
      playLink: json['play_link'],
      hlsLink: json['hls_link'],
      thumbnailLink: json['thumbnail_link'],
      webpLink: json['webp_link'],
      videoID: json['videoID'],
      length: json['length'],
      size: json['size'],
      extname: json['extname'],
      isNew: json['isNew'],
      // Image
      fileLink: json['file_link'],
    );
  }

  // bool get isVideo => fileType == 'video';
  // bool get isImage => fileType == 'image';

  // String? get url => isVideo ? (thumbnailLink ?? playLink) : fileLink;
  // String? get videoUrl => hlsLink ?? playLink;
}
