import 'package:chat_gpt_app/core/app_instances.dart';
import 'package:chat_gpt_app/manager/chat_gpt/chat_gpt_manager.dart';
import 'package:chat_gpt_app/presentation/screens/home/model/message_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'conversation_state.dart';

class ConversationCubit extends Cubit<ConversationState> {
  late final _chatGPTManager = AppInstances.get<ChatGPTManagerProtocol>();
  ConversationCubit() : super(ConversationInitialState());

  void sendMessage(String message) {
    final currentState = state;
    final previousMessages = currentState is ConversationLoadedState ? currentState.messages : <MessageModel>[];
    final allMessages = [
      ...previousMessages,
      MessageModel.fromJson(
        {
          "role": "user",
          "content": message,
        },
      ),
    ];
    try {
      emit(ConversationLoadingState([
        ...allMessages,
        const MessageModel("assistant", "...", isLoading: true),
      ]));

      _chatGPTManager
          .prompt(
        message,
        previousMessages: previousMessages.map((e) => e.toJson()).toList(),
      )
          .then((response) {
        if (response != null) {
          emit(ConversationLoadedState([
            ...allMessages,
            ...response.choices
                .map(
                  (e) => MessageModel(e.message?.role ?? "assistant", e.message?.content ?? ""),
                )
                .toList(),
          ]));
        } else {
          emit(ConversationLoadedState(allMessages));
        }
      });
    } catch (e) {
      emit(ConversationLoadedState(allMessages));
    }
  }

  void clearChat() {
    emit(ConversationInitialState());
  }
}
