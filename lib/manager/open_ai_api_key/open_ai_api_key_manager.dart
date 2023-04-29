// 📦 Package imports:
import 'package:injectable/injectable.dart';

// 🌎 Project imports:
import 'package:chat_gpt_app/core/app_instances.dart';
import 'package:chat_gpt_app/manager/open_ai_api_key/repositories/open_ai_api_key_repository.dart';

abstract class OpenAIApiKeyManagerProtocol {
  Future<void> set(String key);
  Future<void> clear();
  Future<void> get apiKey;
}

@LazySingleton(as: OpenAIApiKeyManagerProtocol)
class OpenAIApiKeyManager implements OpenAIApiKeyManagerProtocol {
  late final _openAIApiKeyRepository = AppInstances.get<OpenAIApiKeyRepositoryProtocol>();

  @override
  Future<void> set(String key) {
    return _openAIApiKeyRepository.setApiKey(key);
  }

  @override
  Future<void> clear() {
    return _openAIApiKeyRepository.clearApiKey();
  }

  @override
  Future<void> get apiKey => _openAIApiKeyRepository.getApiKey();
}
