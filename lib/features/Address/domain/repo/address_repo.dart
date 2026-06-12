import 'package:e_com_user/features/Address/data/model/address_model.dart';

abstract class AddressRepo {
  Future<void> addAddress({required AddressModel address});
  Future<List<AddressModel>> fetchAddressModel();
  Future<void> removeAddress({required String id});
}
