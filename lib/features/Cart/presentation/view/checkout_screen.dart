import 'package:e_com_user/features/Address/presentation/provider/address_provider.dart';
import 'package:e_com_user/features/Cart/data/model/cart_item_model.dart';
import 'package:e_com_user/features/Cart/presentation/provider/cart_provider.dart';
import 'package:e_com_user/features/Cart/presentation/widgets/address_list.dart';
import 'package:e_com_user/features/Cart/presentation/widgets/cart_item_widget.dart';
import 'package:e_com_user/features/Cart/presentation/widgets/check_out_sunmmury.dart';
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
                        '${widget.cartItems.length} ${widget.cartItems.length == 1 ? 'item' : 'items'}',
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

          // High-Contrast Interactive Checkout Sticky Dock
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
        return Consumer<CartProvider>(
          builder: (context, cartProvider, child) {
            final selectedMethod = cartProvider.selectedPaymentMethod;

            return SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 16,
                  bottom: MediaQuery.of(context).padding.bottom + 16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 48,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const Gap(16),
                    Text(
                      'Select Payment Method',
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    const Gap(16),
                    _buildPaymentOption(
                      context: context,
                      icon: Icons.payments_outlined,
                      title: 'Cash on Delivery (COD)',
                      subtitle: 'Pay with cash upon delivery',
                      isSelected: selectedMethod == 'Cash on Delivery',
                      onTap: () {
                        cartProvider.setPaymentMethod('Cash on Delivery');
                      },
                    ),
                    const Gap(12),
                    _buildPaymentOption(
                      context: context,
                      icon: Icons.account_balance_wallet_outlined,
                      title: 'UPI (Paytm, PhonePe, Google Pay)',
                      subtitle: 'Instant transfer using your UPI app',
                      isSelected: selectedMethod == 'UPI',
                      onTap: () {
                        cartProvider.setPaymentMethod('UPI');
                      },
                    ),
                    const Gap(12),
                    _buildPaymentOption(
                      context: context,
                      icon: Icons.credit_card_outlined,
                      title: 'Credit / Debit Card',
                      subtitle: 'Visa, Mastercard, RuPay, Maestro',
                      isSelected: selectedMethod == 'Credit/Debit Card',
                      onTap: () {
                        cartProvider.setPaymentMethod('Credit/Debit Card');
                      },
                    ),
                    const Gap(12),
                    _buildPaymentOption(
                      context: context,
                      icon: Icons.account_balance_outlined,
                      title: 'Net Banking',
                      subtitle: 'Pay directly from your bank account',
                      isSelected: selectedMethod == 'Net Banking',
                      onTap: () {
                        cartProvider.setPaymentMethod('Net Banking');
                      },
                    ),
                    const Gap(12),
                    _buildPaymentOption(
                      context: context,
                      icon: Icons.wallet_outlined,
                      title: 'Wallets',
                      subtitle: 'Amazon Pay, Mobikwik, PhonePe Wallet',
                      isSelected: selectedMethod == 'Wallet',
                      onTap: () {
                        cartProvider.setPaymentMethod('Wallet');
                      },
                    ),
                    const Gap(24),
                    // Confirm & Pay button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF10B981),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close bottom sheet
                          // Navigate to payment status loading screen
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => PaymentStatusScreen(
                                paymentMethod: selectedMethod,
                                amount: total,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'Confirm & Pay ₹${total.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPaymentOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    const activeColor = Color(0xFF10B981);
    final borderColor = isSelected ? activeColor : const Color(0xFFE2E8F0);
    final bgColor = isSelected ? const Color(0xFFECFDF5) : Colors.white;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFA7F3D0) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected ? activeColor : const Color(0xFF0F172A),
                size: 22,
              ),
            ),
            const Gap(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: isSelected ? activeColor : const Color(0xFF0F172A),
                    ),
                  ),
                  const Gap(2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: isSelected ? const Color(0xFF059669) : const Color(0xFF64748B),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle_rounded,
                color: activeColor,
              )
            else
              const Icon(
                Icons.circle_outlined,
                color: Color(0xFF94A3B8),
              ),
          ],
        ),
      ),
    );
  }
}

class PaymentStatusScreen extends StatefulWidget {
  final String paymentMethod;
  final double amount;

  const PaymentStatusScreen({
    super.key,
    required this.paymentMethod,
    required this.amount,
  });

  @override
  State<PaymentStatusScreen> createState() => _PaymentStatusScreenState();
}

class _PaymentStatusScreenState extends State<PaymentStatusScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _startPaymentSimulation();
  }

  void _startPaymentSimulation() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        // Clear the cart when payment succeeds
        context.read<CartProvider>().clearCart();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: _isLoading ? _buildLoadingState() : _buildSuccessState(),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          width: 60,
          height: 60,
          child: CircularProgressIndicator(
            color: Color(0xFF10B981),
            strokeWidth: 4,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Processing Payment...',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Connecting to secure gateway via ${widget.paymentMethod}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Color(0xFFECFDF5),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_circle_rounded,
            color: Color(0xFF10B981),
            size: 80,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Order Placed Successfully!',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Your payment of ₹${widget.amount.toStringAsFixed(0)} via ${widget.paymentMethod} was successful.',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            onPressed: () {
              // Pop back to the cart screen
              Navigator.of(context).pop(); // pop status screen
              Navigator.of(context).pop(); // pop checkout screen
            },
            child: const Text(
              'Back to Cart',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
