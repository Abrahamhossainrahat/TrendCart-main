class Address {
  String street;
  String city;
  String state;
  String postalCode;
  String country;
  String email;
  String address;

  Address({
    required this.street,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    required this.email,
    required this.address

  });

  // Convert a Address object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'street': street,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'country': country,
      'email':email,
      'address':address
    };
  }

  // Create a Address object from a Map object
  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      street: map['street'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      postalCode: map['postalCode'] ?? '',
      country: map['country'] ?? '',
      email: map['email'] ?? '',
      address: map['address'] ?? '',
    );
  }
}
