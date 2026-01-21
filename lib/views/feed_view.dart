import 'package:demo_app/models/channel_model.dart';
import 'package:demo_app/models/feed_model.dart';
import 'package:demo_app/states/channel_state.dart';
import 'package:demo_app/viewModels/channel_view_model.dart';
import 'package:demo_app/viewModels/feed_view_model.dart';
import 'package:demo_app/views/widgets/community_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedView extends ConsumerStatefulWidget {
  final int communityId;
  final String communityName;
  const FeedView({
    super.key,
    required this.communityId,
    required this.communityName,
  });

  @override
  ConsumerState<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends ConsumerState<FeedView> {
  ChannelModel? selectedChannel;

  @override
  void initState() {
    super.initState();
    ref
        .read(ChannelViewModelProvider.notifier)
        .getChannelList(widget.communityId);

    print('channels fetched');

    // ref.listen<ChannelState>(ChannelViewModelProvider, (
    //   prevState,
    //   currentState,
    // ) {
    //   print("inside listener");
    //   if (prevState?.channels == null &&
    //       currentState.channels != null &&
    //       currentState.channels!.isNotEmpty &&
    //       selectedChannel == null) {
    //     selectedChannel = currentState.channels!.first;
    //     print("selected channel id: ${selectedChannel!.id}");
    //     ref
    //         .read(feedViewModelProvider.notifier)
    //         .fetchFeed(widget.communityId, selectedChannel!.id);
    //   }
    // });
  }

  void fetchFeeds() async {
    ref
        .read(feedViewModelProvider.notifier)
        .fetchFeed(widget.communityId, selectedChannel!.id);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<ChannelState>(ChannelViewModelProvider, (
      prevState,
      currentState,
    ) {
      if (prevState?.channels == null &&
          currentState.channels != null &&
          currentState.channels!.isNotEmpty &&
          selectedChannel == null) {
        selectedChannel = currentState.channels!.first;
        ref
            .read(feedViewModelProvider.notifier)
            .fetchFeed(widget.communityId, selectedChannel!.id);
      }
    });

    final feeds = ref.watch(feedViewModelProvider).feeds;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(7, 81, 91, 1.0),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.close, color: Colors.white),
          ),
        ],
        title: Text(
          widget.communityName,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(Icons.menu, color: Colors.white),
            );
          },
        ),
      ),
      body: feeds == null
          ? Center(child: CircularProgressIndicator())
          : (feeds.isEmpty
                ? Center(child: Text("No Posts Yet"))
                : Padding(
                    padding: const EdgeInsets.all(10),
                    child: ListView.builder(
                      itemCount: feeds!.length,
                      itemBuilder: (BuildContext context, int index) {
                        FeedModel feed = feeds[index];

                        return Column(
                          crossAxisAlignment: .start,

                          children: [
                            ListTile(
                              title: Text(feed.name),
                              subtitle: Text(feed.createdAt.toString()),
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(feed.pic),
                              ),
                              trailing: const Icon(Icons.more_vert),
                            ),
                            Text(feed.feedTxt),
                            if (feed.files.isNotEmpty) ...[
                              if (feed.files.length == 1)
                                Image(
                                  image: NetworkImage(
                                    feed.files.first.fileLocation,
                                  ),
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                )
                              else
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: 1,
                                        mainAxisSpacing: 5,
                                        crossAxisSpacing: 5,
                                      ),
                                  itemCount: feed.files.length,
                                  itemBuilder:
                                      (BuildContext context, int fileIndex) {
                                        return Image(
                                          image: NetworkImage(
                                            feed.files[fileIndex].fileLocation,
                                          ),
                                          fit: BoxFit.cover,
                                        );
                                      },
                                ),
                            ],
                          ],
                        );
                      },
                    ),
                  )),

      drawer: CommunityDrawer(
        onTapDrawerTile: (channel) {
          print('channel id: ${channel.id}');
          setState(() {
            selectedChannel = channel;
          });

          fetchFeeds();
        },
        commId: widget.communityId,
        selectedChannel: selectedChannel,
      ),
    );
  }
}
