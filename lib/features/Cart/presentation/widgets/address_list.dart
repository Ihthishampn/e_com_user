import 'package:e_com_user/features/Cart/presentation/widgets/address_tile.dart';
import 'package:e_com_user/features/Cart/presentation/widgets/add_address_button.dart';
import 'package:flutter/material.dart';

class AddressList extends StatefulWidget {
  const AddressList({super.key});

  @override
  State<AddressList> createState() => _AddressListState();
}

class _AddressListState extends State<AddressList> {
  int selectedIndex = 0;

  final addresses = [
    {'title': 'Home', 'address': '221B Baker Street, London, UK'},
    {'title': 'Office', 'address': '1 Infinite Loop, Cupertino, CA'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: List.generate(addresses.length, (index) {
            final a = addresses[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: AddressTile(
                title: a['title']!,
                address: a['address']!,
                selected: index == selectedIndex,
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                onEditTap: () {
                  // edit address
                },
              ),
            );
          }),
        ),
        const SizedBox(height: 4),
        const AddAddressButton(),
      ],
    );
  }
}
