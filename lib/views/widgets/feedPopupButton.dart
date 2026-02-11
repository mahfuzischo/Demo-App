import 'package:demo_app/viewModels/authentication_view_model.dart';
import 'package:demo_app/viewModels/feed_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Feedpopupbutton extends ConsumerStatefulWidget {
  final int feedId;
  final int communityId;
  final int channelId;

  const Feedpopupbutton({
    super.key,
    required this.feedId,
    required this.communityId,
    required this.channelId,
  });

  @override
  ConsumerState<Feedpopupbutton> createState() => _FeedpopupbuttonState();
}

class _FeedpopupbuttonState extends ConsumerState<Feedpopupbutton> {
  String item1 = "Delete";
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) => [
        PopupMenuItem(child: Text(item1), value: item1),
      ],
      onSelected: (String value) {
        print("value: ${value}");
        if (value == item1) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Are you sure you want to logout?"),
                actions: [
                  TextButton(
                    onPressed: () async {
                      final feedProvider = ref.read(
                        feedViewModelProvider.notifier,
                      );

                      await feedProvider.deleteFeed(
                        widget.feedId,
                        widget.communityId,
                      );
                      await feedProvider.fetchFeed(
                        widget.communityId,
                        widget.channelId,
                      );

                      Navigator.pop(context);
                    },
                    child: Text("Yes"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("No"),
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }
}
