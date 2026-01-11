import 'package:demo_app/viewModels/channel_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedView extends ConsumerStatefulWidget {
  final int community_id;
  const FeedView({super.key, required this.community_id});

  @override
  ConsumerState<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends ConsumerState<FeedView> {
  @override
  void initState() {
    ref
        .read(ChannelViewModelProvider.notifier)
        .getChannelList(widget.community_id);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final channelState = ref.watch(ChannelViewModelProvider);
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
      body: Center(child: Text("Helllo from community feed")),
      drawer: Drawer(
        child: channelState.isLoading
            ? CircularProgressIndicator()
            : ListView.builder(
                itemCount: channelState.channels?.length,
                itemBuilder: (BuildContext context, int index) {
                  final channel = channelState.channels![index];
                  return ListTile(title: Text('${channel.name}'));
                },
              ),
      ),
    );
  }
}
