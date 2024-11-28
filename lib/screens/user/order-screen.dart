// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class OrderScreen extends StatelessWidget {
//   const OrderScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('My Orders'),
//       ),
//       body: FutureBuilder<QuerySnapshot>(
//         future: _fetchUserOrders(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(child: Text('No orders found'));
//           }

//           var orders = snapshot.data!.docs;
//           return ListView.builder(
//             itemCount: orders.length,
//             itemBuilder: (context, index) {
//               var orderData = orders[index].data() as Map<String, dynamic>;
//               return ListTile(
//                 title: Text('Order ID: ${orders[index].id}'),
//                 subtitle: Text('Total Price: \$${orderData['totalPrice']}'),
//                 trailing: const Icon(Icons.arrow_forward),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => OrderDetailPage(orderId: orders[index].id),
//                     ),
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }

//   Future<QuerySnapshot> _fetchUserOrders() async {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user == null) {
//       throw Exception("No logged-in user");
//     }
//     String userEmail = user.email!;

//     return await FirebaseFirestore.instance
//         .collection('orders')
//         .where('uniqueId', isEqualTo: userEmail)
//         .get();
//   }
// }

// class OrderDetailPage extends StatelessWidget {
//   final String orderId;

//   OrderDetailPage({required this.orderId});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Order Details'),
//       ),
//       body: FutureBuilder<DocumentSnapshot>(
//         future: FirebaseFirestore.instance
//             .collection('orders')
//             .doc(orderId)
//             .get(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//           if (!snapshot.hasData || !snapshot.data!.exists) {
//             return const Center(child: Text('Order not found'));
//           }

//           var orderData = snapshot.data!.data() as Map<String, dynamic>;
//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: ListView(
//               children: [
//                 Text('Customer Name: ${orderData['customerName']}'),
//                 Text('Customer Phone: ${orderData['customerPhone']}'),
//                 Text('Customer Address: ${orderData['customerAddress']}'),
//                 Text('Payment Method: ${orderData['paymentMethod']}'),
//                 Text('Delivery Time: ${orderData['deliveryTime']}'),
//                 Text('Total Price: \$${orderData['totalPrice']}'),
//                 const SizedBox(height: 20),
//                 const Text('Items:', style: TextStyle(fontWeight: FontWeight.bold)),
//                 _buildOrderItemsList(orderId),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildOrderItemsList(String orderId) {
//     return FutureBuilder<QuerySnapshot>(
//       future: FirebaseFirestore.instance
//           .collection('orders')
//           .doc(orderId)
//           .collection('items')
//           .get(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         }
//         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//           return const Center(child: Text('No items found'));
//         }

//         var items = snapshot.data!.docs;
//         return ListView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           itemCount: items.length,
//           itemBuilder: (context, index) {
//             var itemData = items[index].data() as Map<String, dynamic>;
//             return ListTile(
//               title: Text(itemData['product_name']),
//               subtitle: Text('Quantity: ${itemData['quantity']} - Price: \$${itemData['price']}'),
//             );
//           },
//         );
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shopping_app/const/app-colors.dart';
import 'package:shopping_app/screens/user/all-category.dart';
import 'package:shopping_app/screens/user/home-screen.dart';
import 'package:shopping_app/screens/user/order-detail-screen.dart';
import 'package:shopping_app/screens/user/settings.dart';
import 'package:shopping_app/screens/user/user-details-screen.dart';
import 'package:shopping_app/screens/user/wish-list.dart';

import '../../My Cart/my_cart_view.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    User? user  = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders',style: TextStyle(color: Colors.white),),
        backgroundColor: AppColor.colorRed,
      ),
      body: Container(
        color: AppColor().backgroundColor,
        
        child: FutureBuilder<QuerySnapshot>(
          future: _fetchUserOrders(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No orders found'));
            }
        
            var orders = snapshot.data!.docs;
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                var orderData = orders[index].data() as Map<String, dynamic>;
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text('Order ID: ${orders[index].id}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text('Total Price: ${orderData['totalPrice']} TK'),
                        Text('Order Status: ${orderData['status']}'),
                        Text('Placed on: ${orderData['createdAt'].toDate()}'),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderDetailPage(orderId: orders[index].id),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          selectedItemColor: AppColor.colorGreen,
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

  Future<QuerySnapshot> _fetchUserOrders() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("No logged-in user");
    }
    String userEmail = user.email!;

    return await FirebaseFirestore.instance
        .collection('orders')
        .where('uniqueId', isEqualTo: userEmail)
        .get();
  }
}
