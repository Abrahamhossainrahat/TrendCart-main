// ignore_for_file: use_key_in_widget_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:shopping_app/controller/address-controller.dart';
import 'package:shopping_app/controller/cart-controller.dart';
import 'package:shopping_app/controller/payment-controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_app/screens/user/all-category.dart';
import 'package:shopping_app/screens/user/home-screen.dart';
import 'package:shopping_app/screens/user/order-confirmation-screen.dart';
import 'package:shopping_app/screens/user/settings.dart';
import 'package:shopping_app/screens/user/shipping-address.dart';
import 'package:shopping_app/screens/user/wish-list.dart';
import '../../My Cart/my_cart_view.dart';
import '../../const/app-colors.dart';
import '../../controller/get-customer-device-token-controller.dart';

class CheckoutScreen extends StatefulWidget {

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late TextEditingController timeController;
  final payment = PaymentController();
  AddressController ads = Get.put(AddressController());

  @override
  void initState() {
    super.initState();
    timeController = TextEditingController();
    fetchUserData(); // Fetch user data
    fetchAddressData(); // Fetch address data
  }

  final CartController cartController = Get.find<CartController>();
  User? user = FirebaseAuth.instance.currentUser;

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String selectedPaymentMethod = 'Card';
  String selectOrderType = 'Normal Delivery';

  bool isPaymentCompleted = false;
  bool isSubmittingOrder = false; // New state variable

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: AppColor.colorRed,
        title: Text(
          'Checkout',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              fetchAddressData();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddAddressScreen())),
              child: Card(
                margin: EdgeInsets.all(20.0),
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Delivery Info',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Divider(),
                      ListTile(
                        title: Text('Name'),
                        subtitle: Text(nameController.text),
                      ),
                      ListTile(
                        title: Text('Email'),
                        subtitle: Text(emailController.text),
                      ),
                      ListTile(
                        title: Text('Address'),
                        subtitle: Text(addressController.text),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: DropdownButtonFormField<String>(
                value: selectOrderType,
                items: [
                  DropdownMenuItem<String>(
                    value: 'Normal Delivery',
                    child: Row(
                      children: [
                        Icon(Icons.delivery_dining),
                        SizedBox(width: 10),
                        Text('Normal Delivery'),
                      ],
                    ),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Pick up',
                    child: Row(
                      children: [
                        Icon(Icons.location_on),
                        SizedBox(width: 10),
                        Text('Pick up'),
                      ],
                    ),
                  ),
                  
                  DropdownMenuItem<String>(
                    value: 'Preferred time',
                    child: Row(
                      children: [
                        Icon(Icons.timelapse),
                        SizedBox(width: 10),
                        Text('Prffered time'),
                      ],
                    ),
                  ),
                ],
                onChanged: (String? newValue) {
                  setState(() {
                    selectOrderType = newValue!;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Order Type',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                height: 55.0,
                child: TextFormField(
                  controller: timeController,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: 'Select delivery date',
                    labelText: 'Delivery Date',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2101),
                        );
                        if (date != null) {
                          //timeController.text = "${date.toLocal()}".split(' ')[0];    // YYYY-MM-DD
                          timeController.text = "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";

                        }
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: DropdownButtonFormField<String>(
                value: selectedPaymentMethod,
                items: [
                  DropdownMenuItem<String>(
                    value: 'Card',
                    child: Row(
                      children: [
                        Icon(Icons.credit_card),
                        SizedBox(width: 10),
                        Text('Card'),
                      ],
                    ),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Cash on Delivery',
                    child: Row(
                      children: [
                        Icon(Icons.money),
                        SizedBox(width: 10),
                        Text('Cash on Delivery'),
                      ],
                    ),
                  ),
                ],
                onChanged: (String? newValue) {
                  setState(() {
                    selectedPaymentMethod = newValue!;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Payment Method',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: () async {
                  if (cartController.totalPrice == 0) {
                    Get.snackbar("Error", "Your cart is empty!");
                    return;
                  }

                  setState(() {
                    isSubmittingOrder = true; // Show circular indicator
                  });

                  String name = nameController.text.trim();
                  String address = addressController.text.trim();
                  String phone = phoneController.text.trim();
                  String time = timeController.text.trim();
                  String total = cartController.totalPrice.toString();
                  String paymentMethod = selectedPaymentMethod;

                  String? customerToken = await getCustomerDeviceToken();

                  print('Customer Token: $customerToken');
                  print('Name: $name');
                  print('Phone: $phone');
                  print('Address: $address');
                  print('Time: $time');
                  print('Payment Method: $paymentMethod');
                  print("Total price: $total");

                  if (paymentMethod == 'Cash on Delivery') {
                    await cartController.placeOrder(
                      cartController.cartItems,
                      cartController.totalPrice,
                      user!.uid,
                      name,
                      phone,
                      address,
                      paymentMethod,
                      time
                    );

                    await sendEmail(
                      user!.email!,
                      'Order Confirmation',
                      'Your order has been placed successfully. Order will be delivered within 3 days by $time.\nTotal amount: $total TK',
                    );

                    setState(() {
                      isPaymentCompleted = true;
                      isSubmittingOrder = false; // Hide circular indicator
                    });

                    Navigator.push(context, MaterialPageRoute(builder: (context) => OrderConfirmationScreen()));
                  } else if (paymentMethod == 'Card') {
                    if (await payment.makePayment(total)) {
                      await cartController.placeOrder(
                        cartController.cartItems,
                        cartController.totalPrice,
                        user!.uid,
                        name,
                        phone,
                        address,
                        paymentMethod,
                        time,
                      );

                      await sendEmail(
                        user!.email!,
                        'Order Confirmation',
                        'Your order has been placed successfully. Order will be delivered by $time.\nTotal amount: $total TK',
                      );

                      setState(() {
                        isPaymentCompleted = true;
                        isSubmittingOrder = false; // Hide circular indicator
                      });

                      Navigator.push(context, MaterialPageRoute(builder: (context) => OrderConfirmationScreen()));
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.colorRed,
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 15.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: isSubmittingOrder // Show circular indicator or button text
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : Text(
                        'Confirm Order',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => WishlistScreen()));
              break;
            case 2:
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen(email: user!.email.toString(),)));
              break;
          }
        },
      ),
    );
  }

  // Fetch user data
  void fetchUserData() {
    FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: user!.email)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        final userData = querySnapshot.docs.first.data() as Map<String, dynamic>;
        print('User data: $userData');
        setState(() {
          nameController.text = userData['name'] ?? '';
          phoneController.text = userData['phone'] ?? '';
          emailController.text = user!.email ?? '';
        });
      } else {
        print('No data found for this user');
      }
    }).catchError((error) {
      print('Error fetching address data: $error');
    });
  }

  void fetchAddressData() {
    FirebaseFirestore.instance
        .collection('addresses')
        .where('email', isEqualTo: user!.email)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        final addressData = querySnapshot.docs.first.data() as Map<String, dynamic>;
        print('Address data: $addressData');
        setState(() {
          addressController.text = addressData['address'] ?? '';
        });
      } else {
        print('No data found for this address');
      }
    }).catchError((error) {
      print('Error fetching address data: $error');
    });
  }

  Future<void> sendEmail(String recipient, String subject, String body) async {
    String username = "ealumnimobileapp@gmail.com";
    String password = "NABIL112233";

    print('Sending email to $recipient');

    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username, 'UTM E-COMMERCE APP')
      ..recipients.add(recipient)
      ..subject = subject
      ..text = body;

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent. \n' + e.toString());
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }
}
