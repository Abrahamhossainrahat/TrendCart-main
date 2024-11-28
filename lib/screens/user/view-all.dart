import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shopping_app/const/app-colors.dart';
import 'package:shopping_app/controller/cart-controller.dart';
import 'package:shopping_app/controller/cart-model-controller.dart';
import 'package:shopping_app/screens/user/all-category.dart';
import 'package:shopping_app/screens/user/checkout-screen.dart';
import 'package:shopping_app/screens/user/product-detailscreen.dart';
import 'package:shopping_app/screens/user/settings.dart';
import 'package:shopping_app/screens/user/wish-list.dart';
import '../../My Cart/my_cart_view.dart';
import '../../controller/wishlist-controller.dart';
import '../../models/product-model.dart';

class  ViewAllScreen extends StatelessWidget {
  final String  productId;
  final String  productName;
  final CartController cartController = Get.put(CartController());
  User? user = FirebaseAuth.instance.currentUser;

  ViewAllScreen({
    Key? key,
    required this. productId,
    required this. productName,
  }) : super(key: key);

  WishlistController wishlistController = Get.put(WishlistController());

  void addToCartWithSize(ProductModel product, String selectedSize) {
    if (cartController.cartItems.any((element) => element.productId == product.productId)) {
      cartController.removeFromCart(product.productId);
      Get.snackbar(
        'Product already in cart',
        'Please go to cart to update quantity',
      );
      return;
    } else {
      if (product.quantity == "0") {
        Fluttertoast.showToast(msg: "Product is unavailable");
      } else {
        cartController.email(product.sellerEmail);
        cartController.addToCart(
          CartItem(
            productId: product.productId,
            productName: product.productName,
            productImage: product.productImages[0],
            price: product.salePrice,
            quantity: 1, // Assign selected size to cart item
          ),
        );
        Fluttertoast.showToast(msg: "Added to cart");
      }
      Fluttertoast.showToast(
        msg: "Product added to cart",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColor.colorRed,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  void showSizeSelectionDialog(BuildContext context, ProductModel product) {
    String selectedSize = '';

    if (product. productName == 'Cap' || product. productName == 'Cup') {
      // Directly add to cart without showing the dialog
      addToCartWithSize(product, '');
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
                children: product.productSizes.map((size) {
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
                      addToCartWithSize(product, selectedSize);
                      Navigator.of(context).pop(); // Close the dialog
                    } else {
                      // Handle case where no size is selected
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.colorRed,
        title: Text( productName, style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('products')
            .where(' productId', isEqualTo:  productId)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("Products not found for this category!"));
          }

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 3,
              mainAxisSpacing: 3,
              childAspectRatio: .6,
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              ProductModel product = ProductModel.fromMap(
                snapshot.data!.docs[index].data() as Map<String, dynamic>,
              );
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailScreen(productModel: product),
                    ),
                  );
                },
                child: Card(
                  elevation: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailScreen(productModel: product),
                              ),
                            );
                          },
                          child: CachedNetworkImage(
                            height: MediaQuery.of(context).size.height * 0.2,
                            width: MediaQuery.of(context).size.width * 0.5,
                            imageUrl: product.productImages[0],
                            placeholder: (context, url) => CircularProgressIndicator(),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.productName,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Sale Price: ${product.salePrice} TK',
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Full Price: ${product.fullPrice} TK',
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {
                                if (cartController.cartItems.any((element) => element.productId == product.productId)) {
                                  cartController.removeFromCart(product.productId);
                                  Get.snackbar('Product already in cart', 'Please go to cart to update quantity');
                                  return;
                                } else {
                                  if (product.quantity == "0") {
                                    Fluttertoast.showToast(msg: "Product is unavailable");
                                  } else {
                                    showSizeSelectionDialog(context, product); // Show the size selection dialog
                                  }
                                }
                              },
                              child: Text('Add to Cart'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
