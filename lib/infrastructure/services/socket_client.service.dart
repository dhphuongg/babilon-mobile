import 'package:babilon/core/domain/utils/logger.dart';
import 'package:babilon/core/domain/utils/utils.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketClientService {
  SocketClientService() {
    initialize();
  }
  late Socket socket;

  Future<void> initialize() async {
    String accessToken = await getAccessToken();
    try {
      socket = io(
        '${dotenv.env['API_URL']}/socket',
        OptionBuilder()
            .setTransports(['websocket'])
            .setReconnectionAttempts(5)
            .setExtraHeaders({
              'Authorization': 'Bearer $accessToken',
            })
            .build(),
      );
      socket.connect();
      AppLogger.instance.info('Socket connected: ${socket.id}');
    } catch (e) {
      AppLogger.instance.error('Socket connection error: $e');
    }
  }
}
