import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../models/product.dart';
import '../repositories/product_repository.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepository _productRepository;

  bool _isLoading = false;
  String? _errorMessage;

  List<Product> _products = [];
  List<CategoryModel> _categories = [];
  List<Product> _packageDeals = [];
  List<Product> _giftsForHer = [];
  List<Product> _recommendations = [];
  List<String> _brands = [];

  Product? _selectedProduct;
  String _selectedCategory = 'All Categories';
  String _searchQuery = '';
  String _sortBy = 'Featured';
  Set<String> _activeFilters = {};

  ProductProvider({ProductRepository? productRepository})
      : _productRepository = productRepository ?? ProductRepositoryImpl();

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<Product> get products => _products;
  List<CategoryModel> get categories => _categories;
  List<Product> get packageDeals => _packageDeals;
  List<Product> get giftsForHer => _giftsForHer;
  List<Product> get recommendations => _recommendations;
  List<String> get brands => _brands;

  Product? get selectedProduct => _selectedProduct;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  String get sortBy => _sortBy;
  Set<String> get activeFilters => _activeFilters;

  Future<void> loadHomeData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _productRepository.getProducts(),
        _productRepository.getCategories(),
        _productRepository.getPackageDeals(),
        _productRepository.getGiftsForHer(),
      ]);

      _products = results[0] as List<Product>;
      _categories = results[1] as List<CategoryModel>;
      _packageDeals = results[2] as List<Product>;
      _giftsForHer = results[3] as List<Product>;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadShopAllData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _productRepository.getProducts(
          category: _selectedCategory,
          searchQuery: _searchQuery,
          sortBy: _sortBy,
          filters: _activeFilters,
        ),
        _productRepository.getRecommendations(),
        _productRepository.getBrands(),
      ]);

      _products = results[0] as List<Product>;
      _recommendations = results[1] as List<Product>;
      _brands = results[2] as List<String>;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadProductDetails(String productId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _selectedProduct = await _productRepository.getProductById(productId);
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectCategory(String categoryName) {
    _selectedCategory = categoryName;
    loadShopAllData();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    loadShopAllData();
  }

  void setSortBy(String sort) {
    _sortBy = sort;
    loadShopAllData();
  }

  void setFilters(Set<String> filters) {
    _activeFilters = filters;
    loadShopAllData();
  }

  void setSelectedProduct(Product product) {
    _selectedProduct = product;
    notifyListeners();
  }

  void toggleWishlist(String productId) {
    _products = _products.map((p) {
      if (p.id == productId) {
        return p.copyWith(isWishlisted: !p.isWishlisted);
      }
      return p;
    }).toList();

    if (_selectedProduct?.id == productId) {
      _selectedProduct = _selectedProduct!.copyWith(
        isWishlisted: !_selectedProduct!.isWishlisted,
      );
    }

    notifyListeners();
  }
}
