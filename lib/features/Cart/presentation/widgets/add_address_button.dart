import 'package:flutter/material.dart';

class AddAddressButton extends StatelessWidget {
  const AddAddressButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Add Address (Demo)'),
            content: const Text(
              'This is a demo UI. Add address flow goes here.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
      icon: const Icon(Icons.add_location_alt_outlined),
      label: const Text('Add New Address'),
    );
  }
}
