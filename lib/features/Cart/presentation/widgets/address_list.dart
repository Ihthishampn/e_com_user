import 'package:e_com_user/features/Cart/presentation/widgets/address_tile.dart';
import 'package:e_com_user/features/Cart/presentation/widgets/add_address_button.dart';
import 'package:flutter/material.dart';

class AddressList extends StatelessWidget {
  const AddressList({super.key});

  @override
  Widget build(BuildContext context) {
    final addresses = [
      {'title': 'Home', 'address': '221B Baker Street, London, UK'},
      {'title': 'Office', 'address': '1 Infinite Loop, Cupertino, CA'},
    ];

    return Column(
      children: [
        Column(
          children: addresses.map((a) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: AddressTile(title: a['title']!, address: a['address']!),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        const AddAddressButton(),
      ],
    );
  }
}
