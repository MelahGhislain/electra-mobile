import 'package:equatable/equatable.dart';

// Matches every server message type the BE can send
enum VoiceStatus {
  idle,        // not started
  listening,   // mic open, Deepgram receiving audio
  processing,  // END_SESSION sent, BE running LLM extraction
  done,        // EXPENSES_SAVED received
  error,       // ERROR received
}

class VoiceState extends Equatable {
  final VoiceStatus status;

  /// Live / accumulated transcript text shown while listening
  final String transcript;

  /// Error message when status == error
  final String? error;

  const VoiceState({
    this.status = VoiceStatus.idle,
    this.transcript = '',
    this.error,
  });

  bool get isListening  => status == VoiceStatus.listening;
  bool get isProcessing => status == VoiceStatus.processing;
  bool get isDone       => status == VoiceStatus.done;
  bool get isError      => status == VoiceStatus.error;

  VoiceState copyWith({
    VoiceStatus? status,
    String? transcript,
    String? error,
  }) {
    return VoiceState(
      status:     status     ?? this.status,
      transcript: transcript ?? this.transcript,
      error:      error      ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, transcript, error];
}
