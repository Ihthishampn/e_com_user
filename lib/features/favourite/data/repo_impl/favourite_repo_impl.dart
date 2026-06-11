import 'package:e_com_user/features/favourite/data/model/favourite_model.dart';
import 'package:e_com_user/features/favourite/data/use_case/fav_use_case.dart';
import 'package:e_com_user/features/favourite/domain/repo/fav_repo.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: FavRepo)
class FavouriteRepoImpl implements FavRepo {
  final FavUseCase remote;
  FavouriteRepoImpl(this.remote);
  @override
  Future<void> addFav({required FavModel model}) async {
    return await remote.addFavUseCase(model: model);
  }

  @override
  Future<void> removeFav({required String productId}) async {
    remote.reoveFavUseCase(productId: productId);
  }

  @override
  Future<List<FavModel>> getFavs() async {
    return await remote.getFavs();
  }

  @override
  Future<bool> isFavAlready({required String id}) {
    return remote.isFav(id:id);
  }
}
