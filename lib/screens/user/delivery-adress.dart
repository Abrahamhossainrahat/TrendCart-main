// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';
// import 'package:shopping_app/screens/user/all-category.dart';
// import 'package:shopping_app/screens/user/home-screen.dart';

// import '../../My Cart/my_cart_view.dart';
// import '../../models/address-model.dart';
// import 'wish-list.dart'; // Adjust the import as needed

// class AddressScreen extends StatefulWidget {
//   @override
//   _AddressScreenState createState() => _AddressScreenState();
// }

// class _AddressScreenState extends State<AddressScreen> {
//   final User? user = FirebaseAuth.instance.currentUser;
//   final TextEditingController streetController = TextEditingController();
//   final TextEditingController cityController = TextEditingController();
//   final TextEditingController stateController = TextEditingController();
//   final TextEditingController postalCodeController = TextEditingController();
//   final TextEditingController countryController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController addressController = TextEditingController();

//   bool isLoading = true;
//   DocumentSnapshot? addressSnapshot;

//   @override
//   void initState() {
//     super.initState();
//     fetchAddress();
//   }

//   Future<void> fetchAddress() async {
//     if (user != null) {
//       final doc = await FirebaseFirestore.instance
//           .collection('addresses')
//           .doc(user!.uid)
//           .get();

//       if (doc.exists) {
//         setState(() {
//           addressSnapshot = doc;
//           Address address = Address.fromMap(doc.data() as Map<String, dynamic>);
//           streetController.text = address.street;
//           cityController.text = address.city;
//           stateController.text = address.state;
//           postalCodeController.text = address.postalCode;
//           countryController.text = address.country;
//           emailController.text = address.email;
//           addressController.text = address.address;
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           isLoading = false;
//         });
//       }
//     }
//   }

//   Future<void> saveAddress() async {
//     if (user != null) {
//       Address address = Address(
//         street: streetController.text.trim(),
//         city: cityController.text.trim(),
//         state: stateController.text.trim(),
//         postalCode: postalCodeController.text.trim(),
//         country: countryController.text.trim(),
//         email: emailController.text.trim(),
//         address: addressController.text.trim(),
//       );

//       await FirebaseFirestore.instance
//           .collection('addresses')
//           .doc(user!.uid)
//           .set(address.toMap());

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Address updated successfully')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: IconThemeData(color: Colors.white),
//         backgroundColor: Colors.red,
//         title: Text('Your Address', style: TextStyle(color: Colors.white)),
//       ),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     TextField(
//                       controller: streetController,
//                       decoration: InputDecoration(
//                         labelText: 'Street',
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     TextField(
//                       controller: cityController,
//                       decoration: InputDecoration(
//                         labelText: 'City',
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     TextField(
//                       controller: stateController,
//                       decoration: InputDecoration(
//                         labelText: 'State',
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     TextField(
//                       controller: postalCodeController,
//                       decoration: InputDecoration(
//                         labelText: 'Postal Code',
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     TextField(
//                       controller: countryController,
//                       decoration: InputDecoration(
//                         labelText: 'Country',
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     TextField(
//                       controller: emailController,
//                       decoration: InputDecoration(
//                         labelText: 'Email',
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     TextField(
//                       controller: addressController,
//                       decoration: InputDecoration(
//                         labelText: 'Address',
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     ElevatedButton(
//                       onPressed: saveAddress,
//                       child: Text('Save Address'),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             bottomNavigationBar: BottomNavigationBar(
//           currentIndex: 0,
//           selectedItemColor: Colors.red,
//           unselectedItemColor: Colors.grey,
//           items: const [
//             BottomNavigationBarItem(
//               icon: Icon(Icons.home),
//               label: 'Home',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.favorite),
//               label: 'Wishlist',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.category),
//               label: 'Categories',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.shopping_cart),
//               label: 'Cart',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.person),
//               label: 'Profile',
//             ),
//           ],
//           onTap: (index) {
//             switch (index) {
//               case 0:
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => HomeScreen()),
//                 );
//                 break;
//               case 1:
//                 // Handle the Wishlist item tap
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => WishlistScreen()));
//                 break;
//               case 2:
//                 // Handle the Categories item tap
//                 Get.offAll(AllCategoriesScreen());
//                 break;
//               case 3:
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => CartScreen()),
//                 );
//                 break;
//               case 4:
//                 // Handle the Profile item tap
//                 break;
//             }
//           },
//         ),
//     );
//   }
// }
