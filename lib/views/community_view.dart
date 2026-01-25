import 'package:demo_app/viewModels/community_view_model.dart';
import 'package:demo_app/views/feed_view.dart';
import 'package:demo_app/views/widgets/cardWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommunityView extends ConsumerStatefulWidget {
  const CommunityView({super.key});

  @override
  ConsumerState<CommunityView> createState() => _CommunityViewState();
}

class _CommunityViewState extends ConsumerState<CommunityView> {
  final scrollController = ScrollController();
  bool maxCommunites = false;

  @override
  void initState() {
    ref.read(CommunityViewModelProvider.notifier).getCommunityList();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
              scrollController.offset &&
          maxCommunites == false) {
        ref.read(CommunityViewModelProvider.notifier).getCommunityList();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final communityState = ref.watch(CommunityViewModelProvider);
    maxCommunites = communityState.maxFetched;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Communities',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
        ),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(7, 81, 91, 1.0),
      ),
      body: Center(
        child: communityState.isLoading
            ? CircularProgressIndicator()
            : communityState.error != null
            ? Text('Error Occured!!!')
            : communityState.communities == null
            ? Text('No communities available')
            : GridView.builder(
                padding: EdgeInsets.all(10),
                controller: scrollController,
                // physics: NeverScrollableScrollPhysics(),
                // shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                  crossAxisCount: 2,
                  childAspectRatio: 0.9,
                ),
                itemCount: communityState.communities?.length,
                itemBuilder: (BuildContext context, int index) {
                  final community = communityState.communities![index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return FeedView(
                              communityId: community.id,
                              communityName: community.title,
                            );
                          },
                        ),
                      );
                    },
                    child: CardWidget(
                      title: community.title,
                      image: community.thumbnail,
                      count: community.totalMembers,
                      total_feeds: community.totalFeeds,
                    ),
                  );
                },
              ),
      ),
    );
  }
}
