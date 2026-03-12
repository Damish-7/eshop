import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/cart_model.dart';
import '../services/api_service.dart';
import 'auth_controller.dart';

class CartController extends GetxController {
  final RxList<CartModel> cartItems = <CartModel>[].obs;
  final RxBool            isLoading = false.obs;

  final AuthController _auth = Get.find<AuthController>();

  double get totalAmount =>
      cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);

  int get itemCount =>
      cartItems.fold(0, (sum, item) => sum + item.quantity);

  @override
  void onInit() {
    super.onInit();
    ever(_auth.user, (_) => fetchCart());
    fetchCart();
  }

  Future<void> fetchCart() async {
    if (_auth.user.value == null) {
      cartItems.clear();
      return;
    }
    isLoading.value = true;
    try {
      final res = await ApiService.getCart(_auth.user.value!.id);
      if (res['status'] == true) {
        cartItems.value = (res['cart'] as List)
            .map((e) => CartModel.fromJson(e))
            .toList();
      } else {
        cartItems.value = [];
      }
    } catch (e) {
      cartItems.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addToCart(int productId, {int quantity = 1}) async {
    if (_auth.user.value == null) {
      Get.snackbar(
        'Login Required',
        'Please login to add items to cart',
        backgroundColor: Colors.orange,
        colorText:       Colors.white,
        snackPosition:   SnackPosition.BOTTOM,
      );
      Get.toNamed('/login');
      return;
    }

    try {
      final res = await ApiService.addToCart(
        _auth.user.value!.id,
        productId,
        quantity,
      );

      if (res['status'] == true) {
        await fetchCart();
        Get.snackbar(
          'Added to Cart',
          res['message'] ?? 'Item added successfully',
          backgroundColor: Colors.green,
          colorText:       Colors.white,
          snackPosition:   SnackPosition.BOTTOM,
          duration:        const Duration(seconds: 1),
        );
      } else {
        Get.snackbar(
          'Error',
          res['message'] ?? 'Failed to add to cart',
          backgroundColor: Colors.red,
          colorText:       Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> updateQuantity(int cartId, int quantity) async {
    if (quantity < 1) {
      await removeItem(cartId);
      return;
    }
    try {
      final res = await ApiService.updateCart(cartId, quantity);
      if (res['status'] == true) {
        await fetchCart();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update cart',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> removeItem(int cartId) async {
    try {
      final res = await ApiService.removeFromCart(cartId);
      if (res['status'] == true) {
        await fetchCart();
        Get.snackbar(
          'Removed',
          'Item removed from cart',
          backgroundColor: Colors.orange,
          colorText:       Colors.white,
          snackPosition:   SnackPosition.BOTTOM,
          duration:        const Duration(seconds: 1),
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to remove item',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> placeOrder(String address) async {
    if (cartItems.isEmpty) {
      Get.snackbar('Error', 'Cart is empty',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    try {
      final items = cartItems
          .map((e) => {
                'product_id': e.productId,
                'quantity':   e.quantity,
                'price':      e.price,
              })
          .toList();

      final res = await ApiService.placeOrder({
        'user_id': _auth.user.value!.id,
        'address': address,
        'total':   totalAmount,
        'items':   items,
      });

      if (res['status'] == true) {
        cartItems.clear();
        Get.snackbar(
          'Order Placed!',
          'Your order #${res['order_id']} was placed successfully',
          backgroundColor: Colors.green,
          colorText:       Colors.white,
          snackPosition:   SnackPosition.BOTTOM,
          duration:        const Duration(seconds: 3),
        );
        Get.offAllNamed('/home');
      } else {
        Get.snackbar(
          'Order Failed',
          res['message'] ?? 'Failed to place order',
          backgroundColor: Colors.red,
          colorText:       Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong. Try again.',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}