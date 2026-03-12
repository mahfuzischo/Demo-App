import 'dart:io';

import 'package:demo_app/models/gallery_model.dart';
import 'package:demo_app/viewModels/gallery_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class GalleryWidget extends ConsumerStatefulWidget {
  final String galleryFileType;
  const GalleryWidget({super.key, required this.galleryFileType});

  @override
  ConsumerState<GalleryWidget> createState() => _GalleryWidgetState();
}

class _GalleryWidgetState extends ConsumerState<GalleryWidget> {
  List<GalleryItemModel> selectedFilesData = [];
  File? selectedImage;
  File? selectedVideo;
  String noImageURL =
      "https://ezycourse.b-cdn.net/2903/cmmk8hxsp3lmkh0qtadke6piz.png";

  @override
  void initState() {
    Future.microtask(() {
      ref
          .read(galleryViewModelProvider.notifier)
          .fetchGallery(widget.galleryFileType);
    });

    super.initState();
  }

  Future pickImage() async {
    final imagePicked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (imagePicked == null) return;
    setState(() {
      selectedImage = File(imagePicked.path);
    });
  }

  void toggleSelected(GalleryItemModel item) {
    setState(() {
      if (selectedFilesData.any((file) => file.id == item.id)) {
        selectedFilesData.removeWhere((file) => file.id == item.id);
      } else {
        selectedFilesData.add(item);
      }
    });
  }

  bool isSelected(GalleryItemModel item) {
    return selectedFilesData.any((file) => file.id == item.id);
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
                      onPressed: () async {
                        await pickImage();
                        if (selectedImage != null) {
                          ref
                              .read(galleryViewModelProvider.notifier)
                              .uploadToGallery(selectedImage!.path, 'file');
                        }
                      },
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
                        bool selected = isSelected(item);
                        print("Image link: ${item.meta.fileLink}");
                        print("Thumbnail link: ${item.meta.thumbnailLink}");

                        return GestureDetector(
                          onTap: () {
                            print("data ext: ${item.meta.extname}");
                            toggleSelected(item);
                          },
                          child: Container(
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: selected ? Colors.green : Colors.grey,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 7,
                                  child: Image(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                      item.isImage
                                          ? (item.meta.fileLink?.isNotEmpty ==
                                                    true
                                                ? item.meta.fileLink!
                                                : noImageURL)
                                          : item.isVideo
                                          ? (item
                                                            .meta
                                                            .thumbnailLink
                                                            ?.isNotEmpty ==
                                                        true &&
                                                    item.meta.thumbnailLink !=
                                                        null
                                                ? item.meta.thumbnailLink!
                                                : noImageURL)
                                          : noImageURL,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                                    width: double.infinity,
                                    height: 40,
                                    color: Color.fromRGBO(7, 81, 91, .8),
                                    child: Text(
                                      item.originalName.length > 19
                                          ? "${item.originalName.substring(0, 19)}..."
                                          : item.originalName,
                                      style: TextStyle(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(232, 245, 74, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text(
                        'Submit',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color.fromRGBO(38, 105, 113, 1),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Center(child: Text("No ${widget.galleryFileType}s available")),
      ),
    );
  }
}
