class ReviewModel {
  final int    id;
  final int    rating;
  final String comment;
  final String userName;
  final String createdAt;

  ReviewModel({
    required this.id,
    required this.rating,
    required this.comment,
    required this.userName,
    required this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id:        int.tryParse(json['id'].toString())     ?? 0,
      rating:    int.tryParse(json['rating'].toString()) ?? 0,
      comment:   json['comment']                         ?? '',
      userName:  json['user_name']                       ?? '',
      createdAt: json['created_at']                      ?? '',
    );
  }
}