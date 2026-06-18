import 'package:e_com_user/features/Address/presentation/provider/address_provider.dart';
import 'package:e_com_user/features/Cart/presentation/provider/cart_provider.dart';
import 'package:e_com_user/features/orderAndReturn/data/model/order_model.dart';
import 'package:e_com_user/features/orderAndReturn/data/model/shipping_model.dart';
import 'package:e_com_user/features/orderAndReturn/presentation/provider/order_provider.dart';
import 'package:e_com_user/general/utils/enums/app_state.dart';
import 'package:e_com_user/general/utils/enums/order_status.dart';
import 'package:e_com_user/general/utils/enums/payement_method.dart';
import 'package:e_com_user/general/utils/enums/payment_status.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _placeRealOrder();
    });
  }

  void _placeRealOrder() {
    final addressProvider = context.read<AddressProvider>();
    final cartProvider = context.read<CartProvider>();
    final orderProvider = context.read<OrderProvider>();

    final selectedAddress = addressProvider.selectedAddress;
    if (selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No delivery address selected.')),
      );
      return;
    }

    final shipping = ShippingAddress(
      name: selectedAddress.name,
      street: selectedAddress.address,
      city: selectedAddress.landMark,
      state: selectedAddress.note,
      pincode: "673637", 
    );

    PaymentMethod methodEnum;
    switch (widget.paymentMethod) {
      case 'Cash on Delivery':
        methodEnum = PaymentMethod.cod;
        break;
      case 'UPI':
        methodEnum = PaymentMethod.upi;
        break;
      case 'Credit/Debit Card':
        methodEnum = PaymentMethod.card;
        break;
      case 'Net Banking':
        methodEnum = PaymentMethod.netBanking;
        break;
      case 'Wallet':
        methodEnum = PaymentMethod.wallet;
        break;
      default:
        methodEnum = PaymentMethod.cod;
    }

    final payStatus = (methodEnum == PaymentMethod.cod)
        ? PaymentStatus.pending
        : PaymentStatus.paid;

    final items = cartProvider.cartList.map((item) {
      return OrderItemSummary(
        productId: item.productId,
        productName: item.productName,
        variantName: "",
        quantity: item.quantity,
        price: item.productPrice,
        imageUrl: item.imageUrl,
      );
    }).toList();

    final order = OrderModel(
      orderId: "",
      orderNumber: "",
      userId: "9072027963",
      userName: selectedAddress.name,
      userPhone: selectedAddress.phone,
      date: DateTime.now(),
      paymentMethod: methodEnum,
      paymentStatus: payStatus,
      orderStatus: OrderStatus.pending,
      amount: widget.amount,
      items: items,
      shippingAddress: shipping,
      createdAt: DateTime.now(),
    );

    orderProvider.placeOrder(order: order).then((_) {
      if (mounted && orderProvider.orderPlaceState == AppState.success) {
        cartProvider.clearCart();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrderProvider>();
    final state = orderProvider.orderPlaceState;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _buildStateWidget(state, orderProvider.error),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStateWidget(AppState state, String? error) {
    switch (state) {
      case AppState.loading:
        return _buildLoadingState();
      case AppState.success:
        return _buildSuccessState();
      case AppState.error:
        return _buildErrorState(error ?? 'An unknown error occurred.');
      default:
        return _buildLoadingState();
    }
  }

  Widget _buildLoadingState() {
    return Column(
      key: const ValueKey('loading'),
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
          style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
        ),
      ],
    );
  }

  Widget _buildSuccessState() {
    return Column(
      key: const ValueKey('success'),
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
          style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
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
              context.read<OrderProvider>().resetOrderState();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text(
              'Back to Cart',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(String errorMessage) {
    return Column(
      key: const ValueKey('error'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Color(0xFFFEF2F2),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.error_outline_rounded,
            color: Color(0xFFEF4444),
            size: 80,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Failed to Place Order',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          errorMessage,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14, color: Color(0xFFEF4444)),
        ),
        const SizedBox(height: 40),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 50,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFE2E8F0)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    context.read<OrderProvider>().resetOrderState();
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ),
              ),
            ),
            const Gap(12),
            Expanded(
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF4444),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    _placeRealOrder();
                  },
                  child: const Text(
                    'Try Again',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
