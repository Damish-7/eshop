import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../controllers/auth_controller.dart';
import '../controllers/wishlist_controller.dart';
import '../models/product_model.dart';
import '../models/review_model.dart';
import '../services/api_service.dart';
import '../utils/app_colors.dart';

class ProductDetailScreen extends StatelessWidget {
  ProductDetailScreen({super.key});

  final _cartCtrl    = Get.find<CartController>();
  final _authCtrl    = Get.find<AuthController>();
  final _wishCtrl    = Get.find<WishlistController>();
  final _qty         = 1.obs;

  @override
  Widget build(BuildContext context) {
    final ProductModel product = Get.arguments;
    final size                 = MediaQuery.of(context).size;
    final imageHeight          = size.width > 600 ? 420.0 : 300.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(product.name, overflow: TextOverflow.ellipsis),
        leading: IconButton(
          icon:      const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
        actions: [
          // Wishlist heart in app bar
          Obx(() => IconButton(
            icon: Icon(
              _wishCtrl.isWishlisted(product.id)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: _wishCtrl.isWishlisted(product.id)
                  ? Colors.red
                  : Colors.white,
            ),
            onPressed: () => _wishCtrl.toggleWishlist(product.id),
          )),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Image.network(
              product.imageUrl,
              height:  imageHeight,
              width:   double.infinity,
              fit:     BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: imageHeight,
                color:  AppColors.lightGrey,
                child:  const Icon(
                  Icons.image_not_supported_outlined,
                  size: 80, color: AppColors.grey,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width > 600
                    ? size.width * 0.1
                    : 16,
                vertical: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color:        AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      product.category,
                      style: const TextStyle(
                        color:      AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize:   12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Product Name
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize:   24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Rating Row
                  if (product.totalReviews > 0)
                    Row(
                      children: [
                        Row(
                          children: List.generate(5, (i) {
                            return Icon(
                              i < product.averageRating.round()
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.amber,
                              size:  20,
                            );
                          }),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${product.averageRating}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize:   16,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${product.totalReviews} reviews)',
                          style: const TextStyle(
                            color:   AppColors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 10),

                  // Price
                  Text(
                    '₹${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize:   30,
                      fontWeight: FontWeight.bold,
                      color:      AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Stock Status
                  Row(
                    children: [
                      Icon(
                        product.stock > 0
                            ? Icons.check_circle_rounded
                            : Icons.cancel_rounded,
                        color: product.stock > 0
                            ? AppColors.success
                            : AppColors.error,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        product.stock > 0
                            ? 'In Stock (${product.stock} available)'
                            : 'Out of Stock',
                        style: TextStyle(
                          color: product.stock > 0
                              ? AppColors.success
                              : AppColors.error,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),

                  // Description
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize:   18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description.isEmpty
                        ? 'No description available.'
                        : product.description,
                    style: const TextStyle(
                      color:   AppColors.grey,
                      height:  1.6,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Quantity Selector
                  Row(
                    children: [
                      const Text(
                        'Quantity:',
                        style: TextStyle(
                          fontSize:   16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.lightGrey,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 20),
                              onPressed: () {
                                if (_qty.value > 1) _qty.value--;
                              },
                            ),
                            Obx(() => Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Text(
                                '${_qty.value}',
                                style: const TextStyle(
                                  fontSize:   18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )),
                            IconButton(
                              icon: const Icon(Icons.add, size: 20),
                              onPressed: () {
                                if (_qty.value < product.stock) {
                                  _qty.value++;
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Add to Cart Button
                  SizedBox(
                    width:  double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: product.stock > 0
                          ? () => _cartCtrl.addToCart(
                                product.id,
                                quantity: _qty.value,
                              )
                          : null,
                      icon:  const Icon(Icons.shopping_cart_outlined),
                      label: const Text(
                        'Add to Cart',
                        style: TextStyle(
                          fontSize:   17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Write Review Button
                  SizedBox(
                    width:  double.infinity,
                    height: 52,
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          _showReviewDialog(context, product.id),
                      icon: const Icon(
                        Icons.rate_review_outlined,
                        color: AppColors.primary,
                      ),
                      label: const Text(
                        'Write a Review',
                        style: TextStyle(
                          fontSize:   17,
                          color:      AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: AppColors.primary,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Reviews Section
                  const Divider(),
                  const SizedBox(height: 12),
                  const Text(
                    'Customer Reviews',
                    style: TextStyle(
                      fontSize:   18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Reviews List
                  FutureBuilder<Map<String, dynamic>>(
                    future:  ApiService.getReviews(product.id),
                    builder: (_, snap) {
                      if (snap.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        );
                      }
                      if (!snap.hasData ||
                          snap.data?['status'] != true) {
                        return const Text('No reviews yet');
                      }

                      final reviews = (snap.data!['reviews'] as List)
                          .map((e) => ReviewModel.fromJson(e))
                          .toList();

                      if (reviews.isEmpty) {
                        return Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color:        AppColors.background,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.rate_review_outlined,
                                  size:  40,
                                  color: AppColors.grey,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'No reviews yet. Be the first!',
                                  style: TextStyle(
                                    color: AppColors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return Column(
                        children: reviews
                            .map((r) => _ReviewCard(review: r))
                            .toList(),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Review Dialog ────────────────────────────────────────────────────────
  void _showReviewDialog(BuildContext context, int productId) {
    if (_authCtrl.user.value == null) {
      Get.snackbar(
        'Login Required',
        'Please login to write a review',
        backgroundColor: Colors.orange,
        colorText:       Colors.white,
      );
      return;
    }

    final commentCtrl = TextEditingController();
    final rating      = 0.obs;
    final isSubmitting = false.obs;

    Get.bottomSheet(
      isScrollControlled: true,
      Container(
        padding: EdgeInsets.only(
          left:   20,
          right:  20,
          top:    20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        decoration: const BoxDecoration(
          color:        Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle + Close
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color:        AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                IconButton(
                  icon:      const Icon(Icons.close),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            const Text(
              'Write a Review',
              style: TextStyle(
                fontSize:   20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Star Rating Selector
            const Text(
              'Your Rating *',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize:   15,
              ),
            ),
            const SizedBox(height: 10),
            Obx(() => Row(
              children: List.generate(5, (i) {
                return GestureDetector(
                  onTap: () => rating.value = i + 1,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Icon(
                      i < rating.value
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.amber,
                      size:  40,
                    ),
                  ),
                );
              }),
            )),
            const SizedBox(height: 8),
            // Rating label
            Obx(() => Text(
              rating.value == 0 ? 'Tap a star to rate'
              : rating.value == 1 ? '😞 Poor'
              : rating.value == 2 ? '😐 Fair'
              : rating.value == 3 ? '🙂 Good'
              : rating.value == 4 ? '😊 Very Good'
              : '🤩 Excellent!',
              style: TextStyle(
                color: rating.value == 0
                    ? AppColors.grey
                    : Colors.amber,
                fontWeight: FontWeight.w600,
              ),
            )),
            const SizedBox(height: 16),

            // Comment Field
            TextField(
              controller: commentCtrl,
              maxLines:   3,
              decoration: InputDecoration(
                hintText:  'Share your experience with this product...',
                filled:    true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.lightGrey,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Submit Button
            Obx(() => SizedBox(
              width:  double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: isSubmitting.value
                    ? null
                    : () async {
                        if (rating.value == 0) {
                          Get.snackbar(
                            'Error',
                            'Please select a rating',
                            backgroundColor: Colors.red,
                            colorText:       Colors.white,
                          );
                          return;
                        }
                        isSubmitting.value = true;
                        final res = await ApiService.addReview(
                          _authCtrl.user.value!.id,
                          productId,
                          rating.value,
                          commentCtrl.text.trim(),
                        );
                        isSubmitting.value = false;
                        if (res['status'] == true) {
                          Get.back();
                          Get.snackbar(
                            '⭐ Review Submitted!',
                            res['message'],
                            backgroundColor: Colors.green,
                            colorText:       Colors.white,
                            snackPosition:   SnackPosition.BOTTOM,
                          );
                        } else {
                          Get.snackbar(
                            'Error',
                            res['message'] ?? 'Failed',
                            backgroundColor: Colors.red,
                            colorText:       Colors.white,
                          );
                        }
                      },
                icon: isSubmitting.value
                    ? const SizedBox(
                        width:  20,
                        height: 20,
                        child:  CircularProgressIndicator(
                          color:       Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.send),
                label: const Text(
                  'Submit Review',
                  style: TextStyle(
                    fontSize:   17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

// ─── Review Card Widget ───────────────────────────────────────────────────────
class _ReviewCard extends StatelessWidget {
  final ReviewModel review;
  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:  const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color:        Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color:      Colors.black.withOpacity(0.04),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User name + stars
          Row(
            children: [
              CircleAvatar(
                radius:          18,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Text(
                  review.userName.isNotEmpty
                      ? review.userName[0].toUpperCase()
                      : 'U',
                  style: const TextStyle(
                    color:      AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      review.createdAt.length >= 10
                          ? review.createdAt.substring(0, 10)
                          : review.createdAt,
                      style: const TextStyle(
                        color:   AppColors.grey,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              // Stars
              Row(
                children: List.generate(5, (i) {
                  return Icon(
                    i < review.rating
                        ? Icons.star
                        : Icons.star_border,
                    color: Colors.amber,
                    size:  16,
                  );
                }),
              ),
            ],
          ),
          // Comment
          if (review.comment.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              review.comment,
              style: const TextStyle(
                color:   AppColors.grey,
                height:  1.5,
                fontSize: 13,
              ),
            ),
          ],
        ],
      ),
    );
  }
}