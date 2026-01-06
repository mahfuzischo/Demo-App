import 'package:demo_app/viewModels/community_view_model.dart';
import 'package:demo_app/views/widgets/cardWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommunityView extends ConsumerStatefulWidget {
  const CommunityView({super.key});

  @override
  ConsumerState<CommunityView> createState() => _CommunityViewState();
}

class _CommunityViewState extends ConsumerState<CommunityView> {
  @override
  void initState() {
    ref.read(CommunityViewModelProvider.notifier).getCommunityList();
    super.initState();
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
            : Column(
                children: [
                  Text('Community Page: '),

                  Text(
                    'First community id: ${communityState.communities?.first.id}',
                  ),
                  GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                    itemCount: communityState.communities!.length,
                    itemBuilder: (BuildContext context, int index) {
                      final community = communityState.communities![index];
                      return CardWidget(
                        title: community.title,
                        image: community.thumbnail,
                        count: community.total_members,
                      );
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
