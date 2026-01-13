import 'package:demo_app/models/channel_model.dart';
import 'package:demo_app/models/feed_model.dart';
import 'package:demo_app/viewModels/channel_view_model.dart';
import 'package:demo_app/viewModels/feed_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedView extends ConsumerStatefulWidget {
  final int communityId;
  const FeedView({super.key, required this.communityId});

  @override
  ConsumerState<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends ConsumerState<FeedView> {
  ChannelModel? selectedChannel;

  @override
  void initState() {
    ref
        .read(ChannelViewModelProvider.notifier)
        .getChannelList(widget.communityId);

    super.initState();
  }

  void fetchFeeds() async {
    ref
        .read(feedViewModelProvider.notifier)
        .fetchFeed(widget.communityId, selectedChannel!.id);
  }

  @override
  Widget build(BuildContext context) {
    final feeds = ref.watch(feedViewModelProvider).feeds;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
          ),
        ],
        title: Text("Feed"),
        centerTitle: true,
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(Icons.menu),
            );
          },
        ),
      ),
      body: feeds == null || feeds!.isEmpty
          ? Center(child: CircularProgressIndicator(value: 500))
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
                            image: NetworkImage(feed.files.first.fileLocation),
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
                            itemBuilder: (BuildContext context, int fileIndex) {
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
            ),

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

class CommunityDrawer extends ConsumerWidget {
  const CommunityDrawer({
    super.key,
    required this.onTapDrawerTile,
    required this.commId,
    required this.selectedChannel,
  });

  final void Function(ChannelModel) onTapDrawerTile;
  final int commId;
  final ChannelModel? selectedChannel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final channelState = ref.watch(ChannelViewModelProvider);
    if ((channelState.channels ?? []).isNotEmpty || selectedChannel == null) {
      ref
          .read(feedViewModelProvider.notifier)
          .fetchFeed(commId, channelState.channels!.first.id);
    }

    return Drawer(
      child: channelState.isLoading
          ? CircularProgressIndicator()
          : ListView.builder(
              itemCount: channelState.channels?.length,
              itemBuilder: (BuildContext context, int index) {
                final channel = channelState.channels![index];
                return GestureDetector(
                  onTap: () async {
                    Navigator.of(context).pop();
                    onTapDrawerTile.call(channel);
                  },
                  child: Container(
                    // decoration: BoxDecoration(
                    //   color: channel.id == selectedChannel!.id
                    //       ? Colors.grey
                    //       : Colors.transparent,
                    // ),
                    child: ListTile(title: Text(channel.name)),
                  ),
                );
              },
            ),
    );
  }
}
