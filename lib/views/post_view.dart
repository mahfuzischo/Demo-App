import 'package:demo_app/models/post_model.dart';
import 'package:demo_app/viewModels/feed_view_model.dart';
import 'package:demo_app/viewModels/post_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
              PostModel dummyPost = PostModel(
                communityId: widget.communityId,
                spaceId: widget.spaceId,
                feedTxt: feedTxtController.text,
                uploadType: "photos",
                isBackground: 0,
                files: [
                  PostFile(
                    extname: "jpg",
                    fileLoc:
                        "https://ezycourse.b-cdn.net/2903/cmldokxpn1mkteq8z04ez2j9p.jpg",
                    originalName:
                        "image_picker_0E563D0A-E6E3-41EE-8E25-B2A5E3A1F60C.jpg",
                    size: 0,
                    type: "image",
                  ),
                ],
              );

              await ref
                  .read(PostViewModelProvider.notifier)
                  .createPost(dummyPost);
              await ref
                  .read(feedViewModelProvider.notifier)
                  .fetchFeed(widget.communityId, widget.spaceId);
              Navigator.pop(context);
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

      body: Container(
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
                    backgroundImage: AssetImage('assets/blank_profile.png'),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'John Snow',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
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
              Expanded(
                child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                    childAspectRatio: 0.9,
                    mainAxisExtent: 50,
                  ),
                  itemCount: postOptions.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        debugPrint(
                          "${postOptions[index]["label"]} button pressed ",
                        );
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
    );
  }
}
