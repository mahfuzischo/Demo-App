import 'package:demo_app/models/channel_model.dart';
import 'package:demo_app/viewModels/channel_view_model.dart';
import 'package:demo_app/viewModels/feed_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommunityDrawer extends ConsumerStatefulWidget {
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
  ConsumerState<CommunityDrawer> createState() => _CommunityDrawerState();
}

class _CommunityDrawerState extends ConsumerState<CommunityDrawer> {
  @override
  void initState() {
    super.initState();

    final channelState = ref.read(channelViewModelProvider);

    if ((channelState.channels ?? []).isNotEmpty &&
        widget.selectedChannel == null) {
      debugPrint("selected channel found null");
      ref
          .read(feedViewModelProvider.notifier)
          .fetchFeed(widget.commId, channelState.channels!.first.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final channelState = ref.watch(channelViewModelProvider);

    return Drawer(
      child: channelState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: channelState.channels?.length ?? 0,
              itemBuilder: (context, index) {
                final channel = channelState.channels![index];

                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    widget.onTapDrawerTile(channel);
                  },
                  child: ListTile(
                    title: Text(channel.name),
                    // selected: channel.id == widget.selectedChannel?.id,
                    // selectedColor: Color.fromRGBO(7, 81, 91, 1.0),
                    tileColor: channel.id == widget.selectedChannel?.id
                        ? Color.fromRGBO(7, 81, 91, .5)
                        : Colors.transparent,
                  ),
                );
              },
            ),
    );
  }
}
