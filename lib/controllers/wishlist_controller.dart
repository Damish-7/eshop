import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/wishlist_model.dart';
import '../services/api_service.dart';
import 'auth_controller.dart';

class WishlistController extends GetxController {
  final RxList<WishlistModel> wishlistItems  = <WishlistModel>[].obs;
  final RxList<int>           wishlistIds    = <int>[].obs;
  final RxBool                isLoading      = false.obs;

  final AuthController _auth = Get.find<AuthController>();

  // Check if product is in wishlist
  bool isWishlisted(int productId) => wishlistIds.contains(productId);

  @override
  void onInit() {
    super.onInit();
    ever(_auth.user, (_) => fetchWishlist());
    fetchWishlist();
  }

  Future<void> fetchWishlist() async {
    if (_auth.user.value == null) {
      wishlistItems.clear();
      wishlistIds.clear();
      return;
    }
    isLoading.value = true;
    try {
      final res = await ApiService.getWishlist(_auth.user.value!.id);
      if (res['status'] == true) {
        wishlistItems.value = (res['wishlist'] as List)
            .map((e) => WishlistModel.fromJson(e))
            .toList();
        // Store just the product IDs for quick lookup
        wishlistIds.value = wishlistItems
            .map((e) => e.productId)
            .toList();
      }
    } catch (e) {
      wishlistItems.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleWishlist(int productId) async {
    if (_auth.user.value == null) {
      Get.snackbar(
        'Login Required',
        'Please login to add to wishlist',
        backgroundColor: Colors.orange,
        colorText:       Colors.white,
        snackPosition:   SnackPosition.BOTTOM,
      );
      Get.toNamed('/login');
      return;
    }

    try {
      final res = await ApiService.toggleWishlist(
        _auth.user.value!.id,
        productId,
      );

      if (res['status'] == true) {
        final isNowWishlisted = res['wishlisted'] as bool;

        if (isNowWishlisted) {
          wishlistIds.add(productId);
        } else {
          wishlistIds.remove(productId);
          wishlistItems.removeWhere((e) => e.productId == productId);
        }

        Get.snackbar(
          isNowWishlisted ? '❤️ Added to Wishlist' : 'Removed from Wishlist',
          res['message'],
          backgroundColor: isNowWishlisted
              ? const Color.fromARGB(255, 245, 155, 185)
              : Colors.grey,
          colorText:     Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration:      const Duration(seconds: 1),
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}