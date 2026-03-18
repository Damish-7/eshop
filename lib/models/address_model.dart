class AddressModel {
  final int    id;
  final int    userId;
  final String label;
  final String fullName;
  final String phone;
  final String address;
  final String city;
  final String state;
  final String pincode;
  final bool   isDefault;
  final String createdAt;

  AddressModel({
    required this.id,
    required this.userId,
    required this.label,
    required this.fullName,
    required this.phone,
    required this.address,
    required this.city,
    required this.state,
    required this.pincode,
    required this.isDefault,
    required this.createdAt,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id:        int.tryParse(json['id'].toString())       ?? 0,
      userId:    int.tryParse(json['user_id'].toString())  ?? 0,
      label:     json['label']                             ?? 'Home',
      fullName:  json['full_name']                         ?? '',
      phone:     json['phone']                             ?? '',
      address:   json['address']                           ?? '',
      city:      json['city']                              ?? '',
      state:     json['state']                             ?? '',
      pincode:   json['pincode']                           ?? '',
      isDefault: json['is_default'].toString() == '1',
      createdAt: json['created_at']                        ?? '',
    );
  }

  // Full address as single string for order placement
  String get fullAddress =>
      '$fullName, $address, $city, $state - $pincode\nPhone: $phone';
}