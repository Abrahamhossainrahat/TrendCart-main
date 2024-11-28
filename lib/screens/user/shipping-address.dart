import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shopping_app/const/app-colors.dart';
import 'package:shopping_app/models/address-model.dart';
import 'package:shopping_app/screens/user/all-category.dart';
import 'package:shopping_app/screens/user/home-screen.dart';
import 'package:shopping_app/screens/user/settings.dart';
import 'package:shopping_app/screens/user/user-details-screen.dart';
import 'package:shopping_app/screens/user/wish-list.dart';

import '../../My Cart/my_cart_view.dart'; // Import the Address model

class AddAddressScreen extends StatefulWidget {
  @override
  _AddAddressScreenState createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();

  User? user = FirebaseAuth.instance.currentUser;

  late TextEditingController _addressController;
  late TextEditingController _streetController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _postalCodeController;
  late TextEditingController _countryController;

  late bool _isExistingAddress = false;
  late String _documentId;

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController();
    _streetController = TextEditingController();
    _cityController = TextEditingController();
    _stateController = TextEditingController();
    _postalCodeController = TextEditingController();
    _countryController = TextEditingController();
    fetchExistingAddress();
  }

  Future<void> fetchExistingAddress() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      QuerySnapshot querySnapshot = await firestore
          .collection('addresses')
          .where('email', isEqualTo: user.email)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        final addressData = querySnapshot.docs.first.data() as Map<String, dynamic>;
        setState(() {
          _isExistingAddress = true;
          _documentId = querySnapshot.docs.first.id;
          _addressController.text = addressData['address'] ?? '';
          _streetController.text = addressData['street'] ?? '';
          _cityController.text = addressData['city'] ?? '';
          _stateController.text = addressData['state'] ?? '';
          _postalCodeController.text = addressData['postalCode'] ?? '';
          _countryController.text = addressData['country'] ?? '';
        });
      }
    }
  }

  Future<void> _saveAddress() async {
    if (_formKey.currentState!.validate()) {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        Address address = Address(
          street: _streetController.text,
          city: _cityController.text,
          state: _stateController.text,
          postalCode: _postalCodeController.text,
          country: _countryController.text,
          address: _addressController.text,
          email: user.email!,
        );

        FirebaseFirestore firestore = FirebaseFirestore.instance;
        try {
          if (_isExistingAddress) {
            await firestore.collection('addresses').doc(_documentId).update(address.toMap());
          } else {
            await firestore.collection('addresses').add(address.toMap());
          }

          // Show a success message and navigate back
          Get.snackbar('Success', _isExistingAddress ? 'Address updated successfully!' : 'Address added successfully!',
              snackPosition: SnackPosition.BOTTOM);
          Navigator.pop(context);
        } catch (e) {
          print('Error uploading address: $e');
          // Show an error message to the user
          Get.snackbar('Error', 'Failed to add address. Please try again later.',
              snackPosition: SnackPosition.BOTTOM);
        }
      }
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postalCodeController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Add Address')), // Center-aligned title
          backgroundColor: AppColor.colorRed, // Example color, replace with AppColor.colorRed if defined
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                SizedBox(height: 16),
                TextFormField(
                  controller: _streetController,
                  decoration: InputDecoration(labelText: 'Street'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the street';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _cityController,
                  decoration: InputDecoration(labelText: 'City'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the city';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _stateController,
                  decoration: InputDecoration(labelText: 'Capital'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the state';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _postalCodeController,
                  decoration: InputDecoration(labelText: 'Postal Code'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the postal code';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _countryController,
                  decoration: InputDecoration(labelText: 'Country'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the country';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 32),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(labelText: 'Address'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _saveAddress,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.colorRed, // Example color, replace with AppColor.colorRed if defined
                  ),
                  child: Text('Save Address' , style: TextStyle(color: Colors.white),),
                ),
              ],
            ),
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
      ),
    );
  }
}
