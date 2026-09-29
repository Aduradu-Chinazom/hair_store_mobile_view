import 'package:flutter/material.dart';
import 'package:hairstore/screens/checkout/payment_screen.dart';

import '../../models/cart_item.dart';
import '../../widgets/cart_item_tile.dart';
import '../../widgets/checkout_header.dart';
import '../../widgets/checkout_stepper.dart';
import '../../widgets/checkout_text_field.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/payment_method_tile.dart';

class CartShippingScreen extends StatefulWidget {
  const CartShippingScreen({super.key});

  @override
  State<CartShippingScreen> createState() => _CartShippingScreenState();
}

class _CartShippingScreenState extends State<CartShippingScreen> {
  static const _bg = Color(0xFFFFF3EC);

  // Dummy data. Replace with your cart state or API response.
  final List<CartItem> _items = [
    CartItem(
      title: '1pc/3pcs multicolor Synthetic Hair Extensions, Sew-In',
      seller: 'Fajiahstore',
      price: 3.99,
      quantity: 2,
    ),
    CartItem(
      title: '3pc Hair Beauty clips',
      seller: 'Fajiahstore',
      price: 3.99,
      quantity: 2,
    ),
    CartItem(
      title: '1 Pack Black Afro Kinkys Bulk Hair 12/16 Inch',
      seller: 'Fajiahstore',
      price: 3.99,
      quantity: 2,
    ),
  ];

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

  String _country = 'Nigeria';
  int _payment = 0; // 0 card, 1 wallet, 2 bank transfer
  String? _month;
  String? _year;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Column(
        children: [
          const CheckoutHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: CheckoutStepper(currentStep: 1),
                  ),
                  const SizedBox(height: 32),

                  _cartList(),

                  const SizedBox(height: 40),

                  _shippingForm(),

                  const SizedBox(height: 32),

                  _paymentMethod(),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PaymentScreen(totalAmount: '\$16119.20'),
                          ),
                        );
                      },
                      child: AbsorbPointer(
                        child: CustomButton(text: 'Continue', color: const Color(0xFF654039), onPressed: (){},),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Cart ----------

  Widget _cartList() {
    if (_items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text('Your cart is empty', style: TextStyle(fontSize: 12)),
        ),
      );
    }

    return Column(
      children: [
        for (final item in _items) ...[
          CartItemTile(
            item: item,
            onIncrement: () => setState(() => item.quantity++),
            onDecrement: () => setState(() {
              if (item.quantity > 1) item.quantity--;
            }),
            onDelete: () => setState(() => _items.remove(item)),
          ),
          const SizedBox(height: 18),
        ],
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

          const CheckoutTextField(
            hintText: 'Email',
            keyboardType: TextInputType.emailAddress,
          ),
          gap,
          Row(
            children: const [
              Expanded(child: CheckoutTextField(hintText: 'Full name')),
              SizedBox(width: 12),
              Expanded(child: CheckoutTextField(hintText: 'LastName')),
            ],
          ),
          gap,
          const CheckoutTextField(hintText: 'Company (optional)'),
          gap,
          Row(
            children: const [
              Expanded(child: CheckoutTextField(hintText: 'State')),
              SizedBox(width: 12),
              Expanded(child: CheckoutTextField(hintText: 'Address')),
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
            children: const [
              Expanded(
                child: CheckoutTextField(
                  hintText: 'Postal Code',
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: CheckoutTextField(
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