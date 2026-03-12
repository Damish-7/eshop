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

  Future<void> updateOrderStatus(int orderId, String status) async {
    try {
      final res = await ApiService.updateOrderStatus(orderId, status);
      if (res['status'] == true) {
        // Update locally without full refresh
        final index = orders.indexWhere((o) => o.id == orderId);
        if (index != -1) {
          final updatedOrder = OrderModel(
            id:          orders[index].id,
            userId:      orders[index].userId,
            totalAmount: orders[index].totalAmount,
            status:      status,
            address:     orders[index].address,
            createdAt:   orders[index].createdAt,
            userName:    orders[index].userName,
            userEmail:   orders[index].userEmail,
            itemCount:   orders[index].itemCount,
          );
          orders[index] = updatedOrder;
          orders.refresh();
        }
        Get.snackbar(
          'Success',
          'Order status updated to ${status.capitalizeFirst}',
          backgroundColor: Colors.green,
          colorText:       Colors.white,
          snackPosition:   SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Error',
          res['message'] ?? 'Failed to update status',
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