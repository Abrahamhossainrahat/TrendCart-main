import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/My%20Cart/my_cart_view.dart';
import 'package:shopping_app/const/app-colors.dart';
import 'package:shopping_app/controller/wishlist-controller.dart';
import 'package:shopping_app/models/wishlist-model.dart';
import 'package:shopping_app/screens/user/all-category.dart';
import 'package:shopping_app/screens/user/home-screen.dart';
import 'package:shopping_app/screens/user/settings.dart';

class WishlistScreen extends StatefulWidget {
  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  late Future<void> _wishlistFuture;
  User? user = FirebaseAuth.instance.currentUser;
  var _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    _wishlistFuture =
        Provider.of<WishlistController>(context, listen: false).fetchWishlist();
  }

  void _showEditDialog(WishListModel item) {
    final TextEditingController timeSlotController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Time Slot'),
          content: TextField(
            controller: timeSlotController,
            readOnly: true, // Prevents manual input
            decoration: InputDecoration(
              hintText: "Enter the time slot",
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    // Format the date as DD-MM-YYYY

                    String formattedDate =
                        "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
                    setState(() {
                      timeSlotController.text = formattedDate;
                      //timeController.text = "${date.toLocal()}".split(' ')[0];  // YYYY-MM-DD
                    });
                  }
                },
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (timeSlotController.text.isNotEmpty) {
                  Provider.of<WishlistController>(context, listen: false)
                      .updateTimeSlot(item, timeSlotController.text);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Wishlist',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColor.colorRed,
      ),
      body: FutureBuilder<void>(
        future: _wishlistFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Consumer<WishlistController>(
              builder: (context, wishlistController, child) {
                if (wishlistController.wishlistItems.isEmpty) {
                  return const Center(
                      child: Text('No items in your wishlist.'));
                } else {
                  return ListView.builder(
                    itemCount: wishlistController.wishlistItems.length,
                    itemBuilder: (context, index) {
                      final item = wishlistController.wishlistItems[index];
                      return ListTile(
                        leading: Image.network(
                          item.productImages[0],
                          fit: BoxFit.cover,
                          width: 50,
                          height: 50,
                        ),
                        title: Text(item.productName),
                        subtitle: Text(
                          'Sale Price: ${item.salePrice} TK\nTime Slot: ${item.timeSlot}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                _showEditDialog(item);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () {
                                wishlistController
                                    .removeFromWishlistById(item.productId);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            );
          }
        },
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WishlistScreen()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AllCategoriesScreen()),
              );
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
                        )),
              );
              break;
          }
        },
      ),
    );
  }
}
