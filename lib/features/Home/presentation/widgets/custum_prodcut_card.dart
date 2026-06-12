import 'dart:developer';

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

                        GestureDetector(
                          onTap: () {
                            log("clicked 2");
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.shopping_cart_outlined,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
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
