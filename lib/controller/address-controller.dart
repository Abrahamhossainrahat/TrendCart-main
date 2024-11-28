import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddressController extends GetxController {
  var address = ''.obs;

  User? user = FirebaseAuth.instance.currentUser;

  @override
  void onInit() {
    super.onInit();
    fetchAddressData();
  }

  void fetchAddressData() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('addresses')
          .where('email', isEqualTo: user!.email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final addressData = querySnapshot.docs.first.data();
        address.value = addressData['address'] ?? '';
      } else {
        print('No data found for this address');
      }
    } catch (error) {
      print('Error fetching address data: $error');
    }
  }

  void updateAddress(String newAddress) async {
    try {
      await FirebaseFirestore.instance
          .collection('addresses')
          .doc(user!.email)
          .update({'address': newAddress});

      address.value = newAddress;
    } catch (error) {
      print('Error updating address data: $error');
    }
  }
}
