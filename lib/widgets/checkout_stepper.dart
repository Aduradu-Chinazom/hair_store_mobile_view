import 'package:flutter/material.dart';

class CheckoutStepper extends StatelessWidget {
  /// 0 = Cart, 1 = Customers info, 2 = Shipping info, 3 = Payment.
  /// Every step up to and including this one is filled.
  final int currentStep;

  const CheckoutStepper({super.key, required this.currentStep});

  static const _labels = ['Cart', 'Customers info', 'Shipping info', 'Payment'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(_labels.length, (i) {
        final filled = i <= currentStep;
        return Expanded(
          child: Column(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: filled
                      ? const Color(0xFF654039)
                      : const Color(0xFFE8C8B8),
                  border: Border.all(
                    color: const Color(0xFF654039),
                    width: 0.8,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _labels[i],
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 9, color: Color(0xFF4A2E28)),
              ),
            ],
          ),
        );
      }),
    );
  }
}