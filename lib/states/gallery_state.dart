import 'package:demo_app/models/gallery_model.dart';

class GalleryState {
  final List<GalleryItemModel>? galleryItems;
  final bool isLoading;
  final String? error;

  GalleryState({this.galleryItems, this.isLoading = false, this.error});

  GalleryState copyWith({
    List<GalleryItemModel>? itemList,
    bool? loadingState,
    String? err,
  }) {
    return GalleryState(
      galleryItems: itemList ?? galleryItems,
      isLoading: loadingState ?? isLoading,
      error: err ?? error,
    );
  }
}
