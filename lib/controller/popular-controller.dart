// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';

// class PopularController extends GetxController {
//   RxList<String> bannerUrls = RxList<String>([]);

//   @override
//   void onInit() {
//     super.onInit();
//     fetchBannerUrls();
//   }

//   // Fetch banner urls from the server
//   Future<void> fetchBannerUrls() async {
//     try {
//       QuerySnapshot bannerSnapshot =
//           await FirebaseFirestore.instance.collection('products').get();

//       if (bannerSnapshot.docs.isNotEmpty) {
//         List<String> urls = [];
//         for (var doc in bannerSnapshot.docs) {
//           List<dynamic> productImages = doc['productImages'];
//           urls.addAll(productImages.cast<String>());
//         }
//         bannerUrls.value = urls;
//       }
//     } catch (e) {
//       print("Error: $e");
//     }
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shopping_app/models/product-model.dart';

class PopularController extends GetxController {
  RxList<ProductModel> products = RxList<ProductModel>([]);
  RxList<String> bannerUrls = RxList<String>([]);

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
    fetchBannerUrls();
  }

  // Fetch products from the server
  Future<void> fetchProducts() async {
    try {
      QuerySnapshot productSnapshot =
          await FirebaseFirestore.instance.collection('products').get();

      if (productSnapshot.docs.isNotEmpty) {
        List<ProductModel> productList = productSnapshot.docs.map((doc) {
          return ProductModel.fromMap(doc.data() as Map<String, dynamic>);
        }).toList();
        products.value = productList;
      }
    } catch (e) {
      print("Error: $e");
    }
  }
  Future<void> fetchBannerUrls() async {
    try {
      QuerySnapshot bannerSnapshot =
          await FirebaseFirestore.instance.collection('products').get();

      if (bannerSnapshot.docs.isNotEmpty) {
        List<String> urls = [];
        for (var doc in bannerSnapshot.docs) {
          List<dynamic> productImages = doc['productImages'];
          urls.addAll(productImages.cast<String>());
        }
        bannerUrls.value = urls;
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}