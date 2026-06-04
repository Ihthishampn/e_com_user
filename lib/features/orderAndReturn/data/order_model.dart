

import 'package:e_com_user/general/utils/enums/order_status.dart';
import 'package:e_com_user/general/utils/enums/return_status.dart';

class OrderModel {
  final String id;
  final String productName;
  final String image;
  final double price;

  final OrderStatus orderStatus;
  final ReturnStatus returnStatus;

  const OrderModel({
    required this.id,
    required this.productName,
    required this.image,
    required this.price,
    required this.orderStatus,
    required this.returnStatus,
  });
}