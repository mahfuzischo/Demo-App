import 'package:demo_app/models/channel_model.dart';
import 'package:demo_app/models/feed_model.dart';
import 'package:demo_app/states/channel_state.dart';
import 'package:demo_app/viewModels/channel_view_model.dart';
import 'package:demo_app/viewModels/feed_view_model.dart';
import 'package:demo_app/views/post_view.dart';
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
        .read(channelViewModelProvider.notifier)
        .getChannelList(widget.communityId);
  }

  void fetchFeeds() async {
    ref
        .read(feedViewModelProvider.notifier)
        .fetchFeed(widget.communityId, selectedChannel!.id);
  }

  @override
  Widget build(BuildContext context) {
    if (selectedChannel == null) {
      ref.listen<ChannelState>(channelViewModelProvider, (
        prevState,
        currentState,
      ) {
        if (prevState?.channels == null &&
            currentState.channels != null &&
            currentState.channels!.isNotEmpty) {
          selectedChannel = currentState.channels!.first;
          ref
              .read(feedViewModelProvider.notifier)
              .fetchFeed(widget.communityId, selectedChannel!.id);
          debugPrint("fetched data for new channel");
        }
      });
    }

    final feeds = ref.watch(feedViewModelProvider).feeds;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(7, 81, 91, 1.0),
        actions: [
          IconButton(
            onPressed: () {
              // ref.invalidate(feedViewModelProvider);
              ref.invalidate(channelViewModelProvider);
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
      body: feeds == null || ref.watch(feedViewModelProvider).isLoading
          ? Center(child: CircularProgressIndicator())
          : (feeds.isEmpty
                ? Center(child: Text("No Posts Yet"))
                : SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 15,
                      ),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return PostView(
                                      communityId: widget.communityId,
                                      spaceId: selectedChannel!.id,
                                    );
                                  },
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              // height: 80,
                              height: 70,
                              width: double.infinity,

                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment: .spaceBetween,

                                  children: [
                                    Image.asset("assets/blank_profile.png"),
                                    Text(
                                      'What\'s on your mind...',
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                    Container(
                                      height: 35,
                                      width: 60,
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(7, 81, 91, 1.0),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Post',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Expanded(
                            child: ListView.builder(
                              itemCount: feeds.length,
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
                                        Expanded(
                                          child: GridView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2,
                                                  childAspectRatio: 1,
                                                  mainAxisSpacing: 5,
                                                  crossAxisSpacing: 5,
                                                ),
                                            itemCount: feed.files.length,
                                            itemBuilder:
                                                (
                                                  BuildContext context,
                                                  int fileIndex,
                                                ) {
                                                  return Image(
                                                    image: NetworkImage(
                                                      feed
                                                          .files[fileIndex]
                                                          .fileLocation,
                                                    ),
                                                    fit: BoxFit.cover,
                                                  );
                                                },
                                          ),
                                        ),
                                    ],
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),

      drawer: CommunityDrawer(
        onTapDrawerTile: (channel) {
          debugPrint('channel id: ${channel.id}');
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
