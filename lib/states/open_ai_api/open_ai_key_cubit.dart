import 'package:chat_gpt_app/core/app_instances.dart';
import 'package:chat_gpt_app/core/logger.dart';
import 'package:chat_gpt_app/manager/chat_gpt/chat_gpt_manager.dart';
import 'package:chat_gpt_app/manager/open_ai_key/open_ai_key_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'open_ai_key_state.dart';

class OpenAIKeyCubit extends Cubit<OpenAIKeyState> {
  OpenAIKeyCubit() : super(OpenAIKeyInitialState()) {
    _init();
  }

  late final _openAIKeyManager = AppInstances.get<OpenAIKeyManagerProtocol>();
  late final _chatGPTManager = AppInstances.get<ChatGPTManagerProtocol>();

  Future<void> _init() async {
    final key = await _openAIKeyManager.apiKey;
    if (key != null) {
      try {
        await _chatGPTManager.setup(inputApiKey: key);
        emit(OpenAIKeyLoadedState(key));
      } catch (e) {
        AppLogger.error(() => "Error when setup key for Chat GPT $e");
      }
    }
  }

  Future<void> setKey(String key) async {
    _openAIKeyManager.setNewApiKey(key);
    _init();
  }

  Future<void> clearKey() async {
    emit(OpenAIKeyInitialState());
    _openAIKeyManager.clearApiKey();
    _chatGPTManager.dispose();
  }
}
