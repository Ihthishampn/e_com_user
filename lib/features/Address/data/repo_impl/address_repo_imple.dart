import 'package:e_com_user/features/Address/data/model/address_model.dart';
import 'package:e_com_user/features/Address/data/use_case/address_use_case.dart';
import 'package:e_com_user/features/Address/domain/repo/address_repo.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AddressRepo)
class AddressRepoImple implements AddressRepo {
  final AddressUseCase useCase;
  AddressRepoImple(this.useCase);
  @override
  Future<void> addAddress({required AddressModel address}) async {
     await useCase.addAddressUseCase(model: address);
  }

  @override
  Future<List<AddressModel>> fetchAddressModel() async {
    return await useCase.fetchAddressUseCase();
  }

  @override
  Future<void> removeAddress({required String id}) async {
    await useCase.removeAddressUseCase(id: id);
  }
}
