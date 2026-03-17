class WishlistModel {
  final int    wishlistId;
  final int    productId;
  final String name;
  final double price;
  final String imageUrl;
  final String category;
  final int    stock;
  final double averageRating;
  final int    totalReviews;

  WishlistModel({
    required this.wishlistId,
    required this.productId,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.stock,
    required this.averageRating,
    required this.totalReviews,
  });

  factory WishlistModel.fromJson(Map<String, dynamic> json) {
    return WishlistModel(
      wishlistId:    int.tryParse(json['wishlist_id'].toString())    ?? 0,
      productId:     int.tryParse(json['product_id'].toString())     ?? 0,
      name:          json['name']                                    ?? '',
      price:         double.tryParse(json['price'].toString())       ?? 0.0,
      imageUrl:      json['image_url']                               ?? '',
      category:      json['category']                                ?? '',
      stock:         int.tryParse(json['stock'].toString())          ?? 0,
      averageRating: double.tryParse(
                       json['average_rating'].toString())            ?? 0.0,
      totalReviews:  int.tryParse(json['total_reviews'].toString())  ?? 0,
    );
  }
}