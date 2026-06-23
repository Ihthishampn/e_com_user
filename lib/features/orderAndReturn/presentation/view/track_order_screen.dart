import 'package:e_com_user/features/orderAndReturn/presentation/widgets/order_info_card.dart';
import 'package:e_com_user/features/orderAndReturn/presentation/widgets/delivery_address_card.dart';
import 'package:e_com_user/features/orderAndReturn/data/model/shipping_model.dart';
import 'package:e_com_user/features/orderAndReturn/presentation/widgets/tracking_card.dart';
import 'package:e_com_user/general/utils/themes/app_colors.dart';
import 'package:e_com_user/general/utils/themes/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TrackOrderScreen extends StatelessWidget {
  final String orderId;
  final String productName;
  final String orderStatus;
  final ShippingAddress shippingAddress;
  final bool isReturn;
  final String? adminNotes;
  final List<String>? customStatuses;

  const TrackOrderScreen({
    super.key,
    required this.orderId,
    required this.productName,
    required this.orderStatus,
    required this.shippingAddress,
    this.adminNotes,
    this.isReturn = false,
    this.customStatuses,
  });

  @override
  Widget build(BuildContext context) {
    final isRejected = orderStatus.toLowerCase() == 'rejected';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
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
          isReturn ? "Track Return" : "Track Order",
          style: AppTextStyles.titleLarge.copyWith(
            fontWeight: FontWeight.w800,
            color: const Color(0xFF0F172A),
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.help_outline_rounded,
              color: Color(0xFF64748B),
            ),
            onPressed: () {},
          ),
          const Gap(8),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _statusColor(
                          orderStatus,
                        ).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        orderStatus,
                        style: TextStyle(
                          color: _statusColor(orderStatus),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (isRejected && !isReturn)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF2F2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFEF4444)),
                        ),
                        child: const Text(
                          'Order Rejected',
                          style: TextStyle(
                            color: Color(0xFFB91C1C),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildEngageableCard(
                    child: OrderInfoCard(
                      orderId: orderId,
                      productName: productName,
                    ),
                  ),
                  const Gap(20),

                  // Show admin notes for return requests, if present
                  if (isReturn && (adminNotes ?? '').trim().isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionLabel('Admin Note'),
                        const Gap(8),
                        _buildEngageableCard(
                          child: Text(
                            adminNotes!,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: const Color(0xFF334155),
                              height: 1.4,
                            ),
                          ),
                        ),
                        const Gap(20),
                      ],
                    ),

                  if (isRejected)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFEF4444)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'This order has been rejected',
                            style: TextStyle(
                              color: Color(0xFF991B1B),
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                                ),
                          SizedBox(height: 8),
                          Text(
                            'There will be no further updates for this order. Please contact support for more information.',
                            style: TextStyle(color: Color(0xFF7F1D1D)),
                          ),
                        ],
                      ),
                    ),

                  if (!isRejected)
                    _buildSectionLabel(
                      isReturn ? 'Return Progress' : 'Live Progress',
                    ),
                  if (!isRejected) const Gap(12),

                  if (!isRejected)
                    _buildEngageableCard(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 16,
                      ),
                      child: TrackingCard(
                        orderStatus: orderStatus,
                        statuses:
                            customStatuses ??
                            (isReturn
                                ? const [
                                    'Return Requested',
                                    'Processing',
                                    'Pickup Done',
                                    'Returned',
                                  ]
                                : const [
                                    'Pending',
                                    'Accepted',
                                    'Packed',
                                    'Shipped',
                                    'Delivered',
                                  ]),
                      ),
                    ),

                  if (!isRejected) const Gap(24),

                  if (!isRejected)
                    _buildSectionLabel(
                      isReturn ? 'Pickup Source' : 'Delivery Destination',
                    ),
                  if (!isRejected) const Gap(12),

                  if (!isRejected)
                    _buildEngageableCard(
                      child: DeliveryAddressCard(
                        title: isReturn ? 'Pickup Address' : 'Delivery Address',
                        recipientName: shippingAddress.name,
                        address:
                            '${shippingAddress.street},\n${shippingAddress.city},\n${shippingAddress.state} - ${shippingAddress.pincode}',
                      ),
                    ),

                  const Gap(40),
                ],
              ),
            ),
          ),

          _buildBottomControlDock(isRejected: isRejected),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
      case 'returned':
        return const Color(0xFF16A34A);
      case 'shipped':
      case 'processing':
        return const Color(0xFFEA580C);
      case 'packed':
      case 'accepted':
        return const Color(0xFF2563EB);
      case 'cancelled':
      case 'rejected':
        return const Color(0xFFDC2626);
      default:
        return const Color(0xFF64748B);
    }
  }

  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        text,
        style: AppTextStyles.titleMedium.copyWith(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF475569),
          letterSpacing: -0.1,
        ),
      ),
    );
  }

  Widget _buildEngageableCard({
    required Widget child,
    EdgeInsetsGeometry? padding,
  }) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEDF2F7), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.03),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildBottomControlDock({required bool isRejected}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Container(
              height: 54,
              width: 54,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(16),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.chat_bubble_outline_rounded,
                  color: Color(0xFF0F172A),
                  size: 22,
                ),
                onPressed: () {},
              ),
            ),
            const Gap(16),

            Expanded(
              child: SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: isRejected ? null : () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isRejected
                        ? Colors.grey.shade400
                        : AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isRejected ? Icons.block : Icons.refresh_rounded,
                        size: 18,
                        color: Colors.white,
                      ),
                      const Gap(8),
                      Text(
                        isRejected
                            ? 'Order Rejected'
                            : (isReturn
                                  ? 'Refresh Return Status'
                                  : 'Refresh Live Status'),
                        style: AppTextStyles.titleMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ],
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

