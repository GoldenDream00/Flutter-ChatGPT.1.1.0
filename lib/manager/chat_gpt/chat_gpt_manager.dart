import 'package:chat_gpt_app/core/app_instances.dart';
import 'package:chat_gpt_app/core/logger.dart';
import 'package:chat_gpt_app/manager/chat_gpt/repositories/chat_gpt_repository.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';

import 'package:injectable/injectable.dart';

abstract class ChatGPTManagerProtocol {
  bool get isAuthorized;
  Future<void> setup({required String? inputApiKey});
  Future<AiModel?> get supportedAIModel;
  Future<ChatCTResponse?> prompt(String promt, {List<Map<String, String>> previousMessages = const []});
  void dispose();
}

@LazySingleton(as: ChatGPTManagerProtocol)
class ChatGPTManager implements ChatGPTManagerProtocol {
  bool _isAuthorizedOpenAI = false;
  late final _chatGPTRepository = AppInstances.get<ChatGPTRepositoryProtocol>();
  AiModel? _aiModel;

  @override
  Future<void> setup({String? inputApiKey}) async {
    try {
      final apiKey = inputApiKey;
      if (apiKey != null) {
        await _chatGPTRepository.setup(apiKey);
        _aiModel = await _chatGPTRepository.models;
        _isAuthorizedOpenAI = true;
      } else {
        _isAuthorizedOpenAI = false;
      }
    } catch (e) {
      AppLogger.error(() => "Error when setup chat GPT $e");
      rethrow;
    }
  }

  @override
  bool get isAuthorized => _isAuthorizedOpenAI;

  @override
  Future<ChatCTResponse?> prompt(String promt, {List<Map<String, String>> previousMessages = const []}) async {
    if (isAuthorized) {
      try {
        final response = await _chatGPTRepository.request(
            text: ChatCompleteText(
          messages: [
            ...previousMessages,
            Map.of({"role": "user", "content": promt}),
          ],
          maxToken: 2000,
          model: ChatModel.gptTurbo0301,
        ));
        AppLogger.debug(() => "prompt: ${response?.toJson()}");
        return response;
      } catch (e) {
        AppLogger.error(() => "Error when prompt for chat GPT $e");
      }
    }
    return null;
  }

  @override
  Future<AiModel?> get supportedAIModel async {
    if (_isAuthorizedOpenAI) {
      return _aiModel ?? await _chatGPTRepository.models;
    }
    return null;
  }

  @override
  void dispose() {
    _isAuthorizedOpenAI = false;
    _aiModel = null;
  }
}
