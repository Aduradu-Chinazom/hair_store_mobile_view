import '../models/category_model.dart';
import '../models/product.dart';
import '../services/api/api_client.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts({
    String? category,
    String? searchQuery,
    String? sortBy,
    Set<String>? filters,
    int page = 1,
  });

  Future<List<CategoryModel>> getCategories();
  Future<Product?> getProductById(String id);
  Future<List<Product>> getPackageDeals();
  Future<List<Product>> getGiftsForHer();
  Future<List<Product>> getRecommendations();
  Future<List<String>> getBrands();
}

/// Implementation of [ProductRepository].
///
/// TODO(API INTEGRATION):
/// Replace mock response blocks with [_apiClient] calls once the Postman collection is provided.
class ProductRepositoryImpl implements ProductRepository {
  final ApiClient _apiClient;

  ProductRepositoryImpl({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  ApiClient get apiClient => _apiClient;

  @override
  Future<List<Product>> getProducts({
    String? category,
    String? searchQuery,
    String? sortBy,
    Set<String>? filters,
    int page = 1,
  }) async {
    // TODO(API INTEGRATION): Replace with _apiClient.get(ApiConfig.products, queryParameters: {...});
    await Future.delayed(const Duration(milliseconds: 300));

    final baseList = [
      const Product(
        id: 'prod_101',
        title: '5+5 200% Brown Density Body wave',
        price: '\$27.89',
        imageUrl: '',
        size: '20 inches',
        brand: 'Cantu',
        category: 'Wigs',
      ),
      const Product(
        id: 'prod_102',
        title: 'Gisou Honey Infused Hair Oil',
        price: '\$15.50',
        imageUrl: '',
        size: '(30ml)',
        brand: 'Gisou',
        category: 'Oils',
      ),
      const Product(
        id: 'prod_103',
        title: 'Olaplex No. 3 Hair Perfector',
        price: '\$9.50',
        imageUrl: '',
        size: '(100ml)',
        brand: 'Olaplex',
        category: 'Hair Tools',
      ),
      const Product(
        id: 'prod_104',
        title: '1pc Multicolor Synthetic Extensions',
        price: '\$3.99',
        imageUrl: '',
        size: 'Standard',
        brand: 'Shein',
        category: 'Hair Extensions',
      ),
      const Product(
        id: 'prod_105',
        title: '3pc Hair Beauty Clips',
        price: '\$12.00',
        imageUrl: '',
        size: 'Pack of 3',
        brand: 'Revlon',
        category: 'Accessories',
      ),
      const Product(
        id: 'prod_106',
        title: '1 Pack Black Afro Kinky Bulk Hair',
        price: '\$45.00',
        imageUrl: '',
        size: '12/16 Inch',
        brand: 'Bio:Ionic',
        category: 'Hair Extensions',
      ),
    ];

    var filtered = baseList;

    if (category != null && category.isNotEmpty && category != 'All Categories') {
      filtered = filtered.where((p) => p.category.toLowerCase() == category.toLowerCase()).toList();
    }

    if (searchQuery != null && searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      filtered = filtered
          .where((p) =>
              p.title.toLowerCase().contains(q) ||
              p.brand.toLowerCase().contains(q) ||
              p.category.toLowerCase().contains(q))
          .toList();
    }

    return filtered.isNotEmpty ? filtered : baseList;
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    // TODO(API INTEGRATION): Replace with _apiClient.get(ApiConfig.categories);
    await Future.delayed(const Duration(milliseconds: 200));

    return const [
      CategoryModel(id: 'cat_1', name: 'Hair Extensions'),
      CategoryModel(id: 'cat_2', name: 'Hair Tools'),
      CategoryModel(id: 'cat_3', name: 'Accessories'),
      CategoryModel(id: 'cat_4', name: 'Wigs'),
      CategoryModel(id: 'cat_5', name: 'Oils'),
    ];
  }

  @override
  Future<Product?> getProductById(String id) async {
    // TODO(API INTEGRATION): Replace with _apiClient.get(ApiConfig.productDetail(id));
    await Future.delayed(const Duration(milliseconds: 200));

    return Product(
      id: id,
      title: 'Gisou Honey Infused Hair Oil (0.7 Fl Oz)',
      price: '\$50.00',
      size: '(30ml)',
      description:
          'Intense hydration, long-lasting frizz control, up to 450°F heat protection, glossy shine, suitable for all hair types.',
      brand: 'Gisou',
      category: 'Oils',
      rating: 5.0,
      reviewCount: 100,
      tags: const [
        'Great smell',
        'Nice gift',
        'Good packaging',
        'Elegant',
        'Nice',
        'Really pretty'
      ],
    );
  }

  @override
  Future<List<Product>> getPackageDeals() async {
    return List.generate(
      2,
      (i) => Product(
        id: 'pkg_$i',
        title: 'Mommy and Me hair care package',
        price: '\$45.00',
        category: 'Packages',
      ),
    );
  }

  @override
  Future<List<Product>> getGiftsForHer() async {
    return List.generate(
      2,
      (i) => Product(
        id: 'gift_$i',
        title: 'Luxury Satin Bonnet & Silk Pillowcase Set',
        price: '\$35.00',
        category: 'Gifts',
      ),
    );
  }

  @override
  Future<List<Product>> getRecommendations() async {
    return List.generate(
      6,
      (i) => Product(
        id: 'rec_$i',
        title: 'Olaplex No. 3 Hair Perfector',
        price: '\$9.50',
        size: '(100ml)',
      ),
    );
  }

  @override
  Future<List<String>> getBrands() async {
    return const [
      'Cantu',
      'Jon Renau',
      'Olaplex',
      'Bio:Ionic',
      'Gisou',
      'Shein',
      'Revlon',
      'Remington',
    ];
  }
}
