import 'package:equatable/equatable.dart';

class VoiceState extends Equatable {
  final bool isListening;
  final String text;
  final String? error;

  const VoiceState({this.isListening = false, this.text = '', this.error});

  VoiceState copyWith({bool? isListening, String? text, String? error}) {
    return VoiceState(
      isListening: isListening ?? this.isListening,
      text: text ?? this.text,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [isListening, text, error];
}
