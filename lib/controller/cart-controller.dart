import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_app/controller/cart-model-controller.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartController extends GetxController {
  final CartModelController _cartModel = CartModelController();
  late String sellerEmail = "";

  List<CartItem> get cartItems => _cartModel.cartItems;

  double get totalPrice => _cartModel.totalPrice;

  void addToCart(CartItem item) {
    _cartModel.addToCart(item);
  }

  void removeFromCart(String productId) {
    _cartModel.removeFromCart(productId);
  }

  void updateQuantity(String productId, int newQuantity) {
    _cartModel.updateQuantity(productId, newQuantity);
  }

  void clearCart() {
    _cartModel.clearCart();
  }

  void email(String s){
    sellerEmail = s;
  }

  Future<bool> updateProductQuantity(String productId, int orderedQuantity) async {
    print('Updating product $productId quantity to $orderedQuantity');
    try {
      DocumentReference productRef = FirebaseFirestore.instance.collection('products').doc(productId);
      DocumentSnapshot productDoc = await productRef.get();
      if (productDoc.exists) {
        int currentQuantity = int.parse(productDoc['quantity']);
        print(currentQuantity);
        if (currentQuantity == 0) {
          print('Product $productId is unavailable');
          return false; // Product is unavailable
        }
        int newQuantity = currentQuantity - orderedQuantity;
        if (newQuantity < 0) {
          print('Insufficient quantity for product $productId');
          return false; // Not enough quantity
        }
        String update = newQuantity.toString();
        await productRef.update({'quantity': update});
        print('Updated product $productId quantity to $update');
        return true; // Quantity updated successfully
      } else {
        print('Product $productId does not exist');
        return false; // Product does not exist
      }
    } catch (error) {
      print('Error updating product quantity: $error');
      return false; // Error occurred
    }
  }

  Future<void> placeOrder(
    List<CartItem> cartItems,
    double totalPrice,
    String customerId,
    String customerName,
    String customerPhone,
    String customerAddress,
    String paymentMethod,
    String deliveryTime,
  ) async {
    try {
      // Get the current user's email
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // Handle the case where there is no logged-in user
        throw Exception("No logged-in user");
      }
      String userEmail = user.email!;

      print("cartItems: $cartItems");
      print("totalPrice: $totalPrice");
      print("customerId: $customerId");
      print("customerName: $customerName");
      print("userEmail: $userEmail");
      print("Seller ID : $sellerEmail");

      // Check product availability and update quantities
      for (var item in cartItems) {
        bool updated = await updateProductQuantity(item.productId, item.quantity);
        if (!updated) {
          print('Order not placed due to product unavailability');
          Get.snackbar(
            'Error',
            'Product ${item.productName} is unavailable or insufficient quantity',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return; // Exit the method if any product is unavailable
        }
      }

      // Add order details to Firestore
      DocumentReference orderRef =
          await FirebaseFirestore.instance.collection('orders').add({
        'customerId': customerId,
        'customerName': customerName,
        'customerPhone': customerPhone,
        'customerAddress': customerAddress,
        'paymentMethod': paymentMethod,
        'deliveryTime': deliveryTime,
        'totalPrice': totalPrice,
        'status': 'Pending', // You can set initial status as 'Pending'
        'createdAt': Timestamp.now(),
        'uniqueId': userEmail,
        'sellerId': sellerEmail,
      });
      print("Order placed successfully");

      // Add cart items to the order
      for (var item in cartItems) {
        await orderRef.collection('items').add({
          'product_id': item.productId,
          'product_name': item.productName,
          'price': item.price,
          'quantity': item.quantity,
        });
      }

      // Clear the cart after placing order
      clearCart();

      // You can show a success message here
    } catch (error) {
      print("Error placing order: $error");
      // Handle any errors
    }
  }
}
