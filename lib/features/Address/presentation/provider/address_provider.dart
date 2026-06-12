import 'dart:developer';

import 'package:e_com_user/features/Address/data/model/address_model.dart';
import 'package:e_com_user/features/Address/domain/repo/address_repo.dart';
import 'package:e_com_user/general/utils/enums/app_state.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddressProvider with ChangeNotifier {
  final AddressRepo repo;

  AddressProvider(this.repo);

  List<AddressModel> addressList = [];

  AppState fetchState = AppState.inital;
  AppState addState = AppState.inital;
  AppState removeState = AppState.inital;

  Future<void> handleAddAddress({required AddressModel address}) async {
    if (addState == AppState.loading) return;

    addState = AppState.loading;
    notifyListeners();

    try {
      await repo.addAddress(address: address);

      addressList.add(address);

      addState = AppState.success;
      log("success : add address");
    } catch (e) {
      addState = AppState.error;
      log("error while add address provider : $e");
    }

    notifyListeners();
  }

  Future<void> removeAddress({required String id}) async {
    if (removeState == AppState.loading) return;

    removeState = AppState.loading;
    notifyListeners();

    try {
      await repo.removeAddress(id: id);

      addressList.removeWhere((element) => element.id == id);

      removeState = AppState.success;
      log("success : remove address");
    } catch (e) {
      removeState = AppState.error;
      log("error while remove address provider : $e");
    }

    notifyListeners();
  }

  Future<void> fetchAddress() async {
    if (fetchState == AppState.loading) return;

    fetchState = AppState.loading;
    notifyListeners();

    try {
      addressList = await repo.fetchAddressModel();

      fetchState = AppState.success;
      log("success : fetch address");
    } catch (e) {
      fetchState = AppState.error;
      log("error while fetch address provider : $e");
    }

    notifyListeners();
  }
}
