import 'package:demo_app/models/post_model.dart';
import 'package:demo_app/viewModels/post_view_model.dart';
import 'package:flutter/cupertino.dart';
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
          style: TextStyle(fontWeight: FontWeight.w400),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              PostModel dummyPost = PostModel(
                communityId: widget.communityId,
                spaceId: widget.spaceId, // replace with real space ID
                feedTxt: "Ezy Post test app",
                uploadType: "photos",
                isBackground: 0,
                files: [
                  PostFile(
                    extname: "jpg",
                    fileLoc:
                        "https://ezycourse.b-cdn.net/273/cmh8oghw215be9d8z11lq6ks0.jpg",
                    originalName:
                        "image_picker_0E563D0A-E6E3-41EE-8E25-B2A5E3A1F60C.jpg",
                    size: 0,
                    type: "image",
                  ),
                ],
              );

              ref.read(PostViewModelProvider.notifier).createPost(dummyPost);
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

      body: Center(child: Text("Post view ")),
    );
  }
}
