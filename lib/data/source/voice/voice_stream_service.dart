import 'dart:async';
import 'dart:convert';
import 'package:electra/core/configs/env.dart';
import 'package:electra/core/network/api_endpoints.dart';
import 'package:record/record.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class VoiceStreamService {
  final _recorder = AudioRecorder();
  WebSocketChannel? _channel;

  final _controller = StreamController<String>.broadcast();
  Stream<String> get textStream => _controller.stream;

  Future<void> start() async {
    _channel = WebSocketChannel.connect(
      Uri.parse('${Env.webSocketUrl}${ApiEndpoints.voiceStream}'),
    );

    _channel!.stream.listen((event) {
      final data = jsonDecode(event);

      if (data['type'] == 'partial' || data['type'] == 'final') {
        _controller.add(data['text']);
      }
    });

    final stream = await _recorder.startStream(
      const RecordConfig(
        encoder: AudioEncoder.pcm16bits,
        sampleRate: 16000,
        numChannels: 1,
      ),
    );

    stream.listen((chunk) {
      _channel?.sink.add(chunk);
    });
  }

  Future<void> stop() async {
    await _recorder.stop();
    await _channel?.sink.close();
  }

  void dispose() {
    _controller.close();
  }
}
