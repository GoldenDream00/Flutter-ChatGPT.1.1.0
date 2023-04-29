// 📦 Package imports:
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

abstract class SecureStorageSourceProtocol {
  Future<String?> read({required String key});

  Future<void> write({required String key, required String? value});

  Future<void> clear({required String key});

  Future<void> clearAll();
}

@LazySingleton(as: SecureStorageSourceProtocol)
class SecureStorageSource implements SecureStorageSourceProtocol {
  
  late final _secureStorage = const FlutterSecureStorage(
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock_this_device),
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  @override
  Future<void> clear({required String key}) {
    return _secureStorage.delete(key: key);
  }

  @override
  Future<void> clearAll() {
    return _secureStorage.deleteAll();
  }

  @override
  Future<String?> read({required String key}) {
    return _secureStorage.read(key: key);
  }

  @override
  Future<void> write({required String key, required String? value}) {
    return _secureStorage.write(key: key, value: value);
  }
}
