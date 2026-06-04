import 'package:flutter/material.dart';

class AddressTile extends StatelessWidget {
  final String title;
  final String address;
  final bool selected;

  const AddressTile({
    super.key,
    required this.title,
    required this.address,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: selected ? Colors.blue.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Radio(value: selected, groupValue: true, onChanged: (_) {}),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(address),
              ],
            ),
          ),
          const SizedBox(width: 8),
          TextButton(onPressed: () {}, child: const Text('Edit')),
        ],
      ),
    );
  }
}
