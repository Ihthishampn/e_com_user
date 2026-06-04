import 'package:e_com_user/features/orderAndReturn/presentation/widgets/order_card.dart';
import 'package:e_com_user/features/orderAndReturn/presentation/widgets/return_card.dart';
import 'package:flutter/material.dart';

class OrderAndReturnScreen extends StatefulWidget {
  const OrderAndReturnScreen({super.key});

  @override
  State<OrderAndReturnScreen> createState() => _OrderAndReturnScreenState();
}

class _OrderAndReturnScreenState extends State<OrderAndReturnScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final orders = [
    {
      "name": "Wireless Headphones",
      "price": "₹999",
      "status": "Delivered",
      "image": "https://picsum.photos/200",
    },
    {
      "name": "Smart Watch",
      "price": "₹2,499",
      "status": "Shipped",
      "image": "https://picsum.photos/201",
    },
    {
      "name": "Bluetooth Speaker",
      "price": "₹1,299",
      "status": "Packed",
      "image": "https://picsum.photos/202",
    },
    {
      "name": "Gaming Mouse",
      "price": "₹799",
      "status": "Cancelled",
      "image": "https://picsum.photos/203",
    },
  ];

  final returns = [
    {
      "name": "Wireless Headphones",
      "price": "₹999",
      "status": "Processing",
      "image": "https://picsum.photos/210",
    },
    {
      "name": "Smart Watch",
      "price": "₹2,499",
      "status": "Returned",
      "image": "https://picsum.photos/211",
    },
  ];

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case "delivered":
        return Colors.green;
      case "shipped":
        return Colors.orange;
      case "packed":
        return Colors.blue;
      case "accepted":
        return Colors.indigo;
      case "cancelled":
        return Colors.red;
      case "rejected":
        return Colors.red;
      case "processing":
        return Colors.orange;
      case "returned":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color.fromARGB(255, 50, 43, 150);

    return Scaffold(
      // backgroundColor: const Color.fromARGB(255, 31, 58, 111),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          "Orders & Returns",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: primaryColor,
          labelColor: primaryColor,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: "Orders"),
            Tab(text: "Returns"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // ORDERS TAB
          ListView.builder(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 90),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];

              return OrderCard(
                name: order["name"]!,
                price: order["price"]!,
                status: order["status"]!,
                image: order["image"]!,
                statusColor: statusColor(order["status"]!),
                onReturnPressed: () {},
              );
            },
          ),

          // RETURNS TAB
          ListView.builder(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 90),
            itemCount: returns.length,
            itemBuilder: (context, index) {
              final item = returns[index];

              return ReturnCard(
                name: item["name"]!,
                price: item["price"]!,
                status: item["status"]!,
                image: item["image"]!,
                statusColor: statusColor(item["status"]!),
              );
            },
          ),
        ],
      ),
    );
  }
}
