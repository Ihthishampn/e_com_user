import 'package:e_com_user/features/favourite/data/model/favourite_model.dart';

abstract class FavRepo {
  Future<void> addFav({required FavModel model});

  Future<void> removeFav({required String productId});

  Future<List<FavModel>> getFavs();

  Future<bool> isFavAlready({required String id});
}
