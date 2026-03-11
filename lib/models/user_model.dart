class UserModel {
  final int    id;
  final String name;
  final String email;
  final String role;
  final String phone;
  final String address;
  final String createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.phone,
    required this.address,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id:        int.tryParse(json['id'].toString()) ?? 0,
      name:      json['name']       ?? '',
      email:     json['email']      ?? '',
      role:      json['role']       ?? 'user',
      phone:     json['phone']      ?? '',
      address:   json['address']    ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id':         id,
      'name':       name,
      'email':      email,
      'role':       role,
      'phone':      phone,
      'address':    address,
      'created_at': createdAt,
    };
  }

  bool get isAdmin => role == 'admin';
}