import 'package:demo_app/models/channel_model.dart';
import 'package:demo_app/viewModels/channel_view_model.dart';
import 'package:demo_app/viewModels/feed_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedViewV2 extends ConsumerStatefulWidget {
  const FeedViewV2({
    super.key,
    required this.communityId,
    required this.communityName,
  });

  final int communityId;
  final String communityName;

  @override
  ConsumerState<FeedViewV2> createState() => _FeedViewV2State();
}

class _FeedViewV2State extends ConsumerState<FeedViewV2> {
  ChannelModel? selectedChannel;

  @override
  void initState() {
    ref
        .read(channelViewModelProvider.notifier)
        .getChannelList(widget.communityId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final feedViewModel = ref.watch(feedViewModelProvider);

    /// Initial fetch when channels are loaded and no channel is selected
    if (selectedChannel == null) {
      final channelState = ref.watch(channelViewModelProvider);
      if (channelState.channels != null && channelState.channels!.isNotEmpty) {
        selectedChannel = channelState.channels!.first;
        ref
            .read(feedViewModelProvider.notifier)
            .fetchFeed(widget.communityId, selectedChannel!.id);
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.communityName)),
      endDrawer: CommunityDrawer(
        communityId: widget.communityId,
        communityName: widget.communityName,
        selectedChannel: selectedChannel,
        onChannelSelected: (channel) {
          setState(() {
            selectedChannel = channel;
          });
        },
      ),
      body: feedViewModel.isLoading || feedViewModel.feeds == null
          ? Center(child: CircularProgressIndicator.adaptive())
          : ListView.builder(
              itemBuilder: (context, index) {
                final feed = feedViewModel.feeds![index];
                return Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(feed.pic),
                      ),
                      title: Text(feed.name),
                      subtitle: Text(feed.feedTxt),
                    ),
                    Divider(),
                  ],
                );
              },
              itemCount: feedViewModel.feeds?.length ?? 0,
            ),
    );
  }
}

class CommunityDrawer extends ConsumerWidget {
  const CommunityDrawer({
    super.key,
    required this.communityId,
    required this.communityName,

    required this.selectedChannel,
    required this.onChannelSelected,
  });

  final int communityId;
  final String communityName;
  final ChannelModel? selectedChannel;
  final Function(ChannelModel) onChannelSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final channelViewModel = ref.watch(channelViewModelProvider);

    return Drawer(
      child: channelViewModel.isLoading
          ? Center(child: CircularProgressIndicator.adaptive())
          : Column(
              children: [
                DrawerHeader(child: Text(communityName)),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(
                          selectedChannel == channelViewModel.channels?[index]
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off,
                        ),
                        onTap: () {
                          ref
                              .read(feedViewModelProvider.notifier)
                              .fetchFeed(
                                communityId,
                                channelViewModel.channels![index].id,
                              );
                          onChannelSelected(channelViewModel.channels![index]);
                          Navigator.pop(context);
                        },
                        title: Text(
                          channelViewModel.channels?[index].name ?? '',
                        ),
                      );
                    },
                    itemCount: channelViewModel.channels?.length,
                  ),
                ),
              ],
            ),
    );
  }
}
