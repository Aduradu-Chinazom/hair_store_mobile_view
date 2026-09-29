import 'package:flutter/material.dart';
import 'package:hairstore/screens/checkout/payment_success_screen.dart';

import '../../widgets/checkout_header.dart';
import '../../widgets/checkout_stepper.dart';
import '../../widgets/checkout_text_field.dart';
import '../../widgets/custom_button.dart';

class PaymentScreen extends StatefulWidget {
  final String merchantName;
  final String totalAmount;

  const PaymentScreen({
    super.key,
    this.merchantName = 'Hair Haven',
    this.totalAmount = '\$16119.20',
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  static const _bg = Color(0xFFE8C8B8);
  static const _card = Color(0xFFFFF3EC);
  static const _mint = Color(0xFF74E8C8);
  static const _fieldBorder = Color(0xFFC9B0A6);

  final TextEditingController _phone = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    _phone.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    // TODO: call your Opay payment request with _phone.text and _password.text
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Column(
        children: [
          const CheckoutHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back arrow
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                    child: GestureDetector(
                      onTap: () => Navigator.maybePop(context),
                      child: const Icon(Icons.arrow_back, size: 18),
                    ),
                  ),

                  const SizedBox(height: 4),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: CheckoutStepper(currentStep: 3),
                  ),

                  const SizedBox(height: 22),

                  _paymentDetailsCard(),

                  const SizedBox(height: 14),

                  _opayCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Payment details ----------

  Widget _paymentDetailsCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 22),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment Details',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Text(
            'Merchant Name : ${widget.merchantName}',
            style: const TextStyle(fontSize: 11),
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              const Text('Total Amount:', style: TextStyle(fontSize: 11)),
              const SizedBox(width: 8),
              Text(
                widget.totalAmount,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Small hint row: TODO confirm the exact wording against Figma
          Row(
            children: [
              _chip('Enter'),
              const SizedBox(width: 4),
              _chip('OTP'),
              const SizedBox(width: 6),
              const Text(
                'to complete payment',
                style: TextStyle(fontSize: 7, color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: const Color(0xFFF9B4CF),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 7, color: Color(0xFFC2185B)),
      ),
    );
  }

  // ---------- Pay with Opay ----------

  Widget _opayCard() {
    const labelStyle = TextStyle(fontSize: 11, color: Colors.black);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pay with Opay',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),

          const Text('Phone Number', style: labelStyle),
          const SizedBox(height: 6),
          CheckoutTextField(
            controller: _phone,
            hintText: 'Enter your phone number',
            radius: 4,
            borderColor: _fieldBorder,
            fillColor: _card,
            hintFontSize: 13,
            keyboardType: TextInputType.phone,
          ),

          const SizedBox(height: 18),

          const Text('Password', style: labelStyle),
          const SizedBox(height: 6),
          CheckoutTextField(
            controller: _password,
            hintText: 'Enter your 6-digit login password for your opay account',
            radius: 4,
            borderColor: _fieldBorder,
            fillColor: _card,
            hintFontSize: 12,
            keyboardType: TextInputType.number,
            obscureText: true,
            maxLength: 6,
          ),

          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {},
              child: const Text(
                'Forgot password',
                style: TextStyle(fontSize: 10, color: Colors.black54),
              ),
            ),
          ),

          const SizedBox(height: 18),

          GestureDetector(
            onTap: _submit,
            child: AbsorbPointer(
              child: CustomButton(text: 'Next', color: _mint, onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentSuccessScreen(),
                  ),
                );
              },),
            ),
          ),

          const SizedBox(height: 8),

          SizedBox(
            width: double.infinity,
            height: 34,
            child: OutlinedButton(
              onPressed: () => Navigator.maybePop(context),
              style: OutlinedButton.styleFrom(
                backgroundColor: _card,
                side: const BorderSide(color: _fieldBorder),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF8FEAD2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}