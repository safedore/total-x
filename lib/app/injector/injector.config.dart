// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:http/http.dart' as _i519;
import 'package:injectable/injectable.dart' as _i526;
import 'package:totalx/src/application/auth/auth_bloc.dart' as _i332;
import 'package:totalx/src/application/user/user_bloc.dart' as _i369;
import 'package:totalx/src/domain/core/internet_service/i_base_client.dart'
    as _i1018;
import 'package:totalx/src/domain/core/preference/preference.dart' as _i33;
import 'package:totalx/src/domain/user/i_user_repository.dart' as _i153;
import 'package:totalx/src/infrastructure/core/internet_helper.dart' as _i861;
import 'package:totalx/src/infrastructure/core/preference_helper.dart' as _i170;
import 'package:totalx/src/infrastructure/core/third_party_injectable_module.dart'
    as _i1041;
import 'package:totalx/src/infrastructure/user/user_repository.dart' as _i503;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final thirdPartyInjectableModule = _$ThirdPartyInjectableModule();
    gh.factory<_i332.AuthBloc>(() => _i332.AuthBloc());
    gh.lazySingleton<_i519.Client>(() => thirdPartyInjectableModule.client);
    gh.lazySingleton<_i170.PreferenceHelper>(
      () => thirdPartyInjectableModule.preferenceHelper,
    );
    gh.lazySingleton<_i33.PreferenceContracts>(() => _i170.PreferenceHelper());
    gh.lazySingleton<_i1018.IBaseClient>(
      () => _i861.InternetHelper(gh<_i519.Client>()),
    );
    gh.lazySingleton<_i153.IUserRepository>(
      () => _i503.UserRepository(gh<_i1018.IBaseClient>()),
    );
    gh.factory<_i369.UserBloc>(
      () => _i369.UserBloc(gh<_i153.IUserRepository>()),
    );
    return this;
  }
}

class _$ThirdPartyInjectableModule extends _i1041.ThirdPartyInjectableModule {}
