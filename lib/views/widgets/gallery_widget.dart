import 'package:demo_app/viewModels/gallery_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GalleryWidget extends ConsumerStatefulWidget {
  final String galleryFileType;
  const GalleryWidget({super.key, required this.galleryFileType});

  @override
  ConsumerState<GalleryWidget> createState() => _GalleryWidgetState();
}

class _GalleryWidgetState extends ConsumerState<GalleryWidget> {
  @override
  void initState() {
    Future.microtask(() {
      ref
          .read(galleryViewModelProvider.notifier)
          .fetchGallery(widget.galleryFileType);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final galleryState = ref.watch(galleryViewModelProvider);

    return SizedBox(
      height: MediaQuery.of(context).size.height * .85,
      width: double.infinity,
      child: Container(
        padding: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(color: Color.fromRGBO(243, 243, 243, 1)),

        child: galleryState.isLoading
            ? Center(child: CircularProgressIndicator())
            : galleryState.error != null
            ? Center(child: Text("Error loading gallery"))
            : galleryState.galleryItems != null &&
                  galleryState.galleryItems!.isNotEmpty
            ? GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: galleryState.galleryItems!.length,
                itemBuilder: (BuildContext context, int index) {
                  return Text("Need to build gallery UI");
                },
              )
            : Center(child: Text("No ${widget.galleryFileType}s available")),
      ),
    );
  }
}
