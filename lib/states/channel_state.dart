import 'package:demo_app/models/channel_model.dart';

class ChannelState {
  final List<ChannelModel>? channels;
  final bool isLoading;
  final String? error;
  final bool maxFetched;
  ChannelState({
    this.channels,
    this.isLoading = false,
    this.error,
    this.maxFetched = false,
  });

  ChannelState copyWith({
    List<ChannelModel>? channelList,
    bool? loadingState,
    String? err,
    bool? maxScrolled,
  }) {
    return ChannelState(
      channels: channelList ?? channels,
      isLoading: loadingState ?? isLoading,
      error: err ?? error,
      maxFetched: maxScrolled ?? maxFetched,
    );
  }
}
