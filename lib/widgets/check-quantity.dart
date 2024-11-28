import 'package:cloud_firestore/cloud_firestore.dart';
class QuantityChecker {
  
Future<bool> updateProductQuantity(String productId, int orderedQuantity) async {
    print('Updating product $productId quantity to $orderedQuantity');
    try {
      DocumentReference productRef = FirebaseFirestore.instance.collection('products').doc(productId);
      DocumentSnapshot productDoc = await productRef.get();
      if (productDoc.exists) {
        int currentQuantity = int.parse(productDoc['quantity']);
        print(currentQuantity);
        if (currentQuantity == 0) {
          print('Product $productId is unavailable');
          return false; // Product is unavailable
        }
        int newQuantity = currentQuantity - orderedQuantity;
        if (newQuantity < 0) {
          print('Insufficient quantity for product $productId');
          return false; // Not enough quantity
        }
        String update = newQuantity.toString();
        await productRef.update({'quantity': update});
        print('Updated product $productId quantity to $update');
        return true; // Quantity updated successfully
      } else {
        print('Product $productId does not exist');
        return false; // Product does not exist
      }
    } catch (error) {
      print('Error updating product quantity: $error');
      return false; // Error occurred
    }
  }
}
