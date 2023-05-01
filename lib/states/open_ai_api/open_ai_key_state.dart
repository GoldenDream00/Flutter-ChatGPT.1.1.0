part of 'open_ai_key_cubit.dart';

abstract class OpenAIKeyState extends Equatable {
  const OpenAIKeyState();

  @override
  List<Object> get props => [];
}

class OpenAIKeyInitialState extends OpenAIKeyState {}

class OpenAIKeyLoadedState extends OpenAIKeyState {
  final String key;

  const OpenAIKeyLoadedState(this.key);
}
