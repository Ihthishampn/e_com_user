import 'package:e_com_user/features/Home/data/model/product_model.dart' as pm;
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
    return Container(
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
                        frameBuilder:
                            (context, child, frame, wasSynchronouslyLoaded) {
                              if (wasSynchronouslyLoaded) return child;
                              return AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                child: frame != null
                                    ? child
                                    : Center(
                                        child: SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  AppColors.primaryColor,
                                                ),
                                          ),
                                        ),
                                      ),
                              );
                            },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: AppColors.primaryColor.withOpacity(0.5),
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppColors.bgWhite,
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              color: AppColors.lightBlack.withOpacity(0.3),
                              size: 28,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),

                product.isHot
                    ? Positioned(
                        top: 8, // Cleaned up alignment layout
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
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.local_fire_department,
                                size: 12,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
                
                Positioned(
                  top: 8,
                  right: 8,
                  child: Consumer<FavProvider>(
                    builder: (context, pro, child) {
                      final isFav = pro.favsList.any(
                        (element) => element.productId == product.productId,
                      );
                      return Container(
                        // Reduced size by dropping padding entirely and setting tight constraints
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Colors.white, // Solid white background so it's always visible
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1), // Slightly more pronounced shadow
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () async {
                            await pro.handleAddFav(
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
                            isFav ? Icons.favorite : Icons.favorite_border_rounded,
                            size: 16, // Smaller, cute icon profile matching the smaller circle
                            color: isFav ? Colors.red : AppColors.lightBlack.withOpacity(0.6), // Contrast grey tint when unselected
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // DETAILS
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

                  Text(
                    product.variants.isNotEmpty
                        ? "₹${product.variants.first.sellingPrice.toStringAsFixed(0)}"
                        : "₹0",
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryColor,
                    ),
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
                        "4.8",
                        style: AppTextStyles.bodySmall.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const Spacer(),

                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.shopping_cart_outlined,
                          size: 18,
                          color: Colors.white,
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
    );
  }
}