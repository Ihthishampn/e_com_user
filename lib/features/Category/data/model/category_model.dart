class CategoryModel {
  final String id;
  final String categoryName;
  final String imageUrl;
  final List<String> searchKeywords;

  CategoryModel({
    required this.categoryName,
    required this.imageUrl,
    required this.id,
    required this.searchKeywords,
  });

  // from

  factory CategoryModel.fromFirebase(
    Map<String, dynamic> fromFirebase,
    String id,
  ) {
    return CategoryModel(
      id: id,
      categoryName: fromFirebase["name"] ?? "",
      imageUrl: fromFirebase["imageUrl"] ?? "",
      searchKeywords: List<String>.from(fromFirebase["searchKeywords"] ?? []),
    );
  }
}
