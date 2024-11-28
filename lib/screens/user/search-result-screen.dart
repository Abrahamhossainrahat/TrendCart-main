import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_app/const/app-colors.dart';
import 'package:shopping_app/screens/user/product-detailscreen.dart';
import '../../controller/search-controller.dart';
import '../../models/product-model.dart';

class SearchResultsScreen extends StatelessWidget {
  final String query;

  const SearchResultsScreen({Key? key, required this.query}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    SearchControllerAll searchController = Get.put(SearchControllerAll());
    // Call searchProducts initially
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      searchController.searchProducts(query);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results for "$query"'),
        backgroundColor: AppColor.colorRed,
      ),
      body: Obx(() {
        if (searchController.searchResults.isEmpty) {
          return Center(child: Text('No results found for "$query"'));
        } else {
          return ListView.builder(
            itemCount: searchController.searchResults.length,
            itemBuilder: (context, index) {
              final product = searchController.searchResults[index];
              return ListTile(
                leading: Image.network(product.productImages.isNotEmpty ? product.productImages[0] : ''), // Handle empty product images
                title: Text(product.productName),
                subtitle: Text(product.salePrice),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailScreen(productModel: product),
                    ),
                  );
                },
              );
            },
          );
        }
      }),
    );
  }
}
