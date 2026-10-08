import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import '../repositories/cart_repository.dart';

class CartProvider extends ChangeNotifier {
  final CartRepository _cartRepository;

  bool _isLoading = false;
  String? _errorMessage;
  List<CartItem> _items = [];

  CartProvider({CartRepository? cartRepository})
      : _cartRepository = cartRepository ?? CartRepositoryImpl();

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<CartItem> get items => _items;

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  double get shippingFee => _items.isEmpty ? 0.0 : 0.0; // Free shipping promo
  double get total => subtotal + shippingFee;

  String get formattedSubtotal => '\$${subtotal.toStringAsFixed(2)}';
  String get formattedTotal => '\$${total.toStringAsFixed(2)}';

  Future<void> loadCart() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _items = await _cartRepository.getCartItems();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addToCart(Product product, {int quantity = 1}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _items = await _cartRepository.addToCart(product, quantity: quantity);
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> incrementQuantity(CartItem item) async {
    try {
      _items = await _cartRepository.updateQuantity(item.id, item.quantity + 1);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  Future<void> decrementQuantity(CartItem item) async {
    try {
      if (item.quantity > 1) {
        _items = await _cartRepository.updateQuantity(item.id, item.quantity - 1);
      } else {
        _items = await _cartRepository.removeFromCart(item.id);
      }
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  Future<void> removeItem(CartItem item) async {
    try {
      _items = await _cartRepository.removeFromCart(item.id);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  Future<void> clearCart() async {
    try {
      await _cartRepository.clearCart();
      _items = [];
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }
}
