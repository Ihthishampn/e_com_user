import 'package:flutter/material.dart';

class AddressProgressLine extends StatelessWidget {
  final double progress;
  final Color primaryAccent;

  const AddressProgressLine({
    super.key,
    required this.progress,
    required this.primaryAccent,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * progress;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 4,
        width: width,
        alignment: Alignment.centerLeft,
        child: Container(
          width: width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryAccent, Colors.cyanAccent],
            ),
            boxShadow: [
              BoxShadow(
                color: primaryAccent.withValues(alpha: 0.5),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
