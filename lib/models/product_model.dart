class ProductModel {
  final int    id;
  final String name;
  final String description;
  final double price;
  final int    stock;
  final String category;
  final String imageUrl;
  final String createdAt;
  final double averageRating; // ← NEW
  final int    totalReviews;  // ← NEW

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.category,
    required this.imageUrl,
    required this.createdAt,
    required this.averageRating,
    required this.totalReviews,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id:          int.tryParse(json['id'].toString())    ?? 0,
      name:        json['name']                           ?? '',
      description: json['description']                   ?? '',
      price:       double.tryParse(json['price'].toString()) ?? 0.0,
      stock:       int.tryParse(json['stock'].toString()) ?? 0,
      category:    json['category']                       ?? '',
      imageUrl:    json['image_url']                      ?? '',
      createdAt:   json['created_at']                     ?? '',
      averageRating: double.tryParse(
                       json['average_rating'].toString())            ?? 0.0,
      totalReviews:  int.tryParse(
                       json['total_reviews'].toString())             ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id':          id,
      'name':        name,
      'description': description,
      'price':       price,
      'stock':       stock,
      'category':    category,
      'image_url':   imageUrl,
      'created_at':  createdAt,
    };
  }
}