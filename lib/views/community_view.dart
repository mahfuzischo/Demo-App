import 'package:demo_app/viewModels/community_view_model.dart';
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
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final communities = ref.watch(CommunityViewModelProvider);
    return Scaffold(
      appBar: AppBar(title: Text('My Communities')),
      body: Center(
        child: communities.isLoading
            ? CircularProgressIndicator(value: 10)
            : Column(
                children: [
                  Text('Community Page: '),
                  ElevatedButton(
                    onPressed: () {
                      ref
                          .read(CommunityViewModelProvider.notifier)
                          .getCommunityList();
                    },
                    child: Text("Fetch community"),
                  ),
                ],
              ),
      ),
    );
  }
}
