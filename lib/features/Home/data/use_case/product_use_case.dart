import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_com_user/features/Home/data/model/product_model.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ProductUseCase {
  final FirebaseFirestore firebaseFirestore;
  ProductUseCase(this.firebaseFirestore);
  Stream<List<ProductModel>> getProducts() {
    return firebaseFirestore.collection("products").snapshots().map((event) {
      return event.docs.map((e) {
        return ProductModel.fromMap(e.data(), e.id);
      }).toList();
    });
  }

  Stream<List<ProductModel>> getProductsByCategory(String categoryId) {
    if (categoryId.isEmpty || categoryId == 'all') return getProducts();

    return firebaseFirestore
        .collection('products')
        .where('categoryId', isEqualTo: categoryId)
        .snapshots()
        .map(
          (event) => event.docs
              .map((e) => ProductModel.fromMap(e.data(), e.id))
              .toList(),
        );
  }

  Stream<List<ProductModel>> searchProducts(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return getProducts();
    final parts = q.split(RegExp(r"\s+"));
    final tokens = parts.where((p) => p.isNotEmpty).take(10).toList();

    if (tokens.isEmpty) return getProducts();

    return firebaseFirestore
        .collection('products')
        .where('searchKeywords', arrayContainsAny: tokens)
        .snapshots()
        .map(
          (event) => event.docs
              .map((e) => ProductModel.fromMap(e.data(), e.id))
              .toList(),
        );
  }

  Stream<List<ProductModel>> searchProductsByCategory(
    String query,
    String categoryId,
  ) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return getProductsByCategory(categoryId);
    final parts = q.split(RegExp(r"\s+"));
    final tokens = parts.where((p) => p.isNotEmpty).take(10).toList();

    if (tokens.isEmpty) return getProductsByCategory(categoryId);

    return firebaseFirestore
        .collection('products')
        .where('categoryId', isEqualTo: categoryId)
        .where('searchKeywords', arrayContainsAny: tokens)
        .snapshots()
        .map(
          (event) => event.docs
              .map((e) => ProductModel.fromMap(e.data(), e.id))
              .toList(),
        );
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchProductsPage({
    int limit = 20,
    DocumentSnapshot? startAfter,
  }) async {
    var q = firebaseFirestore
        .collection('products')
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .withConverter<Map<String, dynamic>>(
          fromFirestore: (snap, _) =>
              Map<String, dynamic>.from(snap.data() ?? {}),
          toFirestore: (map, _) => map,
        );

    if (startAfter != null) q = q.startAfterDocument(startAfter);

    final snap = await q.get();
    return snap;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchProductsByCategoryPage({
    required String categoryId,
    int limit = 20,
    DocumentSnapshot? startAfter,
  }) async {
    var q = firebaseFirestore
        .collection('products')
        .where('categoryId', isEqualTo: categoryId)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .withConverter<Map<String, dynamic>>(
          fromFirestore: (snap, _) =>
              Map<String, dynamic>.from(snap.data() ?? {}),
          toFirestore: (map, _) => map,
        );

    if (startAfter != null) q = q.startAfterDocument(startAfter);

    final snap = await q.get();
    return snap;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> searchProductsPage({
    required String query,
    int limit = 20,
    DocumentSnapshot? startAfter,
  }) async {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) {
      return fetchProductsPage(limit: limit, startAfter: startAfter);
    }

    final parts = q.split(RegExp(r"\s+"));
    final tokens = parts.where((p) => p.isNotEmpty).take(10).toList();

    if (tokens.isEmpty) {
      return fetchProductsPage(limit: limit, startAfter: startAfter);
    }

    var queryRef = firebaseFirestore
        .collection('products')
        .where('searchKeywords', arrayContainsAny: tokens)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .withConverter<Map<String, dynamic>>(
          fromFirestore: (snap, _) =>
              Map<String, dynamic>.from(snap.data() ?? {}),
          toFirestore: (map, _) => map,
        );

    if (startAfter != null) queryRef = queryRef.startAfterDocument(startAfter);

    final snap = await queryRef.get();
    return snap;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> searchProductsByCategoryPage({
    required String query,
    required String categoryId,
    int limit = 20,
    DocumentSnapshot? startAfter,
  }) async {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) {
      return fetchProductsByCategoryPage(
        categoryId: categoryId,
        limit: limit,
        startAfter: startAfter,
      );
    }

    final parts = q.split(RegExp(r"\s+"));
    final tokens = parts.where((p) => p.isNotEmpty).take(10).toList();

    if (tokens.isEmpty) {
      return fetchProductsByCategoryPage(
        categoryId: categoryId,
        limit: limit,
        startAfter: startAfter,
      );
    }

    var queryRef = firebaseFirestore
        .collection('products')
        .where('categoryId', isEqualTo: categoryId)
        .where('searchKeywords', arrayContainsAny: tokens)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .withConverter<Map<String, dynamic>>(
          fromFirestore: (snap, _) =>
              Map<String, dynamic>.from(snap.data() ?? {}),
          toFirestore: (map, _) => map,
        );

    if (startAfter != null) queryRef = queryRef.startAfterDocument(startAfter);

    final snap = await queryRef.get();
    return snap;
  }
}
