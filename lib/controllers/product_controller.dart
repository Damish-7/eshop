import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';

class ProductController extends GetxController {
  final RxList<ProductModel> products         = <ProductModel>[].obs;
  final RxBool               isLoading        = false.obs;
  final RxString             searchQuery      = ''.obs;
  final RxString             selectedCategory = 'All'.obs;

  final List<String> categories = [
  'All',
  'Electronics',
  'Laptops',
  'Footwear',
  'Clothing',
  'Furniture',
  'Books',
  'Sports',
  'Toys',
  'Beauty',
  'Grocery',
  'Appliances',
  'Home decor',
  'Other',
];

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts({String? category, String? search}) async {
    isLoading.value = true;
    try {
      final res = await ApiService.getProducts(
        category: category == 'All' ? null : category,
        search:   search,
      );

      if (res['status'] == true) {
        final list = (res['products'] as List)
            .map((e) => ProductModel.fromJson(e))
            .toList();
        products.value = list;
      } else {
        products.value = [];
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load products',
        backgroundColor: Colors.red,
        colorText:       Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void filterByCategory(String category) {
    selectedCategory.value = category;
    fetchProducts(
      category: category == 'All' ? null : category,
      search:   searchQuery.value.isEmpty ? null : searchQuery.value,
    );
  }

  void search(String query) {
    searchQuery.value = query;
    fetchProducts(
      category: selectedCategory.value == 'All'
          ? null
          : selectedCategory.value,
      search: query.isEmpty ? null : query,
    );
  }

  Future<void> addProduct(Map<String, dynamic> data) async {
    isLoading.value = true;
    try {
      final res = await ApiService.addProduct(data);
      if (res['status'] == true) {
        await fetchProducts();
        // Close bottom sheet only
        if (Get.isBottomSheetOpen ?? false) {
          Get.back();
        }
        Get.snackbar(
          'Success',
          'Product added successfully',
          backgroundColor: Colors.green,
          colorText:       Colors.white,
          snackPosition:   SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Error',
          res['message'] ?? 'Failed to add product',
          backgroundColor: Colors.red,
          colorText:       Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong',
        backgroundColor: Colors.red,
        colorText:       Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProduct(Map<String, dynamic> data) async {
    isLoading.value = true;
    try {
      final res = await ApiService.updateProduct(data);
      if (res['status'] == true) {
        await fetchProducts();
        // Close bottom sheet only
        if (Get.isBottomSheetOpen ?? false) {
          Get.back();
        }
        Get.snackbar(
          'Success',
          'Product updated successfully',
          backgroundColor: Colors.green,
          colorText:       Colors.white,
          snackPosition:   SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Error',
          res['message'] ?? 'Failed to update product',
          backgroundColor: Colors.red,
          colorText:       Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong',
        backgroundColor: Colors.red,
        colorText:       Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      final res = await ApiService.deleteProduct(id);
      if (res['status'] == true) {
        await fetchProducts();
        Get.snackbar(
          'Success',
          'Product deleted successfully',
          backgroundColor: Colors.green,
          colorText:       Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          res['message'] ?? 'Failed to delete product',
          backgroundColor: Colors.red,
          colorText:       Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong',
        backgroundColor: Colors.red,
        colorText:       Colors.white,
      );
    }
  }
}