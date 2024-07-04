import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

class ManualFeedButton extends StatefulWidget {
  final int portion;

  const ManualFeedButton({
    super.key,
    required this.portion,
  });

  @override
  _ManualFeedButtonState createState() => _ManualFeedButtonState();
}

class _ManualFeedButtonState extends State<ManualFeedButton> {
  late WebSocketChannel channel;

  @override
  void initState() {
    super.initState();
    channel = IOWebSocketChannel.connect('ws://192.168.4.1/ws'); // Pastikan alamat IP sesuai dengan IP ESP32
  }

  void _manualFeed() {
    final message = 'feed:${widget.portion}';
    channel.sink.add(message); // Kirim pesan dengan porsi
    print("Manual Feed Button clicked, message sent: $message"); // Debug print statement
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      height: 50,
      child: ElevatedButton(
        onPressed: _manualFeed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFFADABC)),
        ),
        child: Text(
          'MANUAL FEED',
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
