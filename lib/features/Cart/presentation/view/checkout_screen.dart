import 'package:e_com_user/features/Address/presentation/provider/address_provider.dart';
import 'package:e_com_user/features/Cart/data/model/cart_item_model.dart';
import 'package:e_com_user/features/Cart/presentation/widgets/address_list.dart';
import 'package:e_com_user/features/Cart/presentation/widgets/cart_item_widget.dart';
import 'package:e_com_user/features/Cart/presentation/widgets/check_out_sunmmury.dart';
import 'package:e_com_user/features/Cart/presentation/widgets/payment_method_bottom_sheet.dart';
import 'package:e_com_user/general/utils/enums/app_state.dart';
import 'package:e_com_user/general/utils/themes/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartItemModel> cartItems;

  const CheckoutScreen({super.key, required this.cartItems});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final addressProvider = context.read<AddressProvider>();
      if (addressProvider.fetchState != AppState.loading) {
        addressProvider.fetchAddress();
      }
    });
  }

  double _calculateSubtotal() {
    return widget.cartItems.fold(
      0,
      (sum, item) => sum + (item.productPrice * item.quantity),
    );
  }

  @override
  Widget build(BuildContext context) {
    final subtotal = _calculateSubtotal();
    const delivery = 40.0;
    final total = subtotal + delivery;

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
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(
                    title: 'Review Order',
                    trailingText:
                        '${widget.cartItems.length} ${widget.cartItems.length == 1 ? 'item' : 'items'}',
                  ),
                  const Gap(12),

                  Container(
                    decoration: BoxDecoration(
                      color: const Color(
                        0xFFF8FAFC,
                      ), 
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
                      itemCount: widget.cartItems.length,
                      separatorBuilder: (_, _) => const Padding(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: Divider(color: Color(0xFFE2E8F0), height: 1),
                      ),
                      itemBuilder: (context, index) {
                        final item = widget.cartItems[index];
                        return CartItemWidget(
                          isCartScreen: false,
                          onDecrement: () {},
                          onIncrement: () {},
                          name: item.productName,
                          price: '₹${item.productPrice.toStringAsFixed(0)}',
                          image: item.imageUrl,
                          quantity: item.quantity,
                        );
                      },
                    ),
                  ),

                  const Gap(28),

                  _buildSectionHeader(title: 'Delivery Address'),
                  const Gap(12),
                  const AddressList(),

                  const Gap(28),

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
                    child: CheckoutSummary(cartItems: widget.cartItems),
                  ),
                  const Gap(40),
                ],
              ),
            ),
          ),

          _buildActionStickyDock(context, total),
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

  Widget _buildActionStickyDock(BuildContext context, double total) {
    final addressProvider = context.watch<AddressProvider>();
    final hasSelectedAddress = addressProvider.selectedAddress != null;

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
            color: const Color(0xFF0F172A).withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
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
                '₹${total.toStringAsFixed(0)}',
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
                  backgroundColor: hasSelectedAddress
                      ? const Color(0xFF10B981)
                      : const Color(0xFF94A3B8),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: hasSelectedAddress
                    ? () {
                        _showPaymentMethodBottomSheet(context, total);
                      }
                    : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please select a delivery address first.'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
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

  void _showPaymentMethodBottomSheet(BuildContext context, double total) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return PaymentMethodBottomSheet(total: total);
      },
    );
  }
}
