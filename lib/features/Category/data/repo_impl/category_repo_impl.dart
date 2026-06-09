import 'package:e_com_user/features/Category/data/model/category_model.dart';
import 'package:e_com_user/features/Category/data/use_case/category_use_case.dart';
import 'package:e_com_user/features/Category/domain/repo/category_repo.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: CategoryRepo)
class CategoryRepoImpl implements CategoryRepo {
  final CategoryUseCase useCase;
  CategoryRepoImpl(this.useCase);
  @override
  Stream<List<CategoryModel>> fetchCategories() {
    return useCase.fetchCatgorys();
  }
}
