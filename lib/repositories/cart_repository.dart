import '../models/cart_item.dart';
import '../models/product.dart';
import '../services/api/api_client.dart';

abstract class CartRepository {
  Future<List<CartItem>> getCartItems();
  Future<List<CartItem>> addToCart(Product product, {int quantity = 1});
  Future<List<CartItem>> updateQuantity(String cartItemId, int newQuantity);
  Future<List<CartItem>> removeFromCart(String cartItemId);
  Future<void> clearCart();
}

/// Implementation of [CartRepository].
///
/// TODO(API INTEGRATION):
/// Replace local storage array and methods with [_apiClient] endpoints once the Postman collection is provided.
class CartRepositoryImpl implements CartRepository {
  final ApiClient _apiClient;

  CartRepositoryImpl({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  ApiClient get apiClient => _apiClient;

  final List<CartItem> _localCart = [
    CartItem(
      id: 'cart_item_1',
      productId: 'prod_104',
      title: '1pc/3pcs multicolor Synthetic Hair Extensions, Sew-In',
      seller: 'Fajiahstore',
      price: 3.99,
      quantity: 2,
    ),
    CartItem(
      id: 'cart_item_2',
      productId: 'prod_105',
      title: '3pc Hair Beauty clips',
      seller: 'Fajiahstore',
      price: 3.99,
      quantity: 2,
    ),
    CartItem(
      id: 'cart_item_3',
      productId: 'prod_106',
      title: '1 Pack Black Afro Kinkys Bulk Hair 12/16 Inch',
      seller: 'Fajiahstore',
      price: 3.99,
      quantity: 2,
    ),
  ];

  @override
  Future<List<CartItem>> getCartItems() async {
    // TODO(API INTEGRATION): Replace with _apiClient.get(ApiConfig.cart);
    await Future.delayed(const Duration(milliseconds: 100));
    return List.unmodifiable(_localCart);
  }

  @override
  Future<List<CartItem>> addToCart(Product product, {int quantity = 1}) async {
    // TODO(API INTEGRATION): Replace with _apiClient.post(ApiConfig.cart, body: {'productId': product.id, 'quantity': quantity});
    await Future.delayed(const Duration(milliseconds: 150));

    final index = _localCart.indexWhere((item) => item.productId == product.id || item.title == product.title);
    if (index >= 0) {
      _localCart[index].quantity += quantity;
    } else {
      _localCart.add(
        CartItem(
          id: 'cart_${DateTime.now().millisecondsSinceEpoch}',
          productId: product.id,
          title: product.title,
          seller: product.brand.isNotEmpty ? product.brand : 'Hair Haven',
          price: product.numericPrice > 0 ? product.numericPrice : 27.89,
          quantity: quantity,
          size: product.size,
        ),
      );
    }
    return List.unmodifiable(_localCart);
  }

  @override
  Future<List<CartItem>> updateQuantity(String cartItemId, int newQuantity) async {
    // TODO(API INTEGRATION): Replace with _apiClient.put(ApiConfig.cartItem(cartItemId), body: {'quantity': newQuantity});
    await Future.delayed(const Duration(milliseconds: 100));

    final index = _localCart.indexWhere((item) => item.id == cartItemId);
    if (index >= 0) {
      if (newQuantity <= 0) {
        _localCart.removeAt(index);
      } else {
        _localCart[index].quantity = newQuantity;
      }
    }
    return List.unmodifiable(_localCart);
  }

  @override
  Future<List<CartItem>> removeFromCart(String cartItemId) async {
    // TODO(API INTEGRATION): Replace with _apiClient.delete(ApiConfig.cartItem(cartItemId));
    await Future.delayed(const Duration(milliseconds: 100));

    _localCart.removeWhere((item) => item.id == cartItemId);
    return List.unmodifiable(_localCart);
  }

  @override
  Future<void> clearCart() async {
    // TODO(API INTEGRATION): Replace with _apiClient.delete(ApiConfig.cart);
    await Future.delayed(const Duration(milliseconds: 100));
    _localCart.clear();
  }
}
