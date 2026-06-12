class CartItemModel {
  final String productId;
  final String productName;
  final int quantity;
  final double productPrice;
  final String imageUrl;
  final int availableStock;

  const CartItemModel({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.productPrice,
    required this.imageUrl,
    required this.availableStock,
  });

  CartItemModel copyWith({
    int? quantity,
    int? availableStock,
  }) {
    return CartItemModel(
      productId: productId,
      productName: productName,
      quantity: quantity ?? this.quantity,
      productPrice: productPrice,
      imageUrl: imageUrl,
      availableStock: availableStock ?? this.availableStock,
    );
  }

  double get totalItemPrice => quantity * productPrice;

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      productId: json['productId'],
      productName: json['productName'],
      quantity: json['quantity'],
      productPrice: (json['productPrice'] as num).toDouble(),
      imageUrl: json['imageUrl'],
      availableStock: json['availableStock'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'productPrice': productPrice,
      'imageUrl': imageUrl,
      'availableStock': availableStock,
    };
  }
}