// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:dio/dio.dart' as _i361;
import 'package:e_com_user/features/Address/data/repo_impl/address_repo_imple.dart'
    as _i347;
import 'package:e_com_user/features/Address/data/use_case/address_use_case.dart'
    as _i43;
import 'package:e_com_user/features/Address/domain/repo/address_repo.dart'
    as _i377;
import 'package:e_com_user/features/Address/presentation/provider/address_provider.dart'
    as _i980;
import 'package:e_com_user/features/Auth/data/repo_impl/auth_repo_impl.dart'
    as _i452;
import 'package:e_com_user/features/Auth/data/use_case/auth_use_case.dart'
    as _i273;
import 'package:e_com_user/features/Auth/domain/repository/auth_repository.dart'
    as _i1005;
import 'package:e_com_user/features/Auth/presentation/provider/auth_provider.dart'
    as _i4;
import 'package:e_com_user/features/Cart/data/repo_impl/cart_repo_impl.dart'
    as _i750;
import 'package:e_com_user/features/Cart/data/use_case/cart_use_case.dart'
    as _i675;
import 'package:e_com_user/features/Cart/domain/repo/cart_repo.dart' as _i386;
import 'package:e_com_user/features/Cart/presentation/provider/cart_provider.dart'
    as _i89;
import 'package:e_com_user/features/Category/data/repo_impl/category_repo_impl.dart'
    as _i1;
import 'package:e_com_user/features/Category/data/use_case/category_use_case.dart'
    as _i372;
import 'package:e_com_user/features/Category/domain/repo/category_repo.dart'
    as _i905;
import 'package:e_com_user/features/favourite/data/repo_impl/favourite_repo_impl.dart'
    as _i313;
import 'package:e_com_user/features/favourite/data/use_case/fav_use_case.dart'
    as _i496;
import 'package:e_com_user/features/favourite/domain/repo/fav_repo.dart'
    as _i460;
import 'package:e_com_user/features/favourite/presentation/provider/fav_provider.dart'
    as _i963;
import 'package:e_com_user/features/Home/data/repo_impl/product_repo_impl.dart'
    as _i977;
import 'package:e_com_user/features/Home/data/use_case/product_use_case.dart'
    as _i891;
import 'package:e_com_user/features/Home/domain/product_repo.dart' as _i294;
import 'package:e_com_user/general/core/module/dio_client/dio_module.dart'
    as _i39;
import 'package:e_com_user/general/core/module/firebase_module/firebase_module.dart'
    as _i33;
import 'package:e_com_user/general/services/local_storage/app_preferences.dart'
    as _i585;
import 'package:e_com_user/general/services/local_storage/preference_module.dart'
    as _i468;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final preferenceModule = _$PreferenceModule();
    final dioModule = _$DioModule();
    final firebaseModule = _$FirebaseModule();
    gh.factory<_i89.CartProvider>(() => _i89.CartProvider());
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => preferenceModule.sharedPreferences(),
      preResolve: true,
    );
    gh.lazySingleton<_i361.Dio>(() => dioModule.dio());
    gh.lazySingleton<_i974.FirebaseFirestore>(
      () => firebaseModule.firebaseFirestore(),
    );
    gh.lazySingleton<_i43.AddressUseCase>(
      () => _i43.AddressUseCase(gh<_i974.FirebaseFirestore>()),
    );
    gh.lazySingleton<_i675.CartUseCase>(
      () => _i675.CartUseCase(gh<_i974.FirebaseFirestore>()),
    );
    gh.lazySingleton<_i372.CategoryUseCase>(
      () => _i372.CategoryUseCase(gh<_i974.FirebaseFirestore>()),
    );
    gh.lazySingleton<_i891.ProductUseCase>(
      () => _i891.ProductUseCase(gh<_i974.FirebaseFirestore>()),
    );
    gh.lazySingleton<_i496.FavUseCase>(
      () => _i496.FavUseCase(gh<_i974.FirebaseFirestore>()),
    );
    gh.lazySingleton<_i294.ProductRepo>(
      () => _i977.ProductRepoImpl(gh<_i891.ProductUseCase>()),
    );
    gh.lazySingleton<_i905.CategoryRepo>(
      () => _i1.CategoryRepoImpl(gh<_i372.CategoryUseCase>()),
    );
    gh.lazySingleton<_i386.CartRepo>(
      () => _i750.CartRepoImpl(gh<_i675.CartUseCase>()),
    );
    gh.lazySingleton<_i460.FavRepo>(
      () => _i313.FavouriteRepoImpl(gh<_i496.FavUseCase>()),
    );
    gh.singleton<_i585.AppPreferences>(
      () => preferenceModule.appPreferences(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i377.AddressRepo>(
      () => _i347.AddressRepoImple(gh<_i43.AddressUseCase>()),
    );
    gh.lazySingleton<_i1005.AuthRepository>(
      () => _i452.AuthRepoImpl(gh<_i974.FirebaseFirestore>()),
    );
    gh.factory<_i963.FavProvider>(() => _i963.FavProvider(gh<_i460.FavRepo>()));
    gh.lazySingleton<_i273.AuthUseCase>(
      () => _i273.AuthUseCase(gh<_i1005.AuthRepository>()),
    );
    gh.factory<_i980.AddressProvider>(
      () => _i980.AddressProvider(gh<_i377.AddressRepo>()),
    );
    gh.factory<_i4.AuthProvider>(
      () =>
          _i4.AuthProvider(gh<_i273.AuthUseCase>(), gh<_i585.AppPreferences>()),
    );
    return this;
  }
}

class _$PreferenceModule extends _i468.PreferenceModule {}

class _$DioModule extends _i39.DioModule {}

class _$FirebaseModule extends _i33.FirebaseModule {}
