// 📦 Package imports:
import 'package:get_it/get_it.dart';

class AppInstances {
  AppInstances._();

  static T get<T extends Object>({String? instanceName}) => GetIt.instance.get<T>(instanceName: instanceName);
}
