import 'package:livekit_client/livekit_client.dart';
import 'dart:async';

class LivekitService {
  static Future<Room> viewerJoinRoom({
    required String liveId,
    required String token,
    required String url,
  }) async {
    final room = Room();

    try {
      print('Viewer connecting to room $liveId...');
      const connectOptions = ConnectOptions(
        rtcConfiguration: RTCConfiguration(),
        autoSubscribe: true,
      );
      const roomOptions = RoomOptions(adaptiveStream: true, dynacast: true);

      await room.connect(
        url,
        token,
        connectOptions: connectOptions,
        roomOptions: roomOptions,
      );
      print('Viewer connected to room $liveId successfully');

      return room;
    } catch (e) {
      print('Error during setup: $e');
      throw Exception('Failed to setup connection: $e');
    }
  }

  // Function to connect to LiveKit room
  static Future<Room> broadcasterCreateRoom({
    required String liveId,
    required String token,
    required String url,
  }) async {
    final room = Room();

    try {
      const connectOptions = ConnectOptions(
        rtcConfiguration: RTCConfiguration(),
        autoSubscribe: true,
      );
      const roomOptions = RoomOptions(adaptiveStream: true, dynacast: true);

      await room.connect(
        url,
        token,
        connectOptions: connectOptions,
        roomOptions: roomOptions,
      );

      // If joining as a broadcaster, check if there's already a broadcaster in the room
      // Check if there's already another broadcaster in the room
      bool broadcasterExists = false;
      for (final participant in room.remoteParticipants.values) {
        if (participant.identity == 'broadcaster') {
          broadcasterExists = true;
          break;
        }
      }

      if (broadcasterExists) {
        // Disconnect and throw exception if a broadcaster already exists
        await room.disconnect();
        throw Exception('A broadcaster already exists in this room');
      }

      print('Publishing local tracks...');
      final participant = room.localParticipant;
      if (participant == null) {
        throw Exception('LocalParticipant is null');
      }

      // Enable camera and microphone after connecting
      await participant.setCameraEnabled(true);
      print('Camera track published');

      await participant.setMicrophoneEnabled(true);
      print('Audio track published');

      return room;
    } catch (e) {
      print('Error during setup: $e');
      throw Exception('Failed to setup connection: $e');
    }
  }
}
