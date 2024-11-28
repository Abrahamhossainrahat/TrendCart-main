class WishListModel {
  final String productId;
  final String categoryId;
  final String productName;
  final String categoryName;
  final String salePrice;
  final String fullPrice;
  final List productImages;
  final String deliveryTime;
  String timeSlot; // New field for time slot
  final bool isSale;
  final String productDescription;
  final dynamic createdAt;
  final dynamic updatedAt;

  WishListModel({
    required this.productId,
    required this.categoryId,
    required this.productName,
    required this.categoryName,
    required this.salePrice,
    required this.fullPrice,
    required this.productImages,
    required this.deliveryTime,
    required this.timeSlot, // Add time slot field
    required this.isSale,
    required this.productDescription,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'categoryId': categoryId,
      'productName': productName,
      'categoryName': categoryName,
      'salePrice': salePrice,
      'fullPrice': fullPrice,
      'productImages': productImages,
      'deliveryTime': deliveryTime,
      'timeSlot': timeSlot, // Add time slot field
      'isSale': isSale,
      'productDescription': productDescription,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory WishListModel.fromMap(Map<String, dynamic> map) {
    return WishListModel(
      productId: map['productId'],
      categoryId: map['categoryId'],
      productName: map['productName'],
      categoryName: map['categoryName'],
      salePrice: map['salePrice'],
      fullPrice: map['fullPrice'],
      productImages: map['productImages'],
      deliveryTime: map['deliveryTime'],
      timeSlot: map['timeSlot'], // Add time slot field
      isSale: map['isSale'],
      productDescription: map['productDescription'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }
}
