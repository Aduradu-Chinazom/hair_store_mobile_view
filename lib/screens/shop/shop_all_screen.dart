import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import '../../providers/product_provider.dart';
import '../../widgets/app_footer.dart';
import '../../widgets/app_header.dart';
import '../../widgets/filter_sheet.dart';
import '../../widgets/floating_nav_bar.dart';
import '../../widgets/product_card.dart';
import '../../widgets/section_title.dart';
import '../product_detail/product_detail_screen.dart';

class ShopAllScreen extends StatefulWidget {
  const ShopAllScreen({super.key});

  @override
  State<ShopAllScreen> createState() => _ShopAllScreenState();
}

class _ShopAllScreenState extends State<ShopAllScreen> {
  static const _bg = Color(0xFFE8C8B8);

  final ScrollController _recsController = ScrollController();

  int _tab = 0;
  int _navIndex = 0;
  int _page = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().loadShopAllData();
    });
  }

  @override
  void dispose() {
    _recsController.dispose();
    super.dispose();
  }

  Future<void> _openFilters() async {
    final provider = context.read<ProductProvider>();
    final result = await showFilterSheet(
      context,
      selected: provider.activeFilters,
      totalResults: 300,
    );

    if (result != null) {
      provider.setFilters(result);
    }
  }

  void _scrollRecs(double delta) {
    if (!_recsController.hasClients) return;

    final target = (_recsController.offset + delta).clamp(
      0.0,
      _recsController.position.maxScrollExtent,
    );

    _recsController.animateTo(
      target,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
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
    final provider = context.watch<ProductProvider>();
    final products = provider.products;
    final recommendations = provider.recommendations;
    final brands = provider.brands;

    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: AppHeader(
                  selectedTab: _tab,
                  onTabChanged: (i) {
                    setState(() => _tab = i);
                    final catName = AppHeader.tabs[i];
                    provider.selectCategory(catName);
                  },
                ),
              ),

              SliverToBoxAdapter(child: _heroBanner()),
              SliverToBoxAdapter(child: _titleBlock(provider.selectedCategory, products.length)),
              SliverToBoxAdapter(child: _toolbar(provider)),

              if (provider.isLoading && products.isEmpty)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(
                      child: CircularProgressIndicator(color: Color(0xFF654039)),
                    ),
                  ),
                )
              else if (products.length >= 4) ...[
                // First 4 products
                _productGrid(products.sublist(0, 4)),

                // Seasonal sales banner
                SliverToBoxAdapter(
                  child: _seasonalBanner(),
                ),

                // Remaining products
                _productGrid(products.sublist(4)),
              ] else if (products.isNotEmpty) ...[
                _productGrid(products),
              ] else ...[
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(
                      child: Text('No products found matching your filters.'),
                    ),
                  ),
                ),
              ],

              SliverToBoxAdapter(
                child: _pagination(),
              ),

              const SliverToBoxAdapter(
                child: SectionTitle('Explore more recommendations'),
              ),

              SliverToBoxAdapter(
                child: _recommendationsRow(recommendations),
              ),

              const SliverToBoxAdapter(
                child: SectionTitle('Shop by Brand'),
              ),

              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 2.6,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, i) => GestureDetector(
                      onTap: () {
                        provider.setSearchQuery(brands[i]);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          brands[i],
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    childCount: brands.length,
                  ),
                ),
              ),

              const SliverToBoxAdapter(
                child: AppFooter(),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 90),
              ),
            ],
          ),

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

  Widget _heroBanner() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF6DDD1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Now stocking Olaplex & Raegan Sinai!',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'SHOP NOW',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 90,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              Icons.image_outlined,
              color: Colors.black26,
            ),
          ),
        ],
      ),
    );
  }

  Widget _titleBlock(String category, int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Home / $category',
            style: const TextStyle(
              fontSize: 11,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Shop All',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '$count products',
            style: const TextStyle(
              fontSize: 11,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _toolbar(ProductProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: _openFilters,
            child: _pill(
              Row(
                children: [
                  const Icon(
                    Icons.tune,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    provider.activeFilters.isEmpty
                        ? 'Filter'
                        : 'Filter (${provider.activeFilters.length})',
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          PopupMenuButton<String>(
            initialValue: provider.sortBy,
            onSelected: (v) => provider.setSortBy(v),
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'Featured',
                child: Text('Featured'),
              ),
              PopupMenuItem(
                value: 'Price: Low to High',
                child: Text('Price: Low to High'),
              ),
              PopupMenuItem(
                value: 'Price: High to Low',
                child: Text('Price: High to Low'),
              ),
            ],
            child: _pill(
              Row(
                children: [
                  Text(
                    'Sort by: ${provider.sortBy}',
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pill(Widget child) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }

  SliverPadding _productGrid(List<Product> items) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      sliver: SliverGrid(
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.68,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, i) => ProductCard(
            product: items[i],
            showHeart: true,
            onTap: () => _openProductDetails(items[i]),
          ),
          childCount: items.length,
        ),
      ),
    );
  }

  Widget _seasonalBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFE6338A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Summer\nSeasonal\nSales !',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFFFA726),
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6DDD1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Countdown: 5:30:20',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.card_giftcard,
            size: 64,
            color: Colors.white70,
          ),
        ],
      ),
    );
  }

  Widget _pagination() {
    Widget num(int n) => GestureDetector(
          onTap: () => setState(() => _page = n),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: n == _page ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(3),
            ),
            child: Text(
              '$n',
              style: const TextStyle(
                fontSize: 11,
              ),
            ),
          ),
        );

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => setState(
              () => _page = (_page - 1).clamp(1, 10),
            ),
            child: Row(
              children: const [
                Icon(
                  Icons.chevron_left,
                  size: 16,
                ),
                Text(
                  'Previous',
                  style: TextStyle(
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              num(1),
              num(2),
              num(3),
              const Text(
                '…',
                style: TextStyle(
                  fontSize: 11,
                ),
              ),
              num(10),
            ],
          ),
          GestureDetector(
            onTap: () => setState(
              () => _page = (_page + 1).clamp(1, 10),
            ),
            child: Row(
              children: const [
                Text(
                  'Next',
                  style: TextStyle(
                    fontSize: 11,
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  size: 16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _recommendationsRow(List<Product> recommendations) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => _scrollRecs(-260),
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 18,
                  ),
                  visualDensity: VisualDensity.compact,
                ),
                IconButton(
                  onPressed: () => _scrollRecs(260),
                  icon: const Icon(
                    Icons.arrow_forward,
                    size: 18,
                  ),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 190,
          child: ListView.separated(
            controller: _recsController,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: recommendations.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, i) => SizedBox(
              width: 120,
              child: ProductCard(
                product: recommendations[i],
                showHeart: true,
                onTap: () => _openProductDetails(recommendations[i]),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
