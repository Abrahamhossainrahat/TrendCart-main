//ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables , unused_field, prefer_final_fields
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shopping_app/My%20Cart/my_cart_view.dart';
import 'package:shopping_app/const/app-colors.dart';
import 'package:shopping_app/controller/get-user-data-controller.dart';
import 'package:shopping_app/screens/auth-ui/forgot-password-screen.dart';
import 'package:shopping_app/screens/auth-ui/welcome-screen.dart';
import 'package:shopping_app/screens/user/order-screen.dart';
import 'package:shopping_app/screens/user/settings.dart';
import 'package:shopping_app/screens/user/user-details-screen.dart';
import 'package:shopping_app/screens/user/wish-list.dart';

class DrawerWidget extends StatelessWidget {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  GetUserDataController getUserDataController = Get.put(GetUserDataController());

  User? user = FirebaseAuth.instance.currentUser;

  Future<String> fetchPasswordFromFirestore(String uid) async {
    try {
      // Fetch password from Firestore
      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      return snapshot['password']; // Assuming 'password' is a field in your 'users' collection
    } catch (e) {
      print('Error fetching password: $e');
      return ''; // Handle error as per your app's requirements
    }
  }

  Future<Map<String, dynamic>> fetchUserData() async {
    if (user == null) {
      return {};
    }

    DocumentSnapshot snapshot = await _firestore.collection('users').doc(user!.uid).get();
    return snapshot.data() as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder<Map<String, dynamic>>(
        future: fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No user data found.'));
          } else {
            Map<String, dynamic> userData = snapshot.data!;
            String? name = userData['name'];

            return ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                ListTile(
                  tileColor: AppColor.colorRed,
                  iconColor: Colors.white,
                  leading: Icon(Icons.arrow_back),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: AppColor.colorRed,
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image(
                          image: AssetImage('assets/user/user.png'),
                          height: 50.h,
                          width: 50.w,
                        ),
                      ),
                      Text(
                        name ?? 'No Name',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  //iconColor: Colors.yellow,
                  leading: Icon(Icons.account_circle),
                  title: Text('Account Information'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserDetailsScreen(), // Pass the user's email
                      ),
                    ); // Close the drawer
                  },
                ),
                ListTile(
                  leading: Icon(Icons.lock),
                  title: Text('Password '),
                  onTap: () {
                    // Add your navigation logic here
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForgotPasswordScreen()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.shopping_cart),
                  title: Text('My Cart'),
                  onTap: () {
                    // Add your navigation logic here
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CartScreen())); // Close the drawer
                  },
                ),
                ListTile(
                  leading: Icon(Icons.shopping_bag),
                  title: Text('Order'),
                  onTap: () {
                    // Add your navigation logic here
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OrderScreen())); // Close the drawer
                  },
                ),
                ListTile(
                  leading: Icon(Icons.favorite),
                  title: Text('Wishlist'),
                  onTap: () {
                    // Add your navigation logic here
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => WishlistScreen()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                  onTap: () {
                    // Add your navigation logic here
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen(email: user!.email.toString())));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Log out'),
                  onTap: () async {
                    // Fetch the password from Firestore or any secure storage
                    String password = await fetchPasswordFromFirestore(user!.uid);

                    // Navigate to WelcomeScreen with user and password
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WelcomeScreen(user: user, password: password)),
                    );

                    // Sign out of Firebase
                    auth.signOut();
                  },
                ),
                // Add more ListTiles for additional items
              ],
            );
          }
        },
      ),
    );
  }
}
