
class ShippingAddress {
  final String name;
  final String street;
  final String city;
  final String state;
  final String pincode;

  const ShippingAddress({
    required this.name,
    required this.street,
    required this.city,
    required this.state,
    required this.pincode,
  });

  factory ShippingAddress.fromMap(Map<String, dynamic> map) {
    return ShippingAddress(
      name: map['name'] ?? '',
      street: map['street'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      pincode: map['pincode'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'street': street,
      'city': city,
      'state': state,
      'pincode': pincode,
    };
  }
}