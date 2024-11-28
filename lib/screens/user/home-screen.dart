import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shopping_app/My%20Cart/my_cart_view.dart';
import 'package:shopping_app/const/app-colors.dart';
import 'package:shopping_app/controller/cart-controller.dart';
import 'package:shopping_app/controller/wishlist-controller.dart';
import 'package:shopping_app/screens/auth-ui/welcome-screen.dart';
import 'package:shopping_app/screens/user/all-category.dart';
import 'package:shopping_app/screens/user/settings.dart';
import 'package:shopping_app/screens/user/view-all.dart'; // Make sure this import is correct
import 'package:shopping_app/screens/user/wish-list.dart';
import 'package:shopping_app/widgets/banner-widget.dart';
import 'package:shopping_app/widgets/custom-drawer-widget.dart';
import 'package:shopping_app/widgets/heading-widget.dart';
import '../../widgets/Categories.dart';
import 'search-result-screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CartController cartController = Get.put(CartController());
  TextEditingController searchController = TextEditingController();
  WishlistController wishlistController = Get.put(WishlistController());
  User? user = FirebaseAuth.instance.currentUser;
  late String password;
  var _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchPassword();
  }

  Future<void> fetchPassword() async {
    try {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      setState(() {
        password = userData['password'];
      });
    } catch (e) {
      print("Failed to fetch password: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: const Text(
            "Home",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () async {
                await _auth.signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          WelcomeScreen(user: user, password: password)),
                );
              },
            ),
          ],
          backgroundColor: AppColor.colorRed,
        ),
        drawer: DrawerWidget(),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: AppColor.bgColor,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: TextFormField(
                    controller: searchController,
                    keyboardType: TextInputType.emailAddress,
                    onFieldSubmitted: (value) {
                      if (value.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SearchResultsScreen(query: value),
                          ),
                        );
                      }
                    },
                    decoration: InputDecoration(
                      hintText: "Search for products",
                      labelText: "Search",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                HeadingWidget(
                  headingTitle: "Just for you",
                  subTitle: "Recommended",
                  buttonText: "View All",
                  onTap: () {
                    // Provide categoryId and categoryName here
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewAllScreen(
                          productId:
                              "easy-shopping-6145d",
                          productName:
                              "Richman Cotton Shirt", // Replace with actual categoryName
                        ),
                      ),
                    );
                  },
                ),
                BannerWidget(),
                HeadingWidget(
                  headingTitle: "Categories",
                  subTitle: "Explore the categories",
                  buttonText: "View All",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AllCategoriesScreen(),
                      ),
                    );
                  },
                ),
                Categories(),
                SizedBox(
                  height: 20.h,
                ),
                HeadingWidget(
                  headingTitle: "Popular Items",
                  subTitle: "Choose what you like",
                  buttonText: "View All",
                  onTap: () {
                    // Handle the tap event
                     Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewAllScreen(
                          productId:
                              "easy-shopping-6145d",
                          productName:
                              "Richman Cotton Shirt", // Replace with actual categoryName
                        ),
                      ),
                    );
                  },
                ),
                BannerWidget(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          elevation: 5,
          currentIndex: _currentIndex,
          selectedItemColor: Colors.green,
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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
                break;
              case 1:
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => WishlistScreen()));
                break;
              case 2:
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AllCategoriesScreen()));
                break;
              case 3:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CartScreen()),
                );
                break;
              case 4:
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SettingsScreen(
                              email: user!.email.toString(),
                            )));
                break;
            }
          },
        ),
      ),
    );
  }
}
