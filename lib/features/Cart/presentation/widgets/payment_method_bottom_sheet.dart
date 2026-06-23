import 'package:e_com_user/features/Cart/presentation/provider/cart_provider.dart';
import 'package:e_com_user/features/Cart/presentation/view/payment_status_screen.dart';
import 'package:e_com_user/general/utils/themes/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class PaymentMethodBottomSheet extends StatelessWidget {
  final double total;

  const PaymentMethodBottomSheet({super.key, required this.total});

  @override
  Widget build(BuildContext context) {
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
                      Navigator.of(context).pop(); 
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
