import 'dart:developer';

import 'package:e_com_user/features/favourite/data/model/favourite_model.dart';
import 'package:e_com_user/features/favourite/domain/repo/fav_repo.dart';
import 'package:e_com_user/general/utils/enums/app_state.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@injectable
class FavProvider with ChangeNotifier {
  final FavRepo repo;
  FavProvider(this.repo) {
    handleFetchFavs();
  }

  AppState addStateFavs = AppState.inital;
  AppState getFavsState = AppState.inital;

  String? error;

  List<FavModel> favsList = [];

  Future<void> handleAddOrRemoveFav({required FavModel model}) async {
    if (addStateFavs == AppState.loading) return;

    addStateFavs = AppState.loading;
    error = null;
    notifyListeners();

    try {
      final isFav = await checkFavsExist(productId: model.productId!);

      if (isFav) {
        await repo.removeFav(productId: model.productId!);
        favsList.removeWhere((element) => element.productId == model.productId);
        log("fav removed");
      } else {
        await repo.addFav(model: model);
        favsList.add(model);
        log("fav added");
      }

      addStateFavs = AppState.success;
    } catch (e) {
      addStateFavs = AppState.error;
      error = e.toString();
      log("error fav provider: $e");
    } finally {
      notifyListeners();
    }
  }

  Future<void> handleFetchFavs() async {
    if (getFavsState == AppState.loading) return;

    getFavsState = AppState.loading;
    error = null;
    notifyListeners();

    try {
      final favs = await repo.getFavs();

      favsList = favs;

      getFavsState = AppState.success;
      log("favs fetched");
    } catch (e) {
      getFavsState = AppState.error;
      error = e.toString();
      log("error fetching favs: $e");
    }

    notifyListeners();
  }

  Future<bool> checkFavsExist({required String productId}) async {
    return repo.isFavAlready(id: productId);
  }
}
