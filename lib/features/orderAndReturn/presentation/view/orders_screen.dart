import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gap/gap.dart';
import 'package:e_com_user/features/orderAndReturn/presentation/provider/order_provider.dart';
import 'package:e_com_user/features/orderAndReturn/data/model/order_model.dart';
import 'package:e_com_user/general/utils/enums/app_state.dart';
import 'package:e_com_user/general/utils/themes/app_text_style.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late OrderProvider _orderProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _orderProvider = context.read<OrderProvider>();
      // start listening to all orders (no auth in this project)
      _orderProvider.startOrdersListener();
    });
  }

  @override
  void dispose() {
    try {
      _orderProvider.stopOrdersListener();
    } catch (_) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<OrderProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F172A),
      ),
      body: _buildBody(prov),
    );
  }

  Widget _buildBody(OrderProvider prov) {
    if (prov.ordersState == AppState.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (prov.ordersState == AppState.error) {
      return Center(child: Text(prov.error ?? 'Failed to load orders'));
    }

    if (prov.orders.isEmpty) {
      return const Center(child: Text('No orders yet'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: prov.orders.length,
      separatorBuilder: (context, index) => const Divider(height: 16),
      itemBuilder: (context, index) {
        final order = prov.orders[index];
        return _OrderTile(order: order);
      },
    );
  }
}

class _OrderTile extends StatelessWidget {
  final OrderModel order;
  const _OrderTile({required this.order});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // navigate to order detail if exists in your routes
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(order.orderNumber, style: AppTextStyles.titleMedium),
                Text(
                  order.orderStatus.name.toUpperCase(),
                  style: TextStyle(color: Colors.orange.shade700),
                ),
              ],
            ),
            const Gap(8),
            Text(
              '${order.items.length} items • ₹${order.amount.toStringAsFixed(0)}',
              style: AppTextStyles.bodyMedium,
            ),
            const Gap(8),
            Text(
              '${order.shippingAddress.street}, ${order.shippingAddress.city}',
              style: AppTextStyles.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
