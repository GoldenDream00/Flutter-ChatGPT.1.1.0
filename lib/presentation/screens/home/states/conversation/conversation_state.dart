part of 'conversation_cubit.dart';

abstract class ConversationState extends Equatable {
  const ConversationState();

  @override
  List<Object> get props => [];
}

class ConversationInitialState extends ConversationState {}

class ConversationLoadedState extends ConversationState {
  final List<MessageModel> messages;

  const ConversationLoadedState(this.messages);

  @override
  List<Object> get props => [messages];
}

class ConversationLoadingState extends ConversationState {
  final List<MessageModel> messages;

  const ConversationLoadingState(this.messages);

  @override
  List<Object> get props => [messages];
}
