import 'package:demo_app/models/channel_model.dart';
import 'package:demo_app/models/feed_model.dart';
import 'package:demo_app/viewModels/channel_view_model.dart';
import 'package:demo_app/viewModels/feed_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedView extends ConsumerStatefulWidget {
  final int community_id;
  const FeedView({super.key, required this.community_id});

  @override
  ConsumerState<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends ConsumerState<FeedView> {
  ChannelModel? selectedChannel;
  List<ChannelModel> channelsList = [];
  List<FeedModel> feedList = [];
  @override
  void initState() {
    fetchData();

    super.initState();
  }

  void fetchData() async {
    setState(() async {
      channelsList = await ref
          .read(ChannelViewModelProvider.notifier)
          .getChannelList(widget.community_id);
    });
  }

  void fetchFeeds() async {
    setState(() async {
      feedList = await ref
          .read(feedViewModelProvider.notifier)
          .fetchFeed(widget.community_id, selectedChannel!.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final channelState = ref.watch(ChannelViewModelProvider);
    selectedChannel = channelState.channels?.first;

    final data = ref.watch(feedViewModelProvider).feeds;

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
      body: data == null
          ? Center(child: CircularProgressIndicator(value: 1000))
          : Padding(
              padding: const EdgeInsets.all(10),
              child: ListView.builder(
                itemCount: data!.length,
                itemBuilder: (BuildContext context, int index) {
                  FeedModel feed = data[index];
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

      drawer: Drawer(
        child: channelState.isLoading
            ? CircularProgressIndicator()
            : ListView.builder(
                itemCount: channelState.channels?.length,
                itemBuilder: (BuildContext context, int index) {
                  final channel = channelState.channels![index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedChannel = channel;
                        fetchFeeds();
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: channel.id == selectedChannel!.id
                            ? Colors.grey
                            : Colors.transparent,
                      ),
                      child: ListTile(title: Text(channel.name)),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
