class OrderModel {
  final int    id;
  final int    userId;
  final double totalAmount;
  final String status;
  final String address;
  final String createdAt;
  final String userName;
  final String userEmail;
  final int    itemCount;

  OrderModel({
    required this.id,
    required this.userId,
    required this.totalAmount,
    required this.status,
    required this.address,
    required this.createdAt,
    required this.userName,
    required this.userEmail,
    required this.itemCount,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id:          int.tryParse(json['id'].toString())           ?? 0,
      userId:      int.tryParse(json['user_id'].toString())      ?? 0,
      totalAmount: double.tryParse(json['total_amount'].toString()) ?? 0.0,
      status:      json['status']                                ?? 'pending',
      address:     json['address']                               ?? '',
      createdAt:   json['created_at']                            ?? '',
      userName:    json['user_name']                             ?? '',
      userEmail:   json['user_email']                            ?? '',
      itemCount:   int.tryParse(json['item_count'].toString())   ?? 0,
    );
  }
}