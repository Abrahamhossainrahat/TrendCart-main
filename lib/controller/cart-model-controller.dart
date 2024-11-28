// class CartItem {
//   final String productId;
//   final String productName;
//   final String productImage;
//   final double price;
//   int quantity;

//   CartItem({
//     required this.productId,
//     required this.productName,
//     required this.productImage,
//     required this.price,
//     required this.quantity,
//   });

//   double get total => price * quantity;

//   factory CartItem.fromJson(Map<String, dynamic> json) {
//     return CartItem(
//       productId: json['productId'],
//       productName: json['productName'],
//       productImage: json['productImage'],
//       price: json['price'].toDouble(),
//       quantity: json['quantity'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'productId': productId,
//       'productName': productName,
//       'productImage': productImage,
//       'price': price,
//       'quantity': quantity,
//     };
//   }
// }

import 'package:flutter/material.dart';

class CartItem {
  final String productId;
  final String productName;
  final String productImage;
  final String price;
  int quantity;

  CartItem({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    this.quantity = 1,
  });
  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'productImage': productImage,
      'price': price,
      'quantity': quantity,
    };
  }
}

class CartModelController extends ChangeNotifier {
  List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  double get totalPrice {
    double total = 0;
    _cartItems.forEach((item) {
      total += double.parse(item.price) * item.quantity;
    });
    return total;
  }

  void addToCart(CartItem item) {
    _cartItems.add(item);
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _cartItems.removeWhere((item) => item.productId == productId);
    notifyListeners();
  }

  void updateQuantity(String productId, int newQuantity) {
    _cartItems.firstWhere((item) => item.productId == productId).quantity =
        newQuantity;
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
