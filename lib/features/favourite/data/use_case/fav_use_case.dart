import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_com_user/features/favourite/data/model/favourite_model.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class FavUseCase {
  final FirebaseFirestore firebaseFirestore;
  FavUseCase(this.firebaseFirestore);

  Future<void> addFavUseCase({required FavModel model}) async {
    try {
      await firebaseFirestore
          .collection("favourites")
          .doc(model.productId)
          .set(model.toMap());
    } on FirebaseException catch (fe) {
      log("error from firebase exception (fav usecase) : $fe");
    } catch (e) {
      log("error from fav usecase : $e");
    }
  }

  Future<List<FavModel>> getFavs() async {
    try {
      final favs = await firebaseFirestore.collection("favourites").get();
      return favs.docs.map((e) {
        return FavModel.fromMap(e.data(), e.id);
      }).toList();
    } catch (e) {
      log("failed while geting favs from firebase");
      throw ("$e");
    }
  }

  Future<void> reoveFavUseCase({required String productId}) async {
    try {
      await firebaseFirestore.collection("favourites").doc(productId).delete();
    } catch (e) {
      log("failed while removing favs to firebase");
      throw ("$e");
    }
  }

  Future<bool> isFav({required String id}) async {
    try {
      final fav = await firebaseFirestore
          .collection("favourites")
          .where("id", isEqualTo: id)
          .limit(1)
          .get();
      return fav.docs.isNotEmpty;
    } catch (e) {
      log("failed while checking favs existance ");
      throw ("$e");
    }
  }
}
