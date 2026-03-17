import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/wishlist_controller.dart';
import '../controllers/cart_controller.dart';
import '../models/wishlist_model.dart';
import '../utils/app_colors.dart';

class WishlistScreen extends StatelessWidget {
  WishlistScreen({super.key});

  final _wishCtrl = Get.find<WishlistController>();
  final _cartCtrl = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Wishlist'),
        leading: IconButton(
          icon:      const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (_wishCtrl.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (_wishCtrl.wishlistItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite_border,
                  size:  100,
                  color: AppColors.grey.withOpacity(0.4),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Your Wishlist is Empty',
                  style: TextStyle(
                    fontSize:   22,
                    fontWeight: FontWeight.bold,
                    color:      AppColors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tap the heart icon on products to save them!',
                  style: TextStyle(color: AppColors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => Get.back(),
                  icon:  const Icon(Icons.shopping_bag_outlined),
                  label: const Text('Browse Products'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _wishCtrl.fetchWishlist,
          color:     AppColors.primary,
          child: ListView.builder(
            padding:     const EdgeInsets.all(16),
            itemCount:   _wishCtrl.wishlistItems.length,
            itemBuilder: (_, i) {
              final item = _wishCtrl.wishlistItems[i];
              return _WishlistCard(
                item:        item,
                onRemove:    () => _wishCtrl.toggleWishlist(item.productId),
                onAddToCart: () => _cartCtrl.addToCart(item.productId),
              );
            },
          ),
        );
      }),
    );
  }
}

class _WishlistCard extends StatelessWidget {
  final WishlistModel item;
  final VoidCallback  onRemove;
  final VoidCallback  onAddToCart;

  const _WishlistCard({
    required this.item,
    required this.onRemove,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:  const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color:        Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color:      Colors.black.withOpacity(0.05),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              item.imageUrl,
              width:  80,
              height: 80,
              fit:    BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width:  80,
                height: 80,
                color:  AppColors.lightGrey,
                child:  const Icon(
                  Icons.image_not_supported_outlined,
                  color: AppColors.grey,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Product Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize:   15,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  item.category,
                  style: const TextStyle(
                    color:   AppColors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                // Rating
                if (item.totalReviews > 0)
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size:  14,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${item.averageRating}',
                        style: const TextStyle(
                          fontSize:   12,
                          fontWeight: FontWeight.bold,
                          color:      Colors.amber,
                        ),
                      ),
                      Text(
                        ' (${item.totalReviews})',
                        style: const TextStyle(
                          fontSize: 11,
                          color:    AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 6),
                Text(
                  '₹${item.price.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color:      AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize:   16,
                  ),
                ),
              ],
            ),
          ),
          // Action Buttons
          Column(
            children: [
              // Remove from wishlist
              IconButton(
                icon: const Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
                onPressed: onRemove,
              ),
              // Add to cart
              GestureDetector(
                onTap: item.stock > 0 ? onAddToCart : null,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical:   8,
                  ),
                  decoration: BoxDecoration(
                    color: item.stock > 0
                        ? AppColors.primary
                        : AppColors.grey,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item.stock > 0 ? 'Add to Cart' : 'Out of Stock',
                    style: const TextStyle(
                      color:    Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}