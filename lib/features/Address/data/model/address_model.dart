class AddressModel {
  final String id;
  final String name;
  final String phone;
  final String address;
  final String landMark;
  final String note;

  AddressModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.landMark,
    required this.note,
  });

  // from
  factory AddressModel.fromJson(Map<String, dynamic> fromFirebase, String id) {
    return AddressModel(
      id: id,
      name: fromFirebase["name"] ?? "",
      phone: fromFirebase["phone"] ?? "",
      address: fromFirebase["address"] ?? "",
      landMark: fromFirebase["landMark"] ?? "",
      note: fromFirebase["note"] ?? "",
    );
  }

  // to

  Map<String, dynamic> toFirebase() {
    return {


"id":id,
"name":name,
"phone":phone,
"address":address,
"landMark":landMark,
"note":note,


    };
  }
}
