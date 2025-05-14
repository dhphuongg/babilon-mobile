import 'package:babilon/core/application/models/response/live/live.dart';
import 'package:babilon/core/domain/utils/share_preferences.dart';
import 'package:babilon/di.dart';
import 'package:babilon/infrastructure/services/livekit_service.dart';
import 'package:babilon/infrastructure/services/socket_client.service.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    startViewLive(widget.live.id);
    super.initState();
  }

  startViewLive(String liveId) async {
    final data = {
      'liveId': liveId,
      'userId': await SharedPreferencesHelper.getStringValue(
        SharedPreferencesHelper.USER_ID,
      ),
    };
    getIt<SocketClientService>().socket.emitWithAck(
      'user-join-live',
      data,
      ack: (response) {
        String liveId = response['liveId'];
        String token = response['token'];
        String url = response['url'];
        _setupRoom(liveId: liveId, token: token, url: url);
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

  @override
  void dispose() {
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

              // "LIVE" indicator
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(4.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 4.0,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'LIVE',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
                  ),
                if (!_broadcasterConnected && !_hasShownDisconnectMessage)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _hasShownDisconnectMessage = true;
                      });
                    },
                    child: Text('Refresh Status'),
                  ),
              ],
            ),
          );
  }
}
