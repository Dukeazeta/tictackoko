import 'dart:async';
import 'dart:io';
import 'dart:convert';

class NetworkService {
  static const int PORT = 8888;
  ServerSocket? server;
  Socket? client;
  final StreamController<String> _messageController = StreamController<String>.broadcast();
  
  Stream<String> get messageStream => _messageController.stream;

  Future<void> startServer() async {
    try {
      server = await ServerSocket.bind(InternetAddress.anyIPv4, PORT);
      server!.listen((Socket socket) {
        client = socket;
        socket.listen(
          (List<int> data) {
            final message = utf8.decode(data);
            _messageController.add(message);
          },
          onError: (error) {
            print('Error: $error');
            socket.close();
          },
          onDone: () {
            socket.close();
          },
        );
      });
    } catch (e) {
      print('Error starting server: $e');
      rethrow;
    }
  }

  Future<void> connectToServer(String host) async {
    try {
      client = await Socket.connect(host, PORT);
      client!.listen(
        (List<int> data) {
          final message = utf8.decode(data);
          _messageController.add(message);
        },
        onError: (error) {
          print('Error: $error');
          client?.close();
        },
        onDone: () {
          client?.close();
        },
      );
    } catch (e) {
      print('Error connecting to server: $e');
      rethrow;
    }
  }

  void sendMessage(String message) {
    client?.write(message);
  }

  void dispose() {
    server?.close();
    client?.close();
    _messageController.close();
  }
}
