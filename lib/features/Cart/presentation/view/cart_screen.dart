import 'package:e_com_user/general/utils/themes/app_colors.dart';
import 'package:e_com_user/general/utils/themes/app_text_style.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.containerGrey,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        toolbarHeight: 30,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Cart",
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
        ),
      ),

      bottomNavigationBar: Container(
        decoration: const BoxDecoration(color: Colors.white),
        padding: const EdgeInsets.only(bottom: 90, left: 18, right: 18, top: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _priceRow("Subtotal", "₹4,995"),
            const SizedBox(height: 6),

            _priceRow("Delivery", "₹40"),
            const Divider(height: 20),

            _priceRow("Total", "₹5,035", isTotal: true),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,

              height: 42,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    const Color.fromARGB(255, 49, 113, 51),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  "Proceed to Checkout",
                  style: TextStyle(color: AppColors.white),
                ),
              ),
            ),
          ],
        ),
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    "https://picsum.photos/200",
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Wireless Headphones",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.titleSmall.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        "₹999",
                        style: AppTextStyles.titleMedium.copyWith(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Row(
                        children: [
                          Container(
                            height: 28,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.textFieldBorder,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 26,
                                  height: 26,
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    iconSize: 14,
                                    onPressed: () {},
                                    icon: const Icon(Icons.remove),
                                  ),
                                ),

                                const Text(
                                  "1",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),

                                SizedBox(
                                  width: 26,
                                  height: 26,
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    iconSize: 14,
                                    onPressed: () {},
                                    icon: const Icon(Icons.add),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Spacer(),

                          IconButton(
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                            onPressed: () {},
                            icon: const Icon(Icons.delete_outline, size: 20),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  static Widget _priceRow(String title, String amount, {bool isTotal = false}) {
    return Row(
      children: [
        Text(
          title,
          style: isTotal
              ? AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w700)
              : AppTextStyles.bodyMedium,
        ),
        const Spacer(),
        Text(
          amount,
          style: isTotal
              ? AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryColor,
                )
              : AppTextStyles.bodyMedium,
        ),
      ],
    );
  }
}
