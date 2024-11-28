class Items{

  final String name;
  final String unit;
  final int price;
  final String image;

  Items({
    required this.name,
    required this.unit,
    required this.price,
    required this.image,
  });

  Items.fromMap(Map<String, dynamic> map)
      : name = map['name'],
        unit = map['unit'],
        price = map['price'],
        image = map['image'];

  Map toJson() {
    return {
      'name': name,
      'unit': unit,
      'price': price,
      'image': image,
    };
  }

  Map<String, dynamic> quantityMap() {
    return {
      'name': name,
      'unit': unit,
      'price': price,
      'image': image,
    };
  }
}