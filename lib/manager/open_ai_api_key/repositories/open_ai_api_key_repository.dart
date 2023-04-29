// 📦 Package imports:
import 'package:injectable/injectable.dart';

// 🌎 Project imports:
import 'package:chat_gpt_app/core/app_instances.dart';
import 'package:chat_gpt_app/data/datasources/local_secure_source/secure_storage_source.dart';

abstract class OpenAIApiKeyRepositoryProtocol {
  Future<void> setApiKey(String apiKey);
  Future<void> clearApiKey();
  Future<String?> getApiKey();
}

@LazySingleton(as: OpenAIApiKeyRepositoryProtocol)
class OpenAIApiKeyRepository implements OpenAIApiKeyRepositoryProtocol {
  static const _openAIKeyName = "OPEN_AI_API_KEY";

  late final _secureStorageSource = AppInstances.get<SecureStorageSourceProtocol>();

  @override
  Future<void> clearApiKey() async {
    return _secureStorageSource.clear(key: _openAIKeyName);
  }

  @override
  Future<void> setApiKey(String apiKey) async {
    return _secureStorageSource.write(key: _openAIKeyName, value: apiKey);
  }

  @override
  Future<String?> getApiKey() {
    return _secureStorageSource.read(key: _openAIKeyName);
  }
}
