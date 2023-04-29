import 'package:chat_gpt_app/core/app_instances.dart';
import 'package:chat_gpt_app/core/logger.dart';
import 'package:chat_gpt_app/manager/chat_gpt/repositories/chat_gpt_repository.dart';
import 'package:chat_gpt_app/manager/chat_gpt/repositories/open_ai_api_key_repository.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';

import 'package:injectable/injectable.dart';

abstract class ChatGPTManagerProtocol {
  bool get isAuthorized;
  Future<void> setup();
  Future<void> setNewApiKey(String apiKey);
}

@LazySingleton(as: ChatGPTManagerProtocol)
class ChatGPTManager implements ChatGPTManagerProtocol {
  bool _isAuthorizedOpenAI = false;

  late final _openAIApiKeyRepository = AppInstances.get<OpenAIApiKeyRepositoryProtocol>();
  late final _chatGPTRepository = AppInstances.get<ChatGPTRepositoryProtocol>();
  AiModel? _aiModel;

  @override
  Future<void> setup() async {
    try {
      final apiKey = await _openAIApiKeyRepository.getApiKey();
      if (apiKey != null) {
        await _chatGPTRepository.setup(apiKey);
        _isAuthorizedOpenAI = true;
        _aiModel = await _chatGPTRepository.models;
      }
    } catch (e) {
      AppLogger.error(() => "Error when setup chat GPT $e");
    }
  }

  @override
  bool get isAuthorized => _isAuthorizedOpenAI;

  @override
  Future<void> setNewApiKey(String apiKey) async {
    try {
      await _openAIApiKeyRepository.setApiKey(apiKey);
      setup();
    } catch (e) {
      AppLogger.error(() => "Error when set new key for chat GPT $e");
    }
  }
}
