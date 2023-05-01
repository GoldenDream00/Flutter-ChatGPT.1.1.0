import 'package:chat_gpt_app/core/app_instances.dart';
import 'package:chat_gpt_app/core/logger.dart';
import 'package:chat_gpt_app/manager/open_ai_key/repositories/open_ai_api_key_repository.dart';

import 'package:injectable/injectable.dart';

abstract class OpenAIKeyManagerProtocol {
  Future<String?> get apiKey;
  Future<void> setNewApiKey(String apiKey);
  Future<void> clearApiKey();
}

@LazySingleton(as: OpenAIKeyManagerProtocol)
class OpenAIKeyManager implements OpenAIKeyManagerProtocol {
  late final _openAIApiKeyRepository = AppInstances.get<OpenAIApiKeyRepositoryProtocol>();

  @override
  Future<void> setNewApiKey(String apiKey) async {
    try {
      await _openAIApiKeyRepository.setApiKey(apiKey);
    } catch (e) {
      AppLogger.error(() => "Error when set new key for chat GPT $e");
    }
  }

  @override
  Future<void> clearApiKey() async {
    await _openAIApiKeyRepository.clearApiKey();
  }

  @override
  Future<String?> get apiKey => _openAIApiKeyRepository.getApiKey();
}
