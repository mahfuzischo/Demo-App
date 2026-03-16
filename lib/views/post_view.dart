import 'package:demo_app/models/gallery_model.dart';
import 'package:demo_app/models/post_model.dart';
import 'package:demo_app/viewModels/feed_view_model.dart';
import 'package:demo_app/viewModels/post_view_model.dart';
import 'package:demo_app/viewModels/user_view_model.dart';
import 'package:demo_app/views/widgets/gallery_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostView extends ConsumerStatefulWidget {
  final int communityId;
  final int spaceId;
  const PostView({super.key, required this.communityId, required this.spaceId});

  @override
  ConsumerState<PostView> createState() => _PostViewState();
}

class _PostViewState extends ConsumerState<PostView> {
  TextEditingController feedTxtController = TextEditingController();
  List<PostFile> selectedFiles = [];
  final List<Color> colors = [
    Colors.white,
    Colors.pink,
    Colors.green,
    Colors.orange,
    Colors.red,
    Colors.blue,
  ];

  List<Map<String, dynamic>> postOptions = [
    {"icon": Icon(Icons.photo), "label": "Photo Gallery"},
    {"icon": Icon(Icons.videocam), "label": "Video Gallery"},
    {"icon": Icon(Icons.camera_alt), "label": "Capture Photo"},
    {"icon": Icon(Icons.videocam_rounded), "label": "Capture Video"},
    {"icon": Icon(Icons.attach_file), "label": "File"},
    {"icon": Icon(Icons.poll), "label": "Poll"},
  ];

  @override
  Widget build(BuildContext context) {
    final postViewData = ref.watch(PostViewModelProvider);
    final userData = ref.watch(userViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.black,

        elevation: 1,
        leadingWidth: 80,
        leading: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            "Cancel",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ),
        title: const Text(
          'Create Post',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () async {
              if (feedTxtController.value.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Please write something")),
                );
                return;
              } else {
                PostModel dummyPost = PostModel(
                  communityId: widget.communityId,
                  spaceId: widget.spaceId,
                  feedTxt: feedTxtController.text,
                  uploadType: "photos",
                  isBackground: 0,
                  files: selectedFiles,
                );

                await ref
                    .read(PostViewModelProvider.notifier)
                    .createPost(dummyPost);
                await ref
                    .read(feedViewModelProvider.notifier)
                    .fetchFeed(widget.communityId, widget.spaceId);
                Navigator.pop(context);
              }
            },
            child: postViewData.isLoading
                ? const CircularProgressIndicator.adaptive()
                : const Text(
                    'Create Post',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                      fontSize: 16,
                    ),
                  ),
          ),
        ],
      ),

      body: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: Container(
          width: double.infinity,
          color: const Color.fromRGBO(243, 243, 243, 1),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Column(
              mainAxisAlignment: .start,
              children: [
                Row(
                  mainAxisAlignment: .start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(userData.user!.profilePic),
                    ),
                    SizedBox(width: 8),
                    Text(
                      userData.user!.fullName,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300, width: 2),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),

                  child: TextField(
                    maxLines: 5,
                    controller: feedTxtController,
                    decoration: InputDecoration(
                      hintText: 'What\'s on your mind?',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: 35,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: colors.length,
                    itemBuilder: (BuildContext context, int index) {
                      selectedFiles.isNotEmpty
                          ? print("file link: ${selectedFiles.first.fileLoc}")
                          : print("no files ");
                      return Padding(
                        padding: EdgeInsetsGeometry.all(5),
                        child: GestureDetector(
                          child: Container(
                            width: 25,

                            constraints: BoxConstraints(maxHeight: 25),
                            decoration: BoxDecoration(
                              color: colors[index],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 50),
                selectedFiles.isNotEmpty
                    ? Expanded(
                        child: selectedFiles.length == 1
                            ? Container(
                                width: 50,
                                height: 50,
                                child: Image(
                                  image: NetworkImage(
                                    selectedFiles.first.fileLoc,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                itemCount: selectedFiles.length,
                                scrollDirection: Axis.horizontal,

                                itemBuilder: (BuildContext context, int index) {
                                  print("file link: ${selectedFiles[index]}");
                                  return Container(
                                    width: 50,
                                    height: 50,
                                    child: Image(
                                      image: NetworkImage(
                                        selectedFiles[index].fileLoc,
                                      ),
                                    ),
                                  );
                                },
                              ),
                      )
                    : SizedBox(),
                SizedBox(height: 30),
                Expanded(
                  child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 5,
                          childAspectRatio: 0.9,
                          mainAxisExtent: 50,
                        ),
                    itemCount: postOptions.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () async {
                          final result =
                              await showModalBottomSheet<
                                List<GalleryItemModel>
                              >(
                                context: context,
                                builder: (BuildContext context) {
                                  // Example: Displaying an icon based on enum status
                                  switch (index) {
                                    case 0:
                                      return GalleryWidget(
                                        galleryFileType: "image",
                                      );
                                    case 1:
                                      return GalleryWidget(
                                        galleryFileType: "video",
                                      );
                                    case 2:
                                      return GalleryWidget(
                                        galleryFileType: "image",
                                      );
                                    case 3:
                                      return GalleryWidget(
                                        galleryFileType: "image",
                                      );
                                    case 4:
                                      return GalleryWidget(
                                        galleryFileType: "image",
                                      );
                                    default:
                                      return GalleryWidget(
                                        galleryFileType: 'image',
                                      );
                                  }
                                },
                              );

                          debugPrint(
                            "${postOptions[index]["label"]} button pressed ",
                          );

                          if (result != null) {
                            debugPrint("selected item count: ${result.length}");

                            final convertFiles = result.map((item) {
                              return PostFile(
                                extname: item.originalName.split('.').last,
                                fileLoc: item.isImage
                                    ? item.meta.fileLink!
                                    : item.isVideo
                                    ? item.meta.fileLink!
                                    : 'https://ezycourse.b-cdn.net/2903/cmmk8hxsp3lmkh0qtadke6piz.png',
                                originalName: item.meta.originalName,
                                size: item.meta.size ?? 0,
                                type: item.fileType,
                              );
                            }).toList();

                            setState(() {
                              selectedFiles = convertFiles;
                            });
                          } else {
                            debugPrint("no items selected");
                          }
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(color: Colors.white),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: postOptions[index]["icon"],
                              ),
                              Text(postOptions[index]["label"]),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
