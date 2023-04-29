// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:chat_gpt_app/data/datasources/local_secure_source/secure_storage_source.dart'
    as _i7;
import 'package:chat_gpt_app/data/datasources/local_storage/share_preferences_source.dart'
    as _i3;
import 'package:chat_gpt_app/manager/chat_gpt/chat_gpt_manager.dart' as _i4;
import 'package:chat_gpt_app/manager/chat_gpt/repositories/chat_gpt_repository.dart'
    as _i5;
import 'package:chat_gpt_app/manager/chat_gpt/repositories/open_ai_api_key_repository.dart'
    as _i6;
import 'package:chat_gpt_app/manager/theme/theme_manager.dart' as _i8;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

extension GetItInjectableX on _i1.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i1.GetIt> init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    await gh.lazySingletonAsync<_i3.SharedPreferencesSourceProtocol>(
      () {
        final i = _i3.SharedPreferencesSource();
        return i.setup().then((_) => i);
      },
      preResolve: true,
    );
    gh.lazySingleton<_i4.ChatGPTManagerProtocol>(() => _i4.ChatGPTManager());
    gh.lazySingleton<_i5.ChatGPTRepositoryProtocol>(
        () => _i5.ChatGPTRepository());
    gh.lazySingleton<_i6.OpenAIApiKeyRepositoryProtocol>(
        () => _i6.OpenAIApiKeyRepository());
    gh.lazySingleton<_i7.SecureStorageSourceProtocol>(
        () => _i7.SecureStorageSource());
    gh.lazySingleton<_i8.ThemeManagerProtocol>(() => _i8.ThemeManager());
    return this;
  }
}
