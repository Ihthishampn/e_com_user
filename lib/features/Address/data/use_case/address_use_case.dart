import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_com_user/features/Address/data/model/address_model.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AddressUseCase {
  final FirebaseFirestore firebaseFirestore;
  AddressUseCase(this.firebaseFirestore);

  Future<List<AddressModel>> fetchAddressUseCase() async {
    try {
      final data = await firebaseFirestore.collection("Address").get();
      return data.docs
          .map((e) => AddressModel.fromJson(e.data(), e.id))
          .toList();
    } catch (e) {
      log("error from address use case fetching : $e");
      throw ("exception form fetchinh address");
    }
  }

  Future<void> addAddressUseCase({required AddressModel model}) async {
    try {
      await firebaseFirestore
          .collection("Address")
          .doc(model.id)
          .set(model.toFirebase());
    } catch (e) {
      log("from use case add address :$e");
    }
  }

  Future<void> removeAddressUseCase({required String id}) async {
    try {
      await firebaseFirestore.collection("Address").doc(id).delete();

    } catch (e) {
      log("from use case remove address :$e");
    }
  }
}
