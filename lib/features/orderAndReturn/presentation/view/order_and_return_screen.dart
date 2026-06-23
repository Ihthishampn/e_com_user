import 'package:e_com_user/features/orderAndReturn/data/model/return_details_model.dart';
import 'package:e_com_user/features/orderAndReturn/presentation/widgets/order_card.dart';
import 'package:e_com_user/features/orderAndReturn/presentation/widgets/return_card.dart';
import 'package:e_com_user/features/orderAndReturn/presentation/provider/order_provider.dart';
import 'package:e_com_user/features/orderAndReturn/presentation/view/track_order_screen.dart';
import 'package:flutter/material.dart';
import 'package:e_com_user/general/utils/enums/app_state.dart';
import 'package:e_com_user/general/utils/enums/return_status.dart';
import 'package:provider/provider.dart';

class OrderAndReturnScreen extends StatefulWidget {
  const OrderAndReturnScreen({super.key});

  @override
  State<OrderAndReturnScreen> createState() => _OrderAndReturnScreenState();
}

class _OrderAndReturnScreenState extends State<OrderAndReturnScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  OrderProvider? _provider;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider = context.read<OrderProvider>();
      _provider?.startOrdersListener();
    });
  }

  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }

  Future<String?> _askReturnReason(BuildContext context) async {
    final controller = TextEditingController();
    final result = await showDialog<String?>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Return reason'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Reason for return'),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(null),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(controller.text),
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
    return result;
  }

  Future<String?> _askCancellationReason(BuildContext context) async {
    final controller = TextEditingController();
    final result = await showDialog<String?>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Cancel order'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Reason for cancellation',
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(null),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(controller.text),
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
    return result;
  }

  @override
  void dispose() {
    _provider?.stopOrdersListener();
    _tabController.dispose();
    super.dispose();
  }

  Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case "delivered":
      case "returned":
        return const Color(0xFF16A34A);
      case "shipped":
      case "processing":
        return const Color(0xFFEA580C);
      case "packed":
      case "accepted":
        return const Color(0xFF2563EB);
      case "cancelled":
      case "rejected":
        return const Color(0xFFDC2626);
      default:
        return const Color(0xFF64748B);
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color.fromARGB(255, 50, 43, 150);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          "Orders & Returns",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            height: 46,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(14),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              indicator: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              labelColor: Colors.white,
              unselectedLabelColor: const Color(0xFF64748B),
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              tabs: const [
                Tab(text: "Orders"),
                Tab(text: "Returns"),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // ORDERS TAB
          Consumer<OrderProvider>(
            builder: (context, prov, _) {
              // Exclude orders that have an active return request — they belong in Returns tab
              final list = prov.orders
                  .where((o) => o.returnDetails == null)
                  .toList();
              if (prov.ordersState == AppState.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (list.isEmpty) {
                return const Center(child: Text('No orders found'));
              }
              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 90),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final order = list[index];
                  final name = order.items.isNotEmpty
                      ? order.items.first.productName
                      : order.orderNumber;
                  final price = '₹${order.amount.toStringAsFixed(0)}';
                  final status = _capitalize(order.orderStatus.name);
                  final image = order.items.isNotEmpty
                      ? order.items.first.imageUrl
                      : '';
                  final isDelivered = status.toLowerCase() == 'delivered';
                  final canCancel =
                      !isDelivered &&
                      status.toLowerCase() != 'cancelled' &&
                      status.toLowerCase() != 'rejected' &&
                      status.toLowerCase() != 'returned';

                  return OrderCard(
                    name: name,
                    price: price,
                    status: status,
                    image: image,
                    statusColor: statusColor(status),
                    canCancel: canCancel,
                    onReturnPressed: () async {
                      // ask for reason
                      final reason = await _askReturnReason(context);
                      if (reason == null || reason.trim().isEmpty) return;
                      final details = ReturnDetails(
                        reason: reason.trim(),
                        status: ReturnStatus.requested,
                        requestedAt: DateTime.now(),
                      );
                      await prov.placeReturnRequest(
                        orderId: order.orderId,
                        details: details,
                      );
                    },
                    onCancelPressed: () async {
                      final reason = await _askCancellationReason(context);
                      if (reason == null || reason.trim().isEmpty) return;
                      final success = await prov.cancelOrder(
                        orderId: order.orderId,
                        reason: reason.trim(),
                      );
                      if (!success && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              prov.error ?? 'Failed to cancel order',
                            ),
                          ),
                        );
                      }
                    },
                    onTrackPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => TrackOrderScreen(
                            orderId: order.orderId,
                            productName: name,
                            orderStatus: status,
                            shippingAddress: order.shippingAddress,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),

          // RETURNS TAB
          Consumer<OrderProvider>(
            builder: (context, prov, _) {
              final returnsList = prov.orders
                  .where((o) => o.returnDetails != null)
                  .toList();
              if (prov.ordersState == AppState.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (returnsList.isEmpty) {
                return const Center(child: Text('No returns found'));
              }
              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 90),
                itemCount: returnsList.length,
                itemBuilder: (context, index) {
                  final order = returnsList[index];
                  final name = order.items.isNotEmpty
                      ? order.items.first.productName
                      : order.orderNumber;
                  final price = '₹${order.amount.toStringAsFixed(0)}';
                  final status = order.returnDetails != null
                      ? _capitalize(order.returnDetails!.status.name)
                      : _capitalize(order.orderStatus.name);
                  final image = order.items.isNotEmpty
                      ? order.items.first.imageUrl
                      : '';
                  return ReturnCard(
                    name: name,
                    price: price,
                    status: status,
                    image: image,
                    statusColor: statusColor(status),
                    onViewPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => TrackOrderScreen(
                            orderId: order.orderId,
                            productName: name,
                            orderStatus: status,
                            shippingAddress: order.shippingAddress,
                            adminNotes: order.returnDetails?.adminNotes,
                            isReturn: true,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
