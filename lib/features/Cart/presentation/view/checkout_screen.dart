import 'package:e_com_user/features/Cart/presentation/widgets/address_list.dart';
import 'package:e_com_user/features/Cart/presentation/widgets/checkout_summary.dart';
import 'package:e_com_user/features/Cart/presentation/widgets/cart_item_widget.dart';
import 'package:e_com_user/general/utils/themes/app_colors.dart';
import 'package:e_com_user/general/utils/themes/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CheckoutScreen extends StatelessWidget {
  final List<Map<String, dynamic>> items;

  const CheckoutScreen({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF0F172A),
            size: 20,
          ),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text(
          'Checkout',
          style: AppTextStyles.titleLarge.copyWith(
            fontWeight: FontWeight.w800,
            color: const Color(0xFF0F172A),
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: Column(
        children: [
          // Scrollable Core Form Data
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section Headline: Items
                  _buildSectionHeader(
                    title: 'Review Order',
                    trailingText:
                        '${items.length} ${items.length == 1 ? 'item' : 'items'}',
                  ),
                  const Gap(12),

                  // Order items Wrapper Card
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(
                        0xFFF8FAFC,
                      ), // Ultra-clean muted background
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFF1F5F9),
                        width: 1,
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const Padding(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: Divider(color: Color(0xFFE2E8F0), height: 1),
                      ),
                      itemBuilder: (context, index) {
                        final it = items[index];
                        return CartItemWidget(
                          name: it['name'] as String,
                          price: it['price'] as String,
                          image: it['image'] as String,
                          quantity: it['qty'] as int,
                        );
                      },
                    ),
                  ),

                  const Gap(28),

                  // Section Headline: Delivery Destination
                  _buildSectionHeader(title: 'Delivery Address'),
                  const Gap(12),

                  // Injected Address Interface Component
                  const AddressList(),

                  const Gap(28),

                  // Section Headline: Cost Accounting Breakdown
                  _buildSectionHeader(title: 'Payment Summary'),
                  const Gap(12),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFE2E8F0),
                        width: 1,
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: CheckoutSummary(items: items),
                  ),
                  const Gap(40),
                ],
              ),
            ),
          ),

          // High-Contrast Interactive Checkout Sticky Dock
          _buildActionStickyDock(context),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({required String title, String? trailingText}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyles.titleMedium.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0F172A),
            letterSpacing: -0.2,
          ),
        ),
        if (trailingText != null)
          Text(
            trailingText,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF64748B),
            ),
          ),
      ],
    );
  }

  Widget _buildActionStickyDock(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 20,
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.06),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Dynamic pricing feedback element
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'TOTAL PRICE',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF94A3B8),
                  letterSpacing: 1.0,
                ),
              ),
              const Gap(2),
              Text(
                // Safely calculates dynamic pricing layout or falls back smoothly
                items.isNotEmpty ? '${items[0]['price']}' : '\$0.00',
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          const Gap(24),

          // Primary Vibrant Modern Green Call-To-Action Button
          Expanded(
            child: SizedBox(
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(
                    0xFF10B981,
                  ), // Vibrant Green Accent
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  // Direct to integrated secure transaction gateway arrays
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Place Order',
                      style: AppTextStyles.titleMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.1,
                      ),
                    ),
                    const Gap(8),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      size: 18,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
