import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_com_user/features/Category/data/model/category_model.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class CategoryUseCase {
  final FirebaseFirestore firebaseFirestore;
  CategoryUseCase(this.firebaseFirestore);

  Stream<List<CategoryModel>> fetchCatgorys() {
    return firebaseFirestore.collection("categories").snapshots().map((
      event,
    ) {
      return event.docs.map((e) {
      return  CategoryModel.fromFirebase(e.data(), e.id);
      }).toList();
    });
 
  }
}
