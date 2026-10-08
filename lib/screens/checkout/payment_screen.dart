import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/order_model.dart';
import '../../providers/cart_provider.dart';
import '../../providers/order_provider.dart';
import '../../widgets/checkout_header.dart';
import '../../widgets/checkout_stepper.dart';
import '../../widgets/checkout_text_field.dart';
import '../../widgets/custom_button.dart';
import 'payment_success_screen.dart';

class PaymentScreen extends StatefulWidget {
  final String merchantName;
  final String totalAmount;
  final String email;
  final String fullName;
  final String address;
  final String state;
  final String country;
  final String postalCode;
  final String telephone;
  final String paymentMethod;

  const PaymentScreen({
    super.key,
    this.merchantName = 'Hair Haven',
    this.totalAmount = '\$16119.20',
    this.email = '',
    this.fullName = '',
    this.address = '',
    this.state = '',
    this.country = 'Nigeria',
    this.postalCode = '',
    this.telephone = '',
    this.paymentMethod = 'Card',
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

  Future<void> _submit() async {
    final cartProvider = context.read<CartProvider>();
    final orderProvider = context.read<OrderProvider>();

    final items = cartProvider.items;
    final subtotal = cartProvider.subtotal;
    final total = cartProvider.total;

    final newOrder = OrderModel(
      id: '',
      items: items,
      subtotal: subtotal,
      totalAmount: total > 0 ? total : 50.0,
      email: widget.email,
      fullName: widget.fullName,
      address: widget.address,
      state: widget.state,
      country: widget.country,
      postalCode: widget.postalCode,
      telephone: widget.telephone,
      paymentMethod: widget.paymentMethod,
      status: 'Confirmed',
      createdAt: DateTime.now(),
    );

    final created = await orderProvider.placeOrder(newOrder);

    if (!mounted) return;

    if (created != null) {
      await cartProvider.clearCart();
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PaymentSuccessScreen(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(orderProvider.errorMessage ?? 'Payment failed. Please try again.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrderProvider>();

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

                  _opayCard(orderProvider.isLoading),
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

  Widget _opayCard(bool isLoading) {
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

          isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Color(0xFF654039)),
                )
              : CustomButton(
                  text: 'Next',
                  color: _mint,
                  onPressed: _submit,
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
