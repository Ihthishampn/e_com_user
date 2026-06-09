import 'package:e_com_user/features/Category/data/model/category_model.dart';

abstract class CategoryRepo {
  Stream<List<CategoryModel>> fetchCategories();
}
  