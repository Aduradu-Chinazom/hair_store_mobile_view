import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/order_provider.dart';
import '../../widgets/app_footer.dart';
import '../../widgets/app_header.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/floating_nav_bar.dart';
import '../checkout/cart_shipping_screen.dart';
import '../login/login_screen.dart';
import '../wishlist/wishlist_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const _bg = Color(0xFFE8C8B8);
  static const _brown = Color(0xFF654039);
  static const _cardBg = Color(0xFFFFF3EC);

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final orderProvider = context.watch<OrderProvider>();
    final user = authProvider.currentUser;
    final orders = orderProvider.orders;

    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(
                child: AppHeader(showTabs: false),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User Info Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: _cardBg,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: _brown,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                (user?.displayName.isNotEmpty == true)
                                    ? user!.displayName[0].toUpperCase()
                                    : 'H',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user?.displayName ?? 'Valued Customer',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    user?.email ?? 'member@hairhaven.com',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFC5EBD5),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Text(
                                      'Hair Haven Member',
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF2FBF71),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      const Text(
                        'My Account',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _brown,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Options grid/list
                      _buildTile(
                        icon: Icons.shopping_bag_outlined,
                        title: 'My Orders',
                        subtitle: '${orders.length} ${orders.length == 1 ? 'order' : 'orders'} placed',
                        onTap: () {
                          _showOrdersModal(context, orders);
                        },
                      ),

                      _buildTile(
                        icon: Icons.favorite_border,
                        title: 'Saved Wishlist',
                        subtitle: 'View saved items',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WishlistScreen(),
                            ),
                          );
                        },
                      ),

                      _buildTile(
                        icon: Icons.shopping_cart_outlined,
                        title: 'My Shopping Cart',
                        subtitle: 'Manage cart & checkout',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CartShippingScreen(),
                            ),
                          );
                        },
                      ),

                      _buildTile(
                        icon: Icons.location_on_outlined,
                        title: 'Shipping Address',
                        subtitle: user?.address ?? 'Default delivery address',
                        onTap: () {
                          _showAddressModal(context, user?.address);
                        },
                      ),

                      _buildTile(
                        icon: Icons.payment_outlined,
                        title: 'Payment Methods',
                        subtitle: 'Saved cards & wallet options',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Payment methods feature configured.'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                      ),

                      _buildTile(
                        icon: Icons.help_outline,
                        title: 'Help & Customer Support',
                        subtitle: 'FAQs, returns & contact info',
                        onTap: () {
                          _showHelpDialog(context);
                        },
                      ),

                      const SizedBox(height: 20),

                      // Logout button
                      CustomButton(
                        text: 'Log Out',
                        color: _brown,
                        onPressed: () async {
                          await authProvider.logout();
                          if (context.mounted) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                              (route) => false,
                            );
                          }
                        },
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(
                child: AppFooter(),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 110),
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
                currentIndex: 3,
                onTap: (i) {},
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _cardBg,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: _brown, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.black54,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          size: 18,
          color: Colors.black45,
        ),
      ),
    );
  }

  void _showOrdersModal(BuildContext context, List dynamicOrders) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'My Orders History',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _brown,
              ),
            ),
            const SizedBox(height: 12),
            if (dynamicOrders.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text('No order history found yet.'),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: dynamicOrders.length,
                  itemBuilder: (context, i) {
                    final order = dynamicOrders[i];
                    return ListTile(
                      title: Text('Order #${order.id}'),
                      subtitle: Text('${order.items.length} items • ${order.status}'),
                      trailing: Text(
                        '\$${order.totalAmount.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showAddressModal(BuildContext context, String? address) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Saved Delivery Address',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _brown,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.location_on, color: _brown),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    address != null && address.isNotEmpty
                        ? address
                        : 'Hair Haven HQ IDU, Abuja, Nigeria',
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help & Customer Support'),
        content: const Text(
          'For customer support, order inquiries, or returns, please email support@hairhaven.com or call +234 (0) 800 HAIR HAVEN.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
