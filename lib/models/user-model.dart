class User {
  String deviceToken;
  String email;
  bool isAdmin;
  String name;
  String phone;
  String uId;
  String city;
  String state;
  String country;
  String road;
  String postalCode;
  String adress;

  User({
    required this.deviceToken,
    required this.email,
    required this.isAdmin,
    required this.name,
    required this.phone,
    required this.uId,
    required this.city,
    required this.state,
    required this.country,
    required this.road,
    required this.postalCode,
    required this.adress,

  });

  // Factory constructor for creating a new User instance from a map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      deviceToken: map['deviceToken'] ?? '',
      email: map['email'] ?? '',
      isAdmin: map['isAdmin'] ?? false,
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      uId: map['uId'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      country: map['country'] ?? '',
      road: map['road'] ?? '',
      postalCode: map['postalCode'] ?? '',
      adress: map['adress'] ?? '',
    );
  }

  // Method for converting a User instance to a map
  Map<String, dynamic> toMap() {
    return {
      'deviceToken': deviceToken,
      'email': email,
      'isAdmin': isAdmin,
      'name': name,
      'phone': phone,
      'uId': uId,
      'city': city,
      'state': state,
      'country': country,
      'road': road,
      'postalCode': postalCode,
      'adress': adress,
    };
  }
}
