import 'package:flutter/material.dart';

import '../../models/product.dart';
import '../../widgets/app_footer.dart';
import '../../widgets/app_header.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/product_card.dart';
import '../../widgets/rating_stars.dart';
import '../../widgets/section_title.dart';

class _Review {
  final String name;
  final String date;
  final String text;

  const _Review(this.name, this.date, this.text);
}

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  static const _bg = Color(0xFFE8C8B8);
  static const _brown = Color(0xFF654039);
  static const _card = Color(0xFFF8EEE6);

  final ScrollController _scroll = ScrollController();
  final PageController _pager = PageController();
  final GlobalKey _ctaKey = GlobalKey();

  int _image = 0;
  int _qty = 1;
  bool _wishlisted = false;
  bool _showStickyBar = false;

  // Replace with API data
  final List<String> _images = const ['', '', '', '', ''];

  final List<String> _tags = const [
    'Great smell',
    'Nice gift',
    'Good packaging',
    'Elegant',
    'Nice',
    'Really pretty',
  ];

  final List<_Review> _reviews = const [
    _Review('Ilo******', '14 Sept', 'Good quality product'),
    _Review('m***k', '19 Sept',
        'Would definitely buy again. It smells so nice and fragrant!'),
    _Review('haslf****', '19 Sept', 'This brand can take all my money'),
    _Review('haslf****', '19 Sept', 'This brand can take all my money'),
  ];

  final List<Product> _suggestions = List.generate(
    8,
        (i) => const Product(
      title: 'Gisou Honey Infused Hair Oil',
      price: '\$15.50',
      size: '(30ml)',
    ),
  );

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_checkCtaVisibility);
  }

  @override
  void dispose() {
    _scroll.dispose();
    _pager.dispose();
    super.dispose();
  }

  // Show the sticky bar once the main Add to cart button scrolls off the top
  void _checkCtaVisibility() {
    final ctx = _ctaKey.currentContext;
    if (ctx == null) return;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null || !box.attached) return;

    final top = box.localToGlobal(Offset.zero).dy;
    final scrolledOff = top + box.size.height < MediaQuery.of(context).padding.top;

    if (scrolledOff != _showStickyBar) {
      setState(() => _showStickyBar = scrolledOff);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scroll,
            slivers: [
              const SliverToBoxAdapter(child: AppHeader(showTabs: false)),
              SliverToBoxAdapter(child: _gallery()),
              SliverToBoxAdapter(child: _buyBox()),
              SliverToBoxAdapter(child: _reviewsSection()),
              SliverToBoxAdapter(child: _orderSummary()),
              const SliverToBoxAdapter(child: SectionTitle('You may also like')),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.68,
                  ),
                  delegate: SliverChildBuilderDelegate(
                        (context, i) =>
                        ProductCard(product: _suggestions[i], showHeart: true),
                    childCount: _suggestions.length,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: AppFooter()),
              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          ),

          // Sticky add to cart bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedSlide(
              offset: _showStickyBar ? Offset.zero : const Offset(0, 1),
              duration: const Duration(milliseconds: 220),
              child: _stickyBar(),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Gallery ----------

  Widget _gallery() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: PageView.builder(
                    controller: _pager,
                    itemCount: _images.length,
                    onPageChanged: (i) => setState(() => _image = i),
                    itemBuilder: (_, i) => _imageTile(_images[i]),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () => setState(() => _wishlisted = !_wishlisted),
                    child: Icon(
                      _wishlisted ? Icons.favorite : Icons.favorite_border,
                      size: 22,
                      color: _wishlisted ? const Color(0xFFE5484D) : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 54,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _images.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) => GestureDetector(
                onTap: () => _pager.animateToPage(
                  i,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                ),
                child: Container(
                  width: 54,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: i == _image ? _brown : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: _imageTile(_images[i]),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageTile(String url) {
    final placeholder = Container(
      color: const Color(0xFFF3E3D8),
      child: const Icon(Icons.image_outlined, color: Colors.black26),
    );
    if (url.isEmpty) return placeholder;
    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => placeholder,
    );
  }

  // ---------- Buy box ----------

  Widget _buyBox() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Gisou Honey Infused Hair Oil (0.7 Fl Oz)',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Row(
            children: const [
              Text('5.0', style: TextStyle(fontSize: 12)),
              SizedBox(width: 6),
              RatingStars(),
              SizedBox(width: 6),
              Text('(100)', style: TextStyle(fontSize: 12)),
            ],
          ),
          const SizedBox(height: 6),
          Text.rich(
            TextSpan(
              style: const TextStyle(fontSize: 12),
              children: [
                const TextSpan(text: 'Brand: Gisou  '),
                TextSpan(
                  text: 'Search for similar products',
                  style: const TextStyle(
                    color: Color(0xFF1A73E8),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Intense hydration, long-lasting frizz control, up to 450°F heat '
                'protection, glossy shine, suitable for all hair types',
            style: TextStyle(fontSize: 12, color: Colors.black87, height: 1.4),
          ),
          const SizedBox(height: 12),
          const Text(
            'Tax inclusive \$50.00   Tax exclusive \$48.08',
            style: TextStyle(fontSize: 10, color: Colors.black54),
          ),
          const SizedBox(height: 4),
          const Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '\$50',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text: '.00',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _qtyStepper(),
          const SizedBox(height: 12),
          KeyedSubtree(
            key: _ctaKey,
            child: CustomButton(text: 'Add to cart', color: _brown, onPressed: (){},),
          ),
          const SizedBox(height: 12),
          Center(
            child: GestureDetector(
              onTap: () => setState(() => _wishlisted = !_wishlisted),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _wishlisted ? Icons.favorite : Icons.favorite_border,
                    size: 18,
                    color: _wishlisted ? const Color(0xFFE5484D) : Colors.black87,
                  ),
                  const SizedBox(width: 6),
                  const Text('Add to wishlist', style: TextStyle(fontSize: 13)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: const [
              Icon(Icons.check, size: 16),
              SizedBox(width: 6),
              Text(
                'Pickup available at Hair Haven HQ IDU',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'See more on delivery details below',
            style: TextStyle(
              fontSize: 12,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _qtyStepper() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black26),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => setState(() => _qty = (_qty - 1).clamp(1, 99)),
            icon: const Icon(Icons.remove, size: 18),
          ),
          Text('$_qty', style: const TextStyle(fontSize: 14)),
          IconButton(
            onPressed: () => setState(() => _qty = (_qty + 1).clamp(1, 99)),
            icon: const Icon(Icons.add, size: 18),
          ),
        ],
      ),
    );
  }

  // ---------- Reviews ----------

  Widget _reviewsSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 28, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Customer Reviews (+100)',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _card,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Text(
                      '5.0',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 6),
                    RatingStars(size: 14),
                  ],
                ),
                const SizedBox(height: 2),
                const Text(
                  'Review Policy',
                  style: TextStyle(
                    fontSize: 10,
                    decoration: TextDecoration.underline,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Text('Tags:', style: TextStyle(fontSize: 11)),
                    for (final t in _tags)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.black26),
                        ),
                        child: Text(t, style: const TextStyle(fontSize: 10)),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          for (final r in _reviews) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(r.name, style: const TextStyle(fontSize: 11)),
                Text(
                  r.date,
                  style: const TextStyle(fontSize: 10, color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 3),
            const RatingStars(size: 11),
            const SizedBox(height: 4),
            Text(r.text, style: const TextStyle(fontSize: 11)),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Divider(height: 1, color: Colors.black26),
            ),
          ],
          CustomButton(text: 'View more reviews', color: _brown, onPressed: (){},),
        ],
      ),
    );
  }

  // ---------- Order summary ----------

  Widget _orderSummary() {
    Widget line(String label, String value, {bool bold = false}) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Shipping address',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          line('Subtotal', '\$13,003.87'),
          line('Saved', '-\$4,552.11'),
          line('Promo code', 'Entry'),
          line('Shipping fee', 'Free'),
          const Divider(color: Colors.black26),
          line('Total', '\$8,451.76', bold: true),
          const SizedBox(height: 10),
          CustomButton(text: 'Place Order', color: _brown, onPressed: (){},),
          const SizedBox(height: 8),
          const Text(
            'Terms, refund policy and privacy notice text goes here.',
            style: TextStyle(fontSize: 9, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  // ---------- Sticky bar ----------

  Widget _stickyBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        10,
        16,
        10 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: const BoxDecoration(
        color: _card,
        border: Border(top: BorderSide(color: Colors.black12)),
      ),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '\$50.00',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              Text(
                'Qty $_qty',
                style: const TextStyle(fontSize: 10, color: Colors.black54),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: CustomButton(text: 'Add to cart', color: _brown, onPressed: (){},),
          ),
        ],
      ),
    );
  }
}