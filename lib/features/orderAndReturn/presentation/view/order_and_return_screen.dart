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
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: -0.5),
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
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
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
