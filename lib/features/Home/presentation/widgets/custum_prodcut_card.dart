
import 'package:e_com_user/features/Cart/data/model/cart_item_model.dart';
import 'package:e_com_user/features/Cart/presentation/provider/cart_provider.dart';
import 'package:e_com_user/features/Home/data/model/product_model.dart' as pm;
import 'package:e_com_user/features/Home/presentation/view/product_details_screen.dart';
import 'package:e_com_user/features/favourite/data/model/favourite_model.dart';
import 'package:e_com_user/features/favourite/presentation/provider/fav_provider.dart';
import 'package:e_com_user/general/utils/themes/app_colors.dart';
import 'package:e_com_user/general/utils/themes/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatelessWidget {
  final pm.ProductModel product;

  const ProductCard({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    final hasVariant = product.variants.isNotEmpty;
    final mainVariant = hasVariant ? product.variants.first : null;

    final sellingPrice = mainVariant?.sellingPrice ?? 0.0;
    final mrp = mainVariant?.mrp ?? 0.0;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
            pageBuilder: (context, animation, secondaryAnimation) {
              return ProductDetailsScreen(product: product);
            },
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 6,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: Container(
                        color: AppColors.bgWhite,
                        alignment: Alignment.center,
                        child: Image.network(
                          product.images.isNotEmpty
                              ? product.images.first
                              : "https://via.placeholder.com/400x300.png?text=Product",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),

                  // HOT BADGE
                  if (product.isHot)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.local_fire_department,
                          size: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),

                  // FAV ICON
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Consumer<FavProvider>(
                      builder: (context, pro, child) {
                        final isFav = pro.favsList.any(
                          (e) => e.productId == product.productId,
                        );

                        return Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () async {
                              await pro.handleAddOrRemoveFav(
                                model: FavModel(
                                  productId: product.productId,
                                  productName: product.productName,
                                  shortNote: product.shortNote,
                                  categoryId: product.categoryId,
                                  additionalNote: product.additionalNote,
                                  createdAt: product.createdAt,
                                  details: product.details
                                      .map(
                                        (d) => ProductDetail(
                                          heading: d.heading,
                                          content: d.content,
                                        ),
                                      )
                                      .toList(),
                                  images: product.images,
                                  isHot: product.isHot,
                                  rating: product.rating,
                                  searchKeywords: product.searchKeywords,
                                  variants: product.variants
                                      .map(
                                        (v) => ProductVariant(
                                          unit: v.unit,
                                          variant: v.variant,
                                          mrp: v.mrp,
                                          sellingPrice: v.sellingPrice,
                                          stock: v.stock,
                                        ),
                                      )
                                      .toList(),
                                ),
                              );
                            },
                            icon: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              size: 18,
                              color: isFav
                                  ? Colors.red
                                  : AppColors.lightBlack.withValues(alpha: 0.6),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.productName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.titleSmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.lightBlack,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: [
                        Text(
                          "₹${sellingPrice.toStringAsFixed(0)}",
                          style: AppTextStyles.titleMedium.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryColor,
                          ),
                        ),

                        const SizedBox(width: 6),

                        if (mrp > sellingPrice)
                          Text(
                            "₹${mrp.toStringAsFixed(0)}",
                            style: AppTextStyles.bodySmall.copyWith(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 18,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          product.rating.toString(),
                          style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const Spacer(),

                        Consumer<CartProvider>(
                          builder: (context, cart, child) {
                            final isInCart = cart.cartList.any(
                              (element) =>
                                  element.productId == product.productId,
                            );

                            return GestureDetector(
                              onTap: () async {
                                if (!isInCart) {
                                  cart.addToCart(
                                    cartItem: CartItemModel(
                                      productId: product.productId ?? "No name",
                                      productName: product.productName,
                                      quantity: 1,
                                      productPrice: sellingPrice,
                                      imageUrl: product.images.first,
                                      availableStock: mainVariant?.stock ?? 0,
                                    ),
                                  );
                                } else {
                                  final bool? shouldRemove = await showDialog<bool>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        title: Row(
                                          children: [
                                            const Icon(Icons.remove_shopping_cart, color: Colors.red),
                                            const SizedBox(width: 8),
                                            Text(
                                              "Remove from Cart",
                                              style: AppTextStyles.titleMedium.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.lightBlack,
                                              ),
                                            ),
                                          ],
                                        ),
                                        content: Text(
                                          "Are you sure you want to remove this product from your cart?",
                                          style: AppTextStyles.bodyMedium.copyWith(
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(false),
                                            style: TextButton.styleFrom(
                                              foregroundColor: Colors.grey.shade600,
                                            ),
                                            child: const Text("Cancel", style: TextStyle(fontWeight: FontWeight.w600)),
                                          ),
                                          ElevatedButton(
                                            onPressed: () => Navigator.of(context).pop(true),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              elevation: 0,
                                            ),
                                            child: const Text("Remove", style: TextStyle(fontWeight: FontWeight.bold)),
                                          ),
                                        ],
                                        backgroundColor: Colors.white,
                                      );
                                    },

                                  );


                                  if (shouldRemove == true) {

                                    await cart.removeFromCart(

                                      productId: product.productId!,

                                    );

                                  }

                                }

                              },
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: isInCart
                                      ? Colors.green
                                      : AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  isInCart
                                      ? Icons.shopping_cart
                                      : Icons.shopping_cart_outlined,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
