import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_app/models/product-model.dart';

class SearchControllerAll extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxList<ProductModel> searchResults = <ProductModel>[].obs;

  void searchProducts(String query) async {
    if (query.isEmpty) {
      searchResults.clear();
      return;
    }

    try {
      final result = await _firestore.collection('products').get();
      List<ProductModel> products = result.docs.map((doc) {
        return ProductModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      searchResults.value = products.where((product) {
        return product.productName.toLowerCase().contains(query.toLowerCase());
      }).toList();
    } catch (e) {
      print("Error fetching products: $e");
      searchResults.clear(); // Clear search results on error
    }
  }
}
