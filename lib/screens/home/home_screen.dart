import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import '../../providers/product_provider.dart';
import '../../widgets/category_circle.dart';
import '../../widgets/floating_nav_bar.dart';
import '../../widgets/home_search_bar.dart';
import '../../widgets/product_card.dart';
import '../../widgets/section_title.dart';
import '../product_detail/product_detail_screen.dart';
import '../shop/shop_all_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTab = -1;
  int _navIndex = 0;

  static const _tabs = [
    'All Categories',
    'Hair Extensions',
    'Hair Tools',
    'Accessories',
    'Wigs',
    'Oils',
    'More'
  ];

  static const _bg = Color(0xFFE8C8B8);
  static const _brown = Color(0xFF654039);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().loadHomeData();
    });
  }

  void _openProductDetails(Product product) {
    context.read<ProductProvider>().setSelectedProduct(product);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final products = productProvider.products;
    final categories = productProvider.categories;
    final packageDeals = productProvider.packageDeals;
    final giftsForHer = productProvider.giftsForHer;

    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [
          RefreshIndicator(
            color: _brown,
            onRefresh: () => productProvider.loadHomeData(),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: _header(
                    categories: categories.map((c) => c.name).toList(),
                  ),
                ),

                if (productProvider.isLoading && products.isEmpty)
                  const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(color: _brown),
                    ),
                  )
                else if (productProvider.errorMessage != null && products.isEmpty)
                  SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(productProvider.errorMessage!),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () => productProvider.loadHomeData(),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  )
                else ...[
                  // Products grid
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.68,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => ProductCard(
                          product: products[index],
                          onTap: () => _openProductDetails(products[index]),
                        ),
                        childCount: products.length,
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(
                    child: SectionTitle('New package deals under \$50'),
                  ),

                  _packageGrid(
                    items: packageDeals,
                    withLabel: true,
                  ),

                  const SliverToBoxAdapter(
                    child: SectionTitle('Gifts for HER'),
                  ),

                  _packageGrid(
                    items: giftsForHer,
                    withLabel: false,
                  ),
                ],

                // Space so content clears the floating nav bar
                const SliverToBoxAdapter(
                  child: SizedBox(height: 110),
                ),
              ],
            ),
          ),

          // Floating nav bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 16,
            child: Center(
              child: FloatingNavBar(
                currentIndex: _navIndex,
                onTap: (i) => setState(() => _navIndex = i),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _header({required List<String> categories}) {
    final catList = categories.isNotEmpty
        ? categories
        : [
            'Hair Extensions',
            'Hair Tools',
            'Accessories',
            'Wigs',
            'Oils',
          ];

    return Column(
      children: [
        // Search
        SafeArea(
          bottom: false,
          child: const Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 16),
            child: HomeSearchBar(),
          ),
        ),

        // Promo strip
        Container(
          width: double.infinity,
          height: 50,
          color: _brown,
          alignment: Alignment.center,
          child: const Text(
            'New Supply, 100% Great Deals 🔥',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white,
              decoration: TextDecoration.underline,
              decorationColor: Colors.white,
            ),
          ),
        ),

        // Tabs
        SizedBox(
          height: 44,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: _tabs.length,
            separatorBuilder: (_, __) => const SizedBox(width: 6),
            itemBuilder: (context, i) {
              final selected = i == _selectedTab;

              return GestureDetector(
                onTap: () {
                  if (i == 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ShopAllScreen(),
                      ),
                    );
                  } else {
                    setState(() => _selectedTab = i);
                    context.read<ProductProvider>().selectCategory(_tabs[i]);
                  }
                },
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: selected ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _tabs[i],
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF4A2E28),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Category circles
        SizedBox(
          height: 90,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: catList.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) => GestureDetector(
              onTap: () {
                context.read<ProductProvider>().selectCategory(catList[i]);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ShopAllScreen(),
                  ),
                );
              },
              child: CategoryCircle(
                label: catList[i],
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Banner
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 160,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/banner.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFF8A5A44),
                    ),
                  ),
                  Positioned(
                    left: 10,
                    top: 12,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black38,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'New Arrivals',
                            style: TextStyle(
                              fontSize: 7,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Discover your\nperfect wigs',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFF7D774),
                          ),
                        ),
                        const SizedBox(height: 6),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ShopAllScreen(),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 2,
                            ),
                            color: Colors.black,
                            child: const Text(
                              'Explore now',
                              style: TextStyle(
                                fontSize: 7,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Shipping info strip
        Container(
          width: double.infinity,
          color: const Color(0xFFF6DDD1),
          padding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 16,
          ),
          child: IntrinsicHeight(
            child: Row(
              children: const [
                Expanded(
                  child: _InfoTile(
                    icon: Icons.check,
                    title: 'Free Shipping &\nDiscounts',
                    link: 'How to be eligible',
                  ),
                ),
                VerticalDivider(
                  color: Colors.black38,
                  width: 24,
                  thickness: 1,
                ),
                Expanded(
                  child: _InfoTile(
                    icon: Icons.description_outlined,
                    title: 'Free Shipping &\nDiscounts',
                    link: 'Learn more',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  SliverPadding _packageGrid({
    required List<Product> items,
    required bool withLabel,
  }) {
    final count = items.length;

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: withLabel ? 0.95 : 1.15,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, i) => GestureDetector(
            onTap: () => _openProductDetails(items[i]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.card_giftcard,
                        size: 32,
                        color: Colors.brown.shade300,
                      ),
                    ),
                  ),
                ),
                if (withLabel) ...[
                  const SizedBox(height: 6),
                  Text(
                    items[i].title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF4A2E28),
                    ),
                  ),
                ],
              ],
            ),
          ),
          childCount: count,
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String link;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.link,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.black,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                link,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.black54,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
