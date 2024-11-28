import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:shopping_app/const/app-colors.dart';
import 'package:shopping_app/models/product-model.dart';
import 'package:shopping_app/screens/user/settings.dart';
import 'package:shopping_app/screens/user/single-category-product-screen.dart';
import 'package:shopping_app/screens/user/wish-list.dart';
import '../../controller/wishlist-controller.dart';
import '../../models/Category-model.dart';
import '../../My Cart/my_cart_view.dart';
import 'home-screen.dart';

class AllCategoriesScreen extends StatelessWidget {
  AllCategoriesScreen({Key? key}) : super(key: key);

  WishlistController wishlistController = Get.put(WishlistController());
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor().backgroundColor,
        appBar: AppBar(
          iconTheme: IconThemeData(
           // color: AppColor.colorGray,
          ),
          backgroundColor: AppColor.colorRed,
          title: Text(
            "All Categories",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder(
            future: FirebaseFirestore.instance.collection("categories").get(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text("Error: ${snapshot.error}"),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                return GridView.builder(
                  itemCount: snapshot.data!.docs.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 3,
                    crossAxisSpacing: 3,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    CategoriesModel categoriesModel = CategoriesModel(
                      categoryId: snapshot.data!.docs[index]['categoryId'],
                      categoryImg: snapshot.data!.docs[index]['categoryImg'],
                      categoryName: snapshot.data!.docs[index]['categoryName'],
                      createdAt: snapshot.data!.docs[index]['createdAt'],
                      updatedAt: snapshot.data!.docs[index]['updatedAt'],
                    );
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SingleProductView(
                              categoryId: categoriesModel.categoryId,
                              categoryName: categoriesModel.categoryName,
                              
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.white,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: CachedNetworkImage(
                                  imageUrl: categoriesModel.categoryImg,
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  height:
                                      MediaQuery.of(context).size.height * 0.12,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                categoriesModel.categoryName,
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else if (snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text("No data found"),
                );
              }
              return Container();
            },
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 2,
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
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                );
                break;
              case 1:
                // Handle the Wishlist item tap
                Navigator.push(context, MaterialPageRoute(builder: (context) => WishlistScreen()));
                
                break;
              case 2:
                // Handle the Categories item tap
                Get.offAll(AllCategoriesScreen());
                break;
              case 3:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartScreen(
                        ),
                  ),
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
