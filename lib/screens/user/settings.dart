import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shopping_app/My%20Cart/my_cart_view.dart';
import 'package:shopping_app/const/app-colors.dart';
import 'package:shopping_app/models/user-model.dart';
import 'package:shopping_app/screens/user/all-category.dart';
import 'package:shopping_app/screens/user/home-screen.dart';
import 'package:shopping_app/screens/user/user-details-screen.dart';
import 'package:shopping_app/screens/user/wish-list.dart';

class SettingsScreen extends StatefulWidget {
  final String email;

  SettingsScreen({required this.email});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController roadController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  var _currentIndex = 4;
  bool isLoading = true;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('users')
          .where('email', isEqualTo: widget.email)
          .limit(1)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        Map<String, dynamic> userData =
            querySnapshot.docs.first.data() as Map<String, dynamic>;
        setState(() {
          nameController.text = userData['name'] ?? '';
          phoneController.text = userData['phone'] ?? '';
          emailController.text = userData['email'] ?? '';
          cityController.text = userData['city'] ?? '';
          stateController.text = userData['state'] ?? '';
          countryController.text = userData['country'] ?? '';
          roadController.text = userData['road'] ?? '';
          postalCodeController.text = userData['postalCode'] ?? '';
          addressController.text = userData['adress'] ?? '';
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        Get.snackbar('Error', 'User not found');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Get.snackbar('Error', 'Error fetching user data: $e');
    }
  }

  void updateUserData() async {
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('users')
          .where('email', isEqualTo: widget.email)
          .limit(1)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        await firestore
            .collection('users')
            .doc(querySnapshot.docs.first.id)
            .update({
          'name': nameController.text.trim(),
          'phone': phoneController.text.trim(),
          'email': emailController.text.trim(),
          'city': cityController.text.trim(),
          'state': stateController.text.trim(),
          'country': countryController.text.trim(),
          'road': roadController.text.trim(),
          'postalCode': postalCodeController.text.trim(),
          'adress': addressController.text.trim(),
        });
        setState(() {
          isEditing = false;
        });
        Get.snackbar('Success', 'User information updated successfully');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update user information: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Details',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColor.colorRed,
        actions: [
          isEditing
              ? IconButton(
                  icon: Icon(Icons.save),
                  onPressed: updateUserData,
                )
              : IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    setState(() {
                      isEditing = true;
                    });
                  },
                ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              color: AppColor().backgroundColor,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildUserInfoRow(
                          'Username', nameController, Icons.person),
                      _buildDivider(),
                      _buildUserInfoRow('Email', emailController, Icons.email,
                          isEditable: false),
                      _buildDivider(),
                      _buildUserInfoRow('Phone', phoneController, Icons.phone),
                      _buildDivider(),
                      _buildUserInfoRow(
                          'City', cityController, Icons.location_city),
                      _buildDivider(),
                      _buildUserInfoRow('State', stateController, Icons.map),
                      _buildDivider(),
                      _buildUserInfoRow(
                          'Country', countryController, Icons.flag),
                      _buildDivider(),
                      _buildUserInfoRow('Road', roadController, Icons.add_road),
                      _buildDivider(),
                      _buildUserInfoRow('Postal Code', postalCodeController,
                          Icons.markunread_mailbox),
                      _buildDivider(),
                      _buildUserInfoRow(
                          'Address', addressController, Icons.home),
                    ],
                  ),
                ),
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
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
            Navigator.push(context, MaterialPageRoute(builder: (context)=>SettingsScreen(email: FirebaseAuth.instance.currentUser!.email.toString(),)));
              break;
          }
        },
      ),
    );
  }

  Widget _buildUserInfoRow(
      String title, TextEditingController controller, IconData icon,
      {bool isEditable = true}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColor.colorLightRed, size: 30),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              TextField(
                controller: controller,
                readOnly: !isEditable || !isEditing,
                decoration: InputDecoration(
                  border: isEditable ? OutlineInputBorder() : InputBorder.none,
                  isDense: true,
                ),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 30,
      thickness: 1,
      color: Colors.grey[300],
    );
  }
}
