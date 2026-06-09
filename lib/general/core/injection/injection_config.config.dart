// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:e_com_user/features/Auth/data/repo_impl/auth_repo_impl.dart'
    as _i452;
import 'package:e_com_user/features/Auth/data/use_case/auth_use_case.dart'
    as _i273;
import 'package:e_com_user/features/Auth/domain/repository/auth_repository.dart'
    as _i1005;
import 'package:e_com_user/features/Auth/presentation/provider/auth_provider.dart'
    as _i4;
import 'package:e_com_user/general/core/network/dio_client/dio_module.dart'
    as _i319;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final dioModule = _$DioModule();
    gh.lazySingleton<_i361.Dio>(() => dioModule.dio());
    gh.lazySingleton<_i1005.AuthRepository>(
      () => _i452.AuthRepoImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i273.AuthUseCase>(
      () => _i273.AuthUseCase(gh<_i1005.AuthRepository>()),
    );
    gh.factory<_i4.AuthProvider>(
      () => _i4.AuthProvider(gh<_i273.AuthUseCase>()),
    );
    return this;
  }
}

class _$DioModule extends _i319.DioModule {}
