// ignore_for_file: avoid_print, unused_local_variable

//ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables , unused_import , unused_field, file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class BannerController extends GetxController {
  RxList<String> bannerUrls = RxList<String>([]);

  @override
  void onInit() {
    super.onInit();
    fetchBannerUrls();
  }

  // Fetch banner urls from the server
  Future<void> fetchBannerUrls() async {
    // Add your logic here
    try {
      QuerySnapshot bannerSnapshot =
          await FirebaseFirestore.instance.collection('banners').get();

      if (bannerSnapshot.docs.isNotEmpty) {
        bannerUrls.value = bannerSnapshot.docs
            .map((doc) => doc['imageUrl'] as String)
            .toList();
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}
