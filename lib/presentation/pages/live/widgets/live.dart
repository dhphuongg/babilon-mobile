import 'package:babilon/core/application/models/response/live/live.dart';
import 'package:babilon/core/domain/constants/app_colors.dart';
import 'package:babilon/core/domain/constants/websocket_event.dart';
import 'package:babilon/core/domain/utils/share_preferences.dart';
import 'package:babilon/di.dart';
import 'package:babilon/infrastructure/services/livekit_service.dart';
import 'package:babilon/infrastructure/services/socket_client.service.dart';
import 'package:babilon/presentation/pages/record_video/widgets/broadcaster.dart';
import 'package:babilon/presentation/pages/record_video/widgets/list_live_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livekit_client/livekit_client.dart';

class AppLive extends StatefulWidget {
  final Live live;
  const AppLive({
    Key? key,
    required this.live,
  }) : super(key: key);

  @override
  State<AppLive> createState() => _AppLiveState();
}

class _AppLiveState extends State<AppLive> {
  late Room _room;

  VideoTrack? _videoTrack;
  Function? _cancelListenFunc;
  bool _broadcasterConnected = false;
  bool _hasShownDisconnectMessage = false;

  late UserInfo? _userInfo;

  final GlobalKey<ListLiveEventState> _chatKey =
      GlobalKey<ListLiveEventState>();

  @override
  void initState() {
    startViewLive(widget.live.id);
    super.initState();
  }

  // load user info from shared preferences
  Future<void> _loadUserInfo() async {
    final user = await SharedPreferencesHelper.getUserInfo();

    setState(() {
      _userInfo = user;
    });
  }

  startViewLive(String liveId) async {
    await _loadUserInfo();
    if (_userInfo == null) {
      return;
    }
    final data = {
      'liveId': liveId,
      'user': {
        'userId': _userInfo!.userId,
        'fullName': _userInfo!.fullName,
        'username': _userInfo!.username,
        'avatar': _userInfo!.avatar,
        'signature': _userInfo!.signature,
      },
    };
    getIt<SocketClientService>().socket.emitWithAck(
      WebsocketEvent.USER_JOIN_LIVE,
      data,
      ack: (response) {
        String liveId = response['liveId'];
        String token = response['token'];
        String url = response['url'];
        _setupRoom(liveId: liveId, token: token, url: url);
      },
    );

    getIt<SocketClientService>().socket.on(
      WebsocketEvent.USER_LEAVE_LIVE,
      (user) {
        print('${user['userId']} has left the live');
      },
    );
  }

  void _setupRoom({
    required String liveId,
    required String token,
    required String url,
  }) async {
    _room = await LivekitService.viewerJoinRoom(
      liveId: liveId,
      token: token,
      url: url,
    );
    // Listen to room events
    _cancelListenFunc = _room.events.listen((event) {
      if (event is RoomEvent) {
        // When a track is subscribed (this is fired when a remote track becomes available)
        if (event is TrackSubscribedEvent &&
            event.publication.kind == TrackType.VIDEO) {
          final videoTrack = event.track as VideoTrack;
          setState(() {
            // Only store the first video track we receive
            _videoTrack ??= videoTrack;
            _broadcasterConnected = true;
            _hasShownDisconnectMessage = false;
          });
        }
        // When a track is unsubscribed (remote participant disables video or leaves)
        else if (event is TrackUnsubscribedEvent) {
          final videoTrack = event.track;
          if (videoTrack is VideoTrack && videoTrack == _videoTrack) {
            setState(() {
              _videoTrack = null;
              _broadcasterConnected = false;
            });
          }
        }
        // When a participant leaves (like the broadcaster)
        else if (event is ParticipantDisconnectedEvent) {
          if (event.participant.identity == 'broadcaster') {
            setState(() {
              _broadcasterConnected = false;
              _videoTrack = null; // Clear the video track
            });
            print('Broadcaster has left the room');
          }
        }
        // When the server disconnects the room
        else if (event is RoomDisconnectedEvent) {
          setState(() {
            _broadcasterConnected = false;
            _videoTrack = null;
          });
          print('Room disconnected: ${event.reason}');
        }
      }
    });

    // Check for any existing remote participants that are already streaming video
    _checkExistingParticipants();

    getIt<SocketClientService>().socket.on(
      WebsocketEvent.USER_SEND_MESSAGE_TO_LIVE,
      (message) {
        _chatKey.currentState?.addEvent(
          LiveEvent(
            text: message['text'],
            avatar: message['user']['avatar'],
            fullName: message['user']['fullName'],
          ),
        );
      },
    );
  }

  void _checkExistingParticipants() {
    // Go through all remote participants
    for (final participant in _room.remoteParticipants.values) {
      // Check all track publications for each participant
      for (final publication in participant.trackPublications.values) {
        // If it's a subscribed video track
        if (publication.kind == TrackType.VIDEO &&
            publication.subscribed &&
            publication.track != null) {
          final videoTrack = publication.track as VideoTrack;
          if (_videoTrack == null) {
            setState(() {
              _videoTrack = videoTrack;
            });
          }
        }
      }
    }
  }

  void sendLeaveLiveEvent() {
    getIt<SocketClientService>().socket.emit(
      WebsocketEvent.USER_LEAVE_LIVE,
      {
        'liveId': widget.live.id,
        'user': {
          'userId': _userInfo!.userId,
          'fullName': _userInfo!.fullName,
          'username': _userInfo!.username,
          'avatar': _userInfo!.avatar,
          'signature': _userInfo!.signature,
        }
      },
    );
    _room.disconnect();
    _cancelListenFunc?.call();
  }

  @override
  void dispose() {
    sendLeaveLiveEvent();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _videoTrack != null
        ? Stack(
            children: [
              // Video with animated border
              Positioned.fill(
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: VideoTrackRenderer(_videoTrack!),
                ),
              ),

              // Top row with broadcaster info and LIVE indicator
              Positioned(
                top: 0,
                left: 10.w,
                right: 10.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Broadcaster(
                        userInfo: UserInfo(
                      userId: widget.live.user.id,
                      username: widget.live.user.username,
                      avatar: widget.live.user.avatar ?? '',
                      fullName: widget.live.user.fullName,
                      signature: '',
                    )),
                    // x button
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: ListLiveEvent(
                  key: _chatKey,
                  onSendEvent: (event) {
                    // TODO: Implement send event functionality
                    getIt<SocketClientService>().socket.emit(
                      WebsocketEvent.USER_SEND_MESSAGE_TO_LIVE,
                      {
                        'liveId': widget.live.id,
                        'user': {
                          'userId': _userInfo!.userId,
                          'fullName': _userInfo!.fullName,
                          'username': _userInfo!.username,
                          'avatar': _userInfo!.avatar,
                          'signature': _userInfo!.signature,
                        },
                        'text': event.text,
                      },
                    );
                  },
                ),
              )
            ],
          )
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_broadcasterConnected)
                  const Text('Waiting for broadcaster to start video...')
                else
                  Text(
                    _hasShownDisconnectMessage
                        ? 'Broadcaster has disconnected.\nPlease go back and join another room.'
                        : 'Waiting for broadcaster to join...',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                if (!_broadcasterConnected && !_hasShownDisconnectMessage)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _hasShownDisconnectMessage = true;
                      });
                    },
                    child: const Text('Refresh Status'),
                  ),
              ],
            ),
          );
  }
}
