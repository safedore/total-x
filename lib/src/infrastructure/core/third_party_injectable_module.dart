import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:totalx/src/infrastructure/core/preference_helper.dart';

// Register module for third party dependencies
@module
abstract class ThirdPartyInjectableModule {
  @lazySingleton
  http.Client get client => http.Client();

  @lazySingleton
  PreferenceHelper get preferenceHelper => PreferenceHelper();
}
