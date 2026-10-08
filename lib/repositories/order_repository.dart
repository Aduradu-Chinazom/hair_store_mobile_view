import '../models/order_model.dart';
import '../services/api/api_client.dart';

abstract class OrderRepository {
  Future<OrderModel> createOrder(OrderModel order);
  Future<List<OrderModel>> getOrders();
  Future<OrderModel?> getOrderById(String orderId);
}

/// Implementation of [OrderRepository].
///
/// TODO(API INTEGRATION):
/// Replace mock response blocks with [_apiClient] calls once the Postman collection is provided.
class OrderRepositoryImpl implements OrderRepository {
  final ApiClient _apiClient;

  OrderRepositoryImpl({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  ApiClient get apiClient => _apiClient;

  final List<OrderModel> _orders = [];

  @override
  Future<OrderModel> createOrder(OrderModel order) async {
    // TODO(API INTEGRATION): Replace with _apiClient.post(ApiConfig.orders, body: order.toJson());
    await Future.delayed(const Duration(milliseconds: 500));

    final createdOrder = OrderModel(
      id: 'ord_${DateTime.now().millisecondsSinceEpoch}',
      items: order.items,
      subtotal: order.subtotal,
      discount: order.discount,
      shippingFee: order.shippingFee,
      totalAmount: order.totalAmount,
      email: order.email,
      fullName: order.fullName,
      address: order.address,
      state: order.state,
      country: order.country,
      postalCode: order.postalCode,
      telephone: order.telephone,
      paymentMethod: order.paymentMethod,
      status: 'Confirmed',
      createdAt: DateTime.now(),
    );

    _orders.insert(0, createdOrder);
    return createdOrder;
  }

  @override
  Future<List<OrderModel>> getOrders() async {
    // TODO(API INTEGRATION): Replace with _apiClient.get(ApiConfig.orders);
    await Future.delayed(const Duration(milliseconds: 200));
    return List.unmodifiable(_orders);
  }

  @override
  Future<OrderModel?> getOrderById(String orderId) async {
    // TODO(API INTEGRATION): Replace with _apiClient.get(ApiConfig.orderDetail(orderId));
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _orders.firstWhere((o) => o.id == orderId);
    } catch (_) {
      return null;
    }
  }
}
