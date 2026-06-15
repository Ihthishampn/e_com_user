import 'package:e_com_user/features/Cart/data/model/cart_item_model.dart';
import 'package:e_com_user/features/Cart/presentation/provider/cart_provider.dart';
import 'package:e_com_user/features/favourite/data/model/favourite_model.dart';
import 'package:e_com_user/features/favourite/presentation/provider/fav_provider.dart';
import 'package:flutter/material.dart';
import 'package:e_com_user/general/utils/themes/app_colors.dart';
import 'package:e_com_user/general/utils/themes/app_text_style.dart';
import 'package:provider/provider.dart';

class FavProductCard extends StatelessWidget {
  final FavModel model;
  const FavProductCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final hasVariants = model.variants.isNotEmpty;
    final mainVariant = hasVariants ? model.variants.first : null;

    final sellingPrice = mainVariant?.sellingPrice ?? 0.0;
    final mrp = mainVariant?.mrp ?? 0.0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            flex: 6,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  child: Image.network(
                    model.images.isNotEmpty
                        ? model.images.first
                        : "https://via.placeholder.com/150",
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.contain,
                  ),
                ),

                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    height: 34,
                    width: 34,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: IconButton(
                      onPressed: () {
                        context.read<FavProvider>().handleAddOrRemoveFav(
                          model: model,
                        );
                      },
                      icon: Icon(Icons.favorite, color: Colors.red, size: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.productName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Row(
                    children: [
                      Text(
                        "₹${sellingPrice.toStringAsFixed(0)}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 6),

                      if (mrp > sellingPrice)
                        Text(
                          "₹${mrp.toStringAsFixed(0)}",
                          style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                            fontSize: 11,
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 1),

                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        model.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Cart button — matches the existing Home ProductCard flow
                  Consumer<CartProvider>(
                    builder: (context, cart, child) {
                      final isInCart = cart.cartList.any(
                        (element) => element.productId == model.productId,
                      );

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: SizedBox(
                          height: 22,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (!isInCart) {
                                cart.addToCart(
                                  cartItem: CartItemModel(
                                    productId: model.productId ?? "",
                                    productName: model.productName,
                                    quantity: 1,
                                    productPrice: sellingPrice,
                                    imageUrl: model.images.isNotEmpty
                                        ? model.images.first
                                        : "",
                                    availableStock: mainVariant?.stock ?? 0,
                                  ),
                                );
                              } else {
                                final bool? shouldRemove =
                                    await showDialog<bool>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15),
                                      ),
                                      title: Row(
                                        children: [
                                          const Icon(
                                            Icons.remove_shopping_cart,
                                            color: Colors.red,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            "Remove from Cart",
                                            style: AppTextStyles.titleMedium
                                                .copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.lightBlack,
                                            ),
                                          ),
                                        ],
                                      ),
                                      content: Text(
                                        "Are you sure you want to remove this product from your cart?",
                                        style:
                                            AppTextStyles.bodyMedium.copyWith(
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          style: TextButton.styleFrom(
                                            foregroundColor:
                                                Colors.grey.shade600,
                                          ),
                                          child: const Text(
                                            "Cancel",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            elevation: 0,
                                          ),
                                          child: const Text(
                                            "Remove",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                      backgroundColor: Colors.white,
                                    );
                                  },
                                );

                                if (shouldRemove == true) {
                                  await cart.removeFromCart(
                                    productId: model.productId!,
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isInCart
                                  ? Colors.green
                                  : AppColors.primaryColor,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              isInCart ? "✓ In Cart" : "Add to Cart",
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
