import 'package:e_com_user/features/Home/data/model/product_model.dart' as pm;
import 'package:e_com_user/general/utils/themes/app_colors.dart';
import 'package:e_com_user/general/utils/themes/app_text_style.dart';
import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatefulWidget {
  final pm.ProductModel product;

  const ProductDetailsScreen({required this.product, super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _selectedImageIndex = 0;
  pm.ProductVariant? _selectedVariant;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    if (widget.product.variants.isNotEmpty) {
      _selectedVariant = widget.product.variants.first;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final hasImages = product.images.isNotEmpty;
    
    final sellingPrice = _selectedVariant?.sellingPrice ?? 0.0;
    final mrp = _selectedVariant?.mrp ?? 0.0;
    final isOutOfStock = (_selectedVariant?.stock ?? 0) <= 0;

    return Scaffold(
      backgroundColor: AppColors.bgWhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.lightBlack),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share_outlined, color: AppColors.lightBlack),
            onPressed: () {},
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.42,
                  width: double.infinity,
                  color: AppColors.white,
                  child: hasImages
                      ? PageView.builder(
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() {
                              _selectedImageIndex = index;
                            });
                          },
                          itemCount: product.images.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(top: kToolbarHeight + 20, bottom: 20),
                              child: Image.network(
                                product.images[index],
                                fit: BoxFit.contain,
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Image.network(
                            "https://via.placeholder.com/400x300.png?text=No+Image",
                            fit: BoxFit.contain,
                          ),
                        ),
                ),
                
                if (product.isHot)
                  Positioned(
                    top: kToolbarHeight + 20,
                    left: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.local_fire_department, size: 16, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                            "HOT",
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                if (hasImages && product.images.length > 1)
                  Positioned(
                    bottom: 15,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        product.images.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 6,
                          width: _selectedImageIndex == index ? 18 : 6,
                          decoration: BoxDecoration(
                            color: _selectedImageIndex == index
                                ? AppColors.primaryColor
                                : Colors.grey.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          product.productName,
                          style: AppTextStyles.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.lightBlack,
                            fontSize: 22,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.amber.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star_rounded, size: 18, color: Colors.amber),
                            const SizedBox(width: 2),
                            Text(
                              product.rating > 0 ? product.rating.toString() : "4.8",
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.amber[900],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  if (product.shortNote.isNotEmpty) ...[
                    Text(
                      product.shortNote,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.lightBlack.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        "₹${sellingPrice.toStringAsFixed(0)}",
                        style: AppTextStyles.titleMedium.copyWith(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (mrp > sellingPrice) ...[
                        Text(
                          "₹${mrp.toStringAsFixed(0)}",
                          style: AppTextStyles.bodyMedium.copyWith(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "${(((mrp - sellingPrice) / mrp) * 100).toStringAsFixed(0)}% OFF",
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const Divider(height: 32, thickness: 1),

                    if (product.variants.isNotEmpty) ...[
                    Text(
                      "Select Unit / Option",
                      style: AppTextStyles.titleSmall.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.lightBlack,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 46,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: product.variants.length,
                        itemBuilder: (context, index) {
                          final variantItem = product.variants[index];
                          final isSelected = _selectedVariant == variantItem;
                          
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedVariant = variantItem;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.only(right: 12),
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.primaryColor : AppColors.bgWhite,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected ? AppColors.primaryColor : Colors.grey.withValues(alpha: 0.2),
                                  width: 1.5,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "${variantItem.variant} ${variantItem.unit}",
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: isSelected ? AppColors.white : AppColors.lightBlack,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // 4. EXTENDED SPECIFICATIONS AND DETAILS BLOCK
                  if (product.details.isNotEmpty) ...[
                    Text(
                      "Product Specifications",
                      style: AppTextStyles.titleSmall.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.lightBlack,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.bgWhite,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Column(
                        children: product.details.map((detail) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    detail.heading,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.lightBlack.withValues(alpha: 0.5),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Text(
                                    detail.content,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.lightBlack,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // 5. ADDITIONAL NOTE SECTION
                  if (product.additionalNote.isNotEmpty) ...[
                    Text(
                      "Important Note",
                      style: AppTextStyles.titleSmall.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.lightBlack,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.amber.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.amber.withValues(alpha: 0.2)),
                      ),
                      child: Text(
                        product.additionalNote,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.lightBlack.withValues(alpha: 0.8),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: isOutOfStock ? null : () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: isOutOfStock ? Colors.grey[300] : AppColors.primaryColor,
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  isOutOfStock ? "OUT OF STOCK" : "ADD TO CART",
                  style: AppTextStyles.titleSmall.copyWith(
                    color: isOutOfStock ? Colors.grey[600] : AppColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}