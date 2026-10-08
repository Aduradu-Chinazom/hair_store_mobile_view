import 'cart_item.dart';

class OrderModel {
  final String id;
  final List<CartItem> items;
  final double subtotal;
  final double discount;
  final double shippingFee;
  final double totalAmount;
  final String email;
  final String fullName;
  final String address;
  final String state;
  final String country;
  final String postalCode;
  final String telephone;
  final String paymentMethod;
  final String status;
  final DateTime createdAt;

  const OrderModel({
    required this.id,
    required this.items,
    required this.subtotal,
    this.discount = 0.0,
    this.shippingFee = 0.0,
    required this.totalAmount,
    required this.email,
    required this.fullName,
    required this.address,
    required this.state,
    required this.country,
    required this.postalCode,
    required this.telephone,
    required this.paymentMethod,
    required this.status,
    required this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>? ?? [];
    return OrderModel(
      id: json['id']?.toString() ?? '',
      items: rawItems.map((e) => CartItem.fromJson(e as Map<String, dynamic>)).toList(),
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      shippingFee: (json['shippingFee'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      email: json['email']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? json['full_name']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
      postalCode: json['postalCode']?.toString() ?? json['postal_code']?.toString() ?? '',
      telephone: json['telephone']?.toString() ?? json['phone']?.toString() ?? '',
      paymentMethod: json['paymentMethod']?.toString() ?? json['payment_method']?.toString() ?? 'Card',
      status: json['status']?.toString() ?? 'Pending',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((e) => e.toJson()).toList(),
      'subtotal': subtotal,
      'discount': discount,
      'shippingFee': shippingFee,
      'totalAmount': totalAmount,
      'email': email,
      'fullName': fullName,
      'address': address,
      'state': state,
      'country': country,
      'postalCode': postalCode,
      'telephone': telephone,
      'paymentMethod': paymentMethod,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
