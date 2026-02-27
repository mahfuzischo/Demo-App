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
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Color.fromRGBO(243, 243, 243, 1),
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),

        child: galleryState.isLoading
            ? Center(child: CircularProgressIndicator())
            : galleryState.error != null
            ? Center(child: Text("Error loading gallery"))
            : galleryState.galleryItems != null &&
                  galleryState.galleryItems!.isNotEmpty
            ? Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Media Gallery",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Spacer(),
                      Icon(
                        widget.galleryFileType == "image"
                            ? Icons.image
                            : Icons.video_collection,
                      ),
                    ],
                  ),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(7, 81, 91, 1.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                      onPressed: () {},
                      child: Row(
                        spacing: 5,
                        mainAxisAlignment: .center,
                        children: [
                          Icon(Icons.file_upload_outlined, color: Colors.white),
                          Text(
                            "Upload ${widget.galleryFileType}",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 5,
                            crossAxisSpacing: 5,
                          ),
                      itemCount: galleryState.galleryItems!.length,
                      itemBuilder: (BuildContext context, int index) {
                        final item = galleryState.galleryItems![index];
                        return GestureDetector(
                          onTap: () {},
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey),
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            child: Column(
                              children: [
                                Image(
                                  image: NetworkImage(
                                    "https://www.freepik.com/free-vector/folder-with-warning_357319599.htm#fromView=search&page=1&position=5&uuid=dc91d282-34f7-4aed-9a03-3d9b18925572&query=no+file",
                                  ),
                                ),
                                Container(
                                  height: 40,
                                  color: Color.fromRGBO(7, 81, 91, .8),
                                  child: Text(item.originalName),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              )
            : Center(child: Text("No ${widget.galleryFileType}s available")),
      ),
    );
  }
}
