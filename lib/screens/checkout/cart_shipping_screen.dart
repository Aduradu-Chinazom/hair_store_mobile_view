import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cart_provider.dart';
import '../../widgets/cart_item_tile.dart';
import '../../widgets/checkout_header.dart';
import '../../widgets/checkout_stepper.dart';
import '../../widgets/checkout_text_field.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/floating_nav_bar.dart';
import '../../widgets/payment_method_tile.dart';
import 'payment_screen.dart';

class CartShippingScreen extends StatefulWidget {
  const CartShippingScreen({super.key});

  @override
  State<CartShippingScreen> createState() => _CartShippingScreenState();
}

class _CartShippingScreenState extends State<CartShippingScreen> {
  static const _bg = Color(0xFFFFF3EC);

  static const _countries = [
    'Nigeria',
    'Ghana',
    'Kenya',
    'South Africa',
    'United Kingdom',
    'United States',
  ];

  final List<String> _months =
      List.generate(12, (i) => (i + 1).toString().padLeft(2, '0'));
  final List<String> _years =
      List.generate(15, (i) => (DateTime.now().year + i).toString());

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String _country = 'Nigeria';
  int _payment = 0; // 0 card, 1 wallet, 2 bank transfer
  String? _month;
  String? _year;

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _companyController.dispose();
    _stateController.dispose();
    _addressController.dispose();
    _postalCodeController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _handleContinue() {
    final cartProvider = context.read<CartProvider>();
    if (cartProvider.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your cart is empty. Add items before checking out.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final email = _emailController.text.trim();
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final address = _addressController.text.trim();
    final state = _stateController.text.trim();
    final phone = _phoneController.text.trim();

    if (email.isEmpty || firstName.isEmpty || address.isEmpty || state.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in required shipping fields (Email, Name, Address, State, Telephone)'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final paymentMethodName = _payment == 0
        ? 'Card'
        : _payment == 1
            ? 'Wallet'
            : 'Bank Transfer';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentScreen(
          totalAmount: cartProvider.formattedTotal,
          email: email,
          fullName: '$firstName $lastName'.trim(),
          address: address,
          state: state,
          country: _country,
          postalCode: _postalCodeController.text.trim(),
          telephone: phone,
          paymentMethod: paymentMethodName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [
          Column(
            children: [
              const CheckoutHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 110),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: CheckoutStepper(currentStep: 1),
                      ),
                      const SizedBox(height: 32),

                      _cartList(cartProvider),

                      const SizedBox(height: 40),

                      _shippingForm(),

                      const SizedBox(height: 32),

                      _paymentMethod(),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: CustomButton(
                          text: 'Continue',
                          color: const Color(0xFF654039),
                          onPressed: _handleContinue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Floating nav bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 16,
            child: Center(
              child: FloatingNavBar(
                currentIndex: 1,
                onTap: (i) {},
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Cart ----------

  Widget _cartList(CartProvider cartProvider) {
    final items = cartProvider.items;

    if (items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text('Your cart is empty', style: TextStyle(fontSize: 14)),
        ),
      );
    }

    return Column(
      children: [
        for (final item in items) ...[
          CartItemTile(
            item: item,
            onIncrement: () => cartProvider.incrementQuantity(item),
            onDecrement: () => cartProvider.decrementQuantity(item),
            onDelete: () => cartProvider.removeItem(item),
          ),
          const SizedBox(height: 18),
        ],
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text(
                cartProvider.formattedTotal,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF654039)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------- Shipping form ----------

  Widget _shippingForm() {
    const gap = SizedBox(height: 14);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SHIPPING ADDRESS',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 14),

          CheckoutTextField(
            controller: _emailController,
            hintText: 'Email',
            keyboardType: TextInputType.emailAddress,
          ),
          gap,
          Row(
            children: [
              Expanded(
                child: CheckoutTextField(
                  controller: _firstNameController,
                  hintText: 'Full name',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CheckoutTextField(
                  controller: _lastNameController,
                  hintText: 'LastName',
                ),
              ),
            ],
          ),
          gap,
          CheckoutTextField(
            controller: _companyController,
            hintText: 'Company (optional)',
          ),
          gap,
          Row(
            children: [
              Expanded(
                child: CheckoutTextField(
                  controller: _stateController,
                  hintText: 'State',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CheckoutTextField(
                  controller: _addressController,
                  hintText: 'Address',
                ),
              ),
            ],
          ),
          gap,
          CheckoutDropdown(
            label: 'Country',
            items: _countries,
            value: _country,
            onChanged: (v) => setState(() => _country = v ?? _country),
          ),
          gap,
          Row(
            children: [
              Expanded(
                child: CheckoutTextField(
                  controller: _postalCodeController,
                  hintText: 'Postal Code',
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CheckoutTextField(
                  controller: _phoneController,
                  hintText: 'Telephone',
                  keyboardType: TextInputType.phone,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------- Payment method ----------

  Widget _paymentMethod() {
    const labelStyle = TextStyle(fontSize: 11, fontWeight: FontWeight.w700);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment Method',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PaymentMethodTile(
                icon: Icons.credit_card,
                label: 'Card',
                selected: _payment == 0,
                onTap: () => setState(() => _payment = 0),
              ),
              PaymentMethodTile(
                icon: Icons.account_balance_wallet_outlined,
                label: 'Wallet',
                selected: _payment == 1,
                onTap: () => setState(() => _payment = 1),
              ),
              PaymentMethodTile(
                icon: Icons.account_balance_outlined,
                label: 'Bank Transfer',
                selected: _payment == 2,
                onTap: () => setState(() => _payment = 2),
              ),
            ],
          ),

          // Card fields only show for the Card option
          if (_payment == 0) ...[
            const SizedBox(height: 14),
            const Text('Name on Card', style: labelStyle),
            const SizedBox(height: 6),
            const CheckoutTextField(
              hintText: 'First & Last Name',
              radius: 10,
            ),
            const SizedBox(height: 12),
            const Text('Card Number', style: labelStyle),
            const SizedBox(height: 6),
            const CheckoutTextField(
              hintText: '0000  0000  0000  0000',
              radius: 10,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: CheckoutDropdown(
                    hint: 'MM',
                    radius: 10,
                    items: _months,
                    value: _month,
                    onChanged: (v) => setState(() => _month = v),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CheckoutDropdown(
                    hint: 'YYYY',
                    radius: 10,
                    items: _years,
                    value: _year,
                    onChanged: (v) => setState(() => _year = v),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: CheckoutTextField(
                    hintText: 'CVV',
                    radius: 10,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
