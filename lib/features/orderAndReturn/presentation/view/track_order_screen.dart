import 'package:e_com_user/features/orderAndReturn/presentation/widgets/delivery_address_card.dart';
import 'package:e_com_user/features/orderAndReturn/presentation/widgets/order_info_card.dart';
import 'package:e_com_user/features/orderAndReturn/presentation/widgets/tracking_card.dart';
import 'package:e_com_user/general/utils/themes/app_colors.dart';
import 'package:e_com_user/general/utils/themes/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TrackOrderScreen extends StatelessWidget {
  final String orderId;
  final String productName;
  final String orderStatus;
  final bool isReturn;
  final List<String>? customStatuses;

  const TrackOrderScreen({
    super.key,
    required this.orderId,
    required this.productName,
    required this.orderStatus,
    this.isReturn = false,
    this.customStatuses,
  });

  @override
  Widget build(BuildContext context) {
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
            onPressed: () {
              //  help dialog
            },
          ),
          const Gap(8),
        ],
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
                  _buildEngageableCard(
                    child: OrderInfoCard(
                      orderId: orderId,
                      productName: productName,
                    ),
                  ),
                  const Gap(20),

                  _buildSectionLabel(isReturn ? "Return Progress" : "Live Progress"),
                  const Gap(12),

                  _buildEngageableCard(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 16,
                    ),
                    child: TrackingCard(
                      orderStatus: orderStatus,
                      statuses: customStatuses ?? (isReturn
                          ? const ["Return Requested", "Processing", "Pickup Done", "Returned"]
                          : const ["Pending", "Accepted", "Packed", "Shipped", "Delivered"]),
                    ),
                  ),
                  const Gap(24),

                  _buildSectionLabel(isReturn ? "Pickup Source" : "Delivery Destination"),
                  const Gap(12),

                  _buildEngageableCard(
                    child: DeliveryAddressCard(
                      title: isReturn ? "Pickup Address" : "Delivery Address",
                      recipientName: "John Doe",
                      address: "221B Baker Street,\nLondon,\nUnited Kingdom",
                    ),
                  ),
                  const Gap(40),
                ],
              ),
            ),
          ),

          _buildBottomControlDock(),
        ],
      ),
    );
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

  Widget _buildBottomControlDock() {
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
                onPressed: () {
                },
              ),
            ),
            const Gap(16),

            Expanded(
              child: SizedBox(
                height: 54,
                child:
                    ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ).buildElevatedButton(
                      onPressed: () {
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.refresh_rounded,
                            size: 18,
                            color: Colors.white,
                          ),
                          const Gap(8),
                          Text(
                            isReturn ? 'Refresh Return Status' : 'Refresh Live Status',
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

extension on ButtonStyle {
  Widget buildElevatedButton({
    required VoidCallback onPressed,
    required Widget child,
  }) {
    return ElevatedButton(style: this, onPressed: onPressed, child: child);
  }
}
