// ignore_for_file: prefer_const_constructors, avoid_print, prefer_const_declarations, unused_element

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shopping_app/const/app-colors.dart';
import 'package:shopping_app/controller/cart-controller.dart';
import 'package:shopping_app/models/product-model.dart';
import 'package:shopping_app/models/wishlist-model.dart';
import 'package:shopping_app/screens/user/all-category.dart';
import 'package:shopping_app/screens/user/home-screen.dart';
import 'package:shopping_app/screens/user/settings.dart';
import 'package:shopping_app/screens/user/wish-list.dart';
import 'package:shopping_app/widgets/check-quantity.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../My Cart/my_cart_view.dart';
import '../../controller/cart-model-controller.dart';
import '../../controller/wishlist-controller.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel productModel;

  ProductDetailScreen({Key? key, required this.productModel}) : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  CartController cartController = Get.put(CartController());
  WishlistController wishlistController = Get.put(WishlistController());
  bool isInWishlist = false;
  bool _isButtonPressed = false;
  QuantityChecker quantityChecker = QuantityChecker();
  User? user = FirebaseAuth.instance.currentUser;
  String selectedSize = '';
  var _currrentIndex = 0;


  @override
  void initState() {
    super.initState();
    isInWishlist = wishlistController.wishlistItems
        .any((item) => item.productId == widget.productModel.productId);
  }

  Future<void> _launchWhatsApp() async {
    const String userPhoneNumber = "";
    final String whatsappUrl = "https://wa.me/$userPhoneNumber";

    try {
      if (await canLaunch(whatsappUrl)) {
        await launch(whatsappUrl);
      } else {
        throw 'Could not launch WhatsApp';
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch WhatsApp')),
      );
    }
  }

  void sendWhatsAp() {
    String phoneNumber = "+8801819607621";
    String url = "whatsapp://send?phone= $phoneNumber";
    launchUrl(Uri.parse(url));
  }

  void addToWishlist() {
    WishListModel wishlistItem = WishListModel(
      productId: widget.productModel.productId,
      categoryId: widget.productModel.categoryId,
      productName: widget.productModel.productName,
      categoryName: widget.productModel.categoryName,
      salePrice: widget.productModel.salePrice,
      fullPrice: widget.productModel.fullPrice,
      productImages: widget.productModel.productImages,
      deliveryTime: widget.productModel.deliveryTime,
      isSale: widget.productModel.isSale,
      productDescription: widget.productModel.productDescription,
      createdAt: widget.productModel.createdAt,
      updatedAt: widget.productModel.updatedAt,
      timeSlot: "",
    );

    if (isInWishlist) {
      wishlistController.removeFromWishlistById(widget.productModel.productId);
    } else {
      wishlistController.addToWishlist(wishlistItem);
    }

    setState(() {
      isInWishlist = !isInWishlist;
    });

    // Upload the wishlist to Firebase for the current user
    wishlistController.addToWishlist(wishlistItem);
  }

  void showSizeSelectionDialog() {
    if (widget.productModel.categoryName == 'Cap' ||
        widget.productModel.categoryName == 'Cup') {
      addToCartWithSize(''); // Add to cart without size selection
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Select Size'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: widget.productModel.productSizes.map((size) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedSize = size;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Radio<String>(
                            value: size,
                            groupValue: selectedSize,
                            onChanged: (value) {
                              setState(() {
                                selectedSize = value!;
                              });
                            },
                          ),
                          SizedBox(width: 8),
                          Text(size),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (selectedSize.isNotEmpty) {
                      // Process the selected size here
                      // For example, add to cart with selected size
                      addToCartWithSize(selectedSize);
                      Navigator.of(context).pop(); // Close the dialog
                    } else {
                      // Show a message or handle empty selection
                      Fluttertoast.showToast(msg: "Please select a size");
                    }
                  },
                  child: Text('Confirm'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void addToCartWithSize(String size) {
    // Add to cart logic with selected size
    if (widget.productModel.quantity == "0") {
      Fluttertoast.showToast(msg: "Product is unavailable");
    } else {
      cartController.email(widget.productModel.sellerEmail);
      print("Seller Email : ${widget.productModel.sellerEmail}");
      cartController.addToCart(
        CartItem(
          productId: widget.productModel.productId,
          productName: widget.productModel.productName,
          productImage: widget.productModel.productImages[0],
          price: widget.productModel.salePrice,
          quantity: 1,
        ),
      );
      Fluttertoast.showToast(msg: "Added to cart");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.colorRed,
          title: Text(widget.productModel.productName),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1.5,
                child: Image.network(
                  widget.productModel.productImages[0],
                  fit: BoxFit.contain,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.productModel.productName,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Sale Price: ${widget.productModel.salePrice} TK',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Full Price: ${widget.productModel.fullPrice} TK',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Available: ${widget.productModel.quantity} units',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                        // decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    Text(
                      'Seller: ${widget.productModel.sellerEmail.split('@').first} ',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                        // decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Description:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      widget.productModel.productDescription,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              Padding(
  padding: const EdgeInsets.all(20.0),
  child: Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: sendWhatsAp,
              icon: Icon(FontAwesomeIcons.whatsapp, color: Colors.white),
              label: Text(
                "Contact Us",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
            ),
          ),
          SizedBox(width: 10), // Add spacing between the buttons
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                if (widget.productModel.quantity == "0") {
                  Fluttertoast.showToast(msg: "Product is unavailable");
                } else {
                  showSizeSelectionDialog(); // Show the size selection dialog
                }
              },
              icon: Icon(Icons.add_shopping_cart, color: Colors.white),
              label: Text(
                "Add to Cart",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.colorRed,
              ),
            ),
          ),
        ],
      ),
      SizedBox(height: 10), // Add spacing between the row and the wishlist button
      Center(
        child: ElevatedButton.icon(
          onPressed: _isButtonPressed
              ? null
              : () {
                  setState(() {
                    _isButtonPressed = true;
                  });
                  addToWishlist();
                },
          icon: Icon(
            isInWishlist ? Icons.favorite : Icons.favorite_border,
            color: Colors.white,
          ),
          label: Text(
            isInWishlist ? "Added to Wishlist" : "Add to Wishlist",
            style: TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: isInWishlist ? Colors.red : Colors.grey,
          ),
        ),
      ),
    ],
  ),
)

            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currrentIndex,
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
                  MaterialPageRoute(
                    
                    builder: (context) => HomeScreen(),
                  ),
                );
                break;
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WishlistScreen(),
                  ),
                );
                break;
              case 2:
                // Handle the Categories item tap
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AllCategoriesScreen()));
                break;
              case 3:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartScreen(),
                  ),
                );
                break;
              case 4:
                // Handle the Profile item tap
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
