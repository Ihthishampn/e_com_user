import 'package:e_com_user/features/favourite/data/model/favourite_model.dart';
import 'package:e_com_user/features/favourite/presentation/provider/fav_provider.dart';
import 'package:e_com_user/general/utils/themes/app_colors.dart';
import 'package:flutter/material.dart';
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
                        "\$${sellingPrice.toStringAsFixed(0)}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 6),

                      if (mrp > sellingPrice)
                        Text(
                          "\$${mrp.toStringAsFixed(0)}",
                          style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                            fontSize: 11,
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 1),

                  const Row(
                    children: [
                      Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                      SizedBox(width: 4),
                      Text(
                        "4.8",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: SizedBox(
                      height: 22,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Add to Cart",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
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
