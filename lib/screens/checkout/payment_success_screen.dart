import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';
import '../home/home_screen.dart';

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

  static const _brown = Color(0xFF654039);

  void _goHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFC5EBD5),
                    ),
                    alignment: Alignment.center,
                    child: Container(
                      width: 66,
                      height: 66,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF2FBF71),
                      ),
                      child: const Icon(
                        Icons.check_circle_outline,
                        size: 36,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'Payment Successful',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Your payment has been confirmed. Your payment will appear '
                    'as a charge from Hair Haven. Please check your email for '
                    'more details.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      height: 1.4,
                      color: Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 32),

                  CustomButton(
                    text: 'Okay',
                    color: _brown,
                    onPressed: () => _goHome(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
