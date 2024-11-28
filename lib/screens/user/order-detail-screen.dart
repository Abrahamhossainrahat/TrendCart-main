import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shopping_app/const/app-colors.dart';
import 'package:shopping_app/screens/user/all-category.dart';
import 'package:shopping_app/screens/user/home-screen.dart';
import 'package:shopping_app/screens/user/settings.dart';
import 'package:shopping_app/screens/user/wish-list.dart';

import '../../My Cart/my_cart_view.dart';

class OrderDetailPage extends StatelessWidget {
  final String orderId;

  OrderDetailPage({required this.orderId});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details',style: TextStyle(color: Colors.white),),
        backgroundColor: AppColor.colorRed,
      ),
      body: Container(
        color: AppColor().backgroundColor,
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('orders')
              .doc(orderId)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(child: Text('Order not found'));
            }
        
            var orderData = snapshot.data!.data() as Map<String, dynamic>;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Customer Name: ${orderData['customerName']}'),
                          Text('Customer Phone: ${orderData['customerPhone']}'),
                          Text('Customer Address: ${orderData['customerAddress']}'),
                          Text('Payment Method: ${orderData['paymentMethod']}'),
                          Text('Delivery Time: ${orderData['deliveryTime']}'),
                          Text('Total Price: ${orderData['totalPrice']} TK'),
                          Text('Order Status: ${orderData['status']}'),
                          Text('Placed on: ${orderData['createdAt'].toDate()}'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Items:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  _buildOrderItemsList(orderId),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Wishlist',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category),
              label: 'Categories',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          onTap: (index) {
            switch (index) {
              case 0:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
                break;
              case 1:
                // Handle the Wishlist item tap
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => WishlistScreen()));
                break;
              case 2:
                // Handle the Categories item tap
                Navigator.push(context, MaterialPageRoute(builder: (context)=>AllCategoriesScreen()));
                break;
              case 3:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CartScreen()),
                );
                break;
              case 4:
                // Handle the Profile item tap
                Navigator.push(context, MaterialPageRoute(builder: (context)=>SettingsScreen(email: user!.email.toString(),)));
                break;
            }
          },
        ),
    );
  }

  Widget _buildOrderItemsList(String orderId) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .collection('items')
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No items found'));
        }

        var items = snapshot.data!.docs;
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            var itemData = items[index].data() as Map<String, dynamic>;
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: Text(itemData['product_name']),
                subtitle: Text('Quantity: ${itemData['quantity']} - Price: ${itemData['price']} TK'),
              ),
            );
          },
        );
      },
    );
  }
}
