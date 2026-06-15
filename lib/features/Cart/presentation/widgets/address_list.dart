import 'package:e_com_user/features/Address/presentation/provider/address_provider.dart';
import 'package:e_com_user/features/Address/presentation/view/address_screen.dart';
import 'package:e_com_user/features/Cart/presentation/widgets/add_address_button.dart';
import 'package:e_com_user/features/Cart/presentation/widgets/address_tile.dart';
import 'package:e_com_user/general/utils/enums/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddressList extends StatefulWidget {
  const AddressList({super.key});

  @override
  State<AddressList> createState() => _AddressListState();
}

class _AddressListState extends State<AddressList> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final addressProvider = context.watch<AddressProvider>();
    final addresses = addressProvider.addressList;

    // Loading state
    if (addressProvider.fetchState == AppState.loading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    // No addresses state
    if (addresses.isEmpty) {
      return Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7ED),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: const Color(0xFFFED7AA),
                width: 1,
              ),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.location_off_rounded,
                  size: 36,
                  color: Color(0xFFF97316),
                ),
                SizedBox(height: 12),
                Text(
                  'Please add an address first.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF9A3412),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Add a delivery address to continue with your order.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFFC2410C),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AddAddressButton(
            onTap: () => _navigateToAddressScreen(context),
          ),
        ],
      );
    }

    // Auto-select first address if none selected
    if (addressProvider.selectedAddress == null && addresses.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        addressProvider.selectAddress(addresses[0]);
      });
    }

    return Column(
      children: [
        Column(
          children: List.generate(addresses.length, (index) {
            final a = addresses[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: AddressTile(
                title: a.name,
                address: '${a.address}${a.landMark.isNotEmpty ? ', ${a.landMark}' : ''}',
                selected: index == selectedIndex,
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                  addressProvider.selectAddress(a);
                },
                onEditTap: () {
                  // Navigate to address screen for editing
                  _navigateToAddressScreen(context);
                },
              ),
            );
          }),
        ),
        const SizedBox(height: 4),
        AddAddressButton(
          onTap: () => _navigateToAddressScreen(context),
        ),
      ],
    );
  }

  void _navigateToAddressScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const AddressScreen(),
      ),
    );
  }
}
