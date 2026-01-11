import 'package:demo_app/models/channel_model.dart';

class ChannelState {
  final List<ChannelModel>? channels;
  final bool isLoading;
  final String? error;
  ChannelState({this.channels, this.isLoading = false, this.error});

  ChannelState copyWith({
    List<ChannelModel>? channelList,
    bool? loadingState,
    String? err,
  }) {
    return ChannelState(
      channels: channelList ?? channels,
      isLoading: loadingState ?? isLoading,
      error: err ?? error,
    );
  }
}
