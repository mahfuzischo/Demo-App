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
  @override
  void initState() {
    ref.read(CommunityViewModelProvider.notifier).getCommunityList();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
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
    return Scaffold(
      appBar: AppBar(title: Text('My Communities')),
      body: Center(
        child: communityState.isLoading
            ? CircularProgressIndicator(value: 10)
            : communityState.error != null
            ? Text('Error Occured!!!')
            : communityState.communities == null
            ? Text('No communities available')
            : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      GridView.builder(
                        controller: scrollController,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
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
                                    return FeedView(community_id: community.id);
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
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
