import 'package:e_com_user/features/orderAndReturn/presentation/widgets/delivery_address_card.dart';
import 'package:e_com_user/features/orderAndReturn/presentation/widgets/order_info_card.dart';
import 'package:e_com_user/features/orderAndReturn/presentation/widgets/tracking_card.dart';
import 'package:e_com_user/general/utils/themes/app_colors.dart';
import 'package:flutter/material.dart';

class TrackOrderScreen extends StatelessWidget {
  final String orderId;
  final String productName;
  final String orderStatus;

  const TrackOrderScreen({
    super.key,
    required this.orderId,
    required this.productName,
    required this.orderStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.containerGrey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          "Track Order",
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            OrderInfoCard(orderId: orderId, productName: productName),
            const SizedBox(height: 18),
            TrackingCard(orderStatus: orderStatus),
            const SizedBox(height: 18),
            DeliveryAddressCard(
              recipientName: "John Doe",
              address: "221B Baker Street,\nLondon,\nUnited Kingdom",
            ),
          ],
        ),
      ),
    );
  }
}
