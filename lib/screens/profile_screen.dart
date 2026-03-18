import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../models/order_model.dart';
import '../services/api_service.dart';
import '../utils/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final _auth = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        final user = _auth.user.value;
        if (user == null) {
          return const Center(child: Text('Not logged in'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Profile Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, Color(0xFF9C97FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.white,
                      child: Text(
                        user.name[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 38,
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    if (user.phone.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        user.phone,
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 13,
                        ),
                      ),
                    ],
                    if (user.isAdmin) ...[
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.orange,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.admin_panel_settings,
                              color: Colors.white,
                              size: 16,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'ADMIN',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Menu Options
              _menuTile(
                icon: Icons.shopping_bag_outlined,
                title: 'My Orders',
                subtitle: 'View and manage your orders',
                onTap: () => _showOrders(context, user.id),
              ),
              const SizedBox(height: 10),

              _menuTile(
                icon: Icons.favorite_outlined,
                title: 'My Wishlist',
                subtitle: 'Products you have saved',
                color: Colors.red,
                onTap: () => Get.toNamed('/wishlist'),
              ),

              _menuTile(
                icon: Icons.location_on_outlined,
                title: 'Address',
                subtitle: 'Address you have saved',
                onTap: () => Get.toNamed('/addresses'),
                    // user.address.isEmpty ? 'No address saved' : user.address,
              ),

              if (user.isAdmin) ...[
                const SizedBox(height: 10),
                _menuTile(
                  icon: Icons.admin_panel_settings_outlined,
                  title: 'Admin Panel',
                  subtitle: 'Manage products and orders',
                  color: AppColors.orange,
                  onTap: () => Get.toNamed('/admin'),
                ),
              ],
              const SizedBox(height: 24),

              // Logout Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () => Get.defaultDialog(
                    title: 'Logout',
                    middleText: 'Are you sure you want to logout?',
                    textConfirm: 'Logout',
                    textCancel: 'Cancel',
                    confirmTextColor: Colors.white,
                    buttonColor: AppColors.error,
                    onConfirm: () {
                      Get.back();
                      _auth.logout();
                    },
                  ),
                  icon: const Icon(Icons.logout, color: AppColors.error),
                  label: const Text(
                    'Logout',
                    style: TextStyle(color: AppColors.error, fontSize: 16),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.error),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _menuTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Color color = AppColors.primary,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: const TextStyle(
                  color: AppColors.grey,
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        trailing: onTap != null
            ? const Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: AppColors.grey,
              )
            : null,
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  // ─── Orders Bottom Sheet ──────────────────────────────────────────────────
  void _showOrders(BuildContext context, int userId) {
    // Use RxList so UI updates after cancel
    final orders = <OrderModel>[].obs;
    final isLoading = true.obs;

    // Load orders
    ApiService.getOrders(userId).then((res) {
      if (res['status'] == true) {
        orders.value =
            (res['orders'] as List).map((e) => OrderModel.fromJson(e)).toList();
      }
      isLoading.value = false;
    });

    Get.bottomSheet(
      isScrollControlled: true,
      Container(
        height: MediaQuery.of(context).size.height * 0.80,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Handle Bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'My Orders',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _menuTile(
              icon: Icons.location_on_outlined,
              title: 'My Addresses',
              subtitle: 'Manage your delivery addresses',
              color: AppColors.primary,
              onTap: () => Get.toNamed('/addresses'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                if (isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  );
                }

                if (orders.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long_outlined,
                          size: 60,
                          color: AppColors.grey,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'No orders yet',
                          style: TextStyle(color: AppColors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (_, i) {
                    final o = orders[i];
                    final canCancel =
                        o.status == 'pending' || o.status == 'processing';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: AppColors.lightGrey,
                        ),
                      ),
                      child: Column(
                        children: [
                          // Order Header
                          Padding(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color:
                                        _statusColor(o.status).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    _statusIcon(o.status),
                                    color: _statusColor(o.status),
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Order #${o.id}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '₹${o.totalAmount.toStringAsFixed(2)} • ${o.itemCount} item(s)',
                                        style: const TextStyle(
                                          color: AppColors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        o.createdAt.length >= 10
                                            ? o.createdAt.substring(0, 10)
                                            : o.createdAt,
                                        style: const TextStyle(
                                          color: AppColors.grey,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Status Badge
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        _statusColor(o.status).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    o.status.toUpperCase(),
                                    style: TextStyle(
                                      color: _statusColor(o.status),
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Address Row
                          if (o.address.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.location_on_outlined,
                                    size: 14,
                                    color: AppColors.grey,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      o.address,
                                      style: const TextStyle(
                                        color: AppColors.grey,
                                        fontSize: 12,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          // Cancel Button — only for pending/processing
                          if (canCancel) ...[
                            const Divider(height: 1),
                            TextButton.icon(
                              onPressed: () => _confirmCancel(
                                context,
                                o.id,
                                userId,
                                orders,
                              ),
                              icon: const Icon(
                                Icons.cancel_outlined,
                                color: AppColors.error,
                                size: 18,
                              ),
                              label: const Text(
                                'Cancel Order',
                                style: TextStyle(
                                  color: AppColors.error,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],

                          // Cannot cancel message
                          if (!canCancel && o.status != 'cancelled') ...[
                            const Divider(height: 1),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    size: 14,
                                    color: AppColors.grey.withOpacity(0.6),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    o.status == 'delivered'
                                        ? 'Order delivered successfully'
                                        : 'Cannot cancel — order is ${o.status}',
                                    style: TextStyle(
                                      color: AppColors.grey.withOpacity(0.7),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Confirm Cancel Dialog ────────────────────────────────────────────────
  void _confirmCancel(
    BuildContext context,
    int orderId,
    int userId,
    RxList<OrderModel> orders,
  ) {
    Get.defaultDialog(
      title: 'Cancel Order',
      titleStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        color: AppColors.error,
      ),
      middleText: 'Are you sure you want to cancel Order #$orderId?\n\n'
          'This action cannot be undone.',
      textConfirm: 'Yes, Cancel Order',
      textCancel: 'Keep Order',
      confirmTextColor: Colors.white,
      buttonColor: AppColors.error,
      onConfirm: () async {
        Get.back();
        // Show loading
        Get.dialog(
          const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          barrierDismissible: false,
        );

        final res = await ApiService.cancelOrder(orderId, userId);
        Get.back(); // close loading

        if (res['status'] == true) {
          // Update order status locally
          final index = orders.indexWhere((o) => o.id == orderId);
          if (index != -1) {
            final updated = OrderModel(
              id: orders[index].id,
              userId: orders[index].userId,
              totalAmount: orders[index].totalAmount,
              status: 'cancelled',
              address: orders[index].address,
              createdAt: orders[index].createdAt,
              userName: orders[index].userName,
              userEmail: orders[index].userEmail,
              itemCount: orders[index].itemCount,
            );
            orders[index] = updated;
            orders.refresh();
          }
          Get.snackbar(
            'Order Cancelled',
            'Your order #$orderId has been cancelled successfully',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          Get.snackbar(
            'Cannot Cancel',
            res['message'] ?? 'Failed to cancel order',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      },
    );
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────
  Color _statusColor(String status) {
    switch (status) {
      case 'pending':
        return AppColors.orange;
      case 'processing':
        return Colors.blue;
      case 'shipped':
        return AppColors.secondary;
      case 'delivered':
        return AppColors.success;
      case 'cancelled':
        return AppColors.error;
      default:
        return AppColors.grey;
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'pending':
        return Icons.hourglass_empty;
      case 'processing':
        return Icons.settings_outlined;
      case 'shipped':
        return Icons.local_shipping_outlined;
      case 'delivered':
        return Icons.check_circle_outline;
      case 'cancelled':
        return Icons.cancel_outlined;
      default:
        return Icons.receipt_outlined;
    }
  }
}
