class CartModel {
  final int    id;
  final int    productId;
  final int    userId;
  final String name;
  final double price;
  final String imageUrl;
  final int    stock;
  int          quantity;

  CartModel({
    required this.id,
    required this.productId,
    required this.userId,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.stock,
    required this.quantity,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id:        int.tryParse(json['id'].toString())         ?? 0,
      productId: int.tryParse(json['product_id'].toString()) ?? 0,
      userId:    int.tryParse(json['user_id'].toString())    ?? 0,
      name:      json['name']                                ?? '',
      price:     double.tryParse(json['price'].toString())   ?? 0.0,
      imageUrl:  json['image_url']                           ?? '',
      stock:     int.tryParse(json['stock'].toString())      ?? 0,
      quantity:  int.tryParse(json['quantity'].toString())   ?? 1,
    );
  }

  double get totalPrice => price * quantity;
}