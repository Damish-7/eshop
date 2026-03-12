import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/order_model.dart';
import '../services/api_service.dart';

class AdminController extends GetxController {
  final RxList<OrderModel> orders    = <OrderModel>[].obs;
  final RxBool             isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllOrders();
  }

  Future<void> fetchAllOrders() async {
    isLoading.value = true;
    try {
      final res = await ApiService.getAllOrders();
      if (res['status'] == true) {
        orders.value = (res['orders'] as List)
            .map((e) => OrderModel.fromJson(e))
            .toList();
      } else {
        orders.value = [];
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load orders',
        backgroundColor: Colors.red,
        colorText:       Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}