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
          icon:      const Icon(Icons.arrow_back_ios),
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
                width:   double.infinity,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, Color(0xFF9C97FF)],
                    begin:  Alignment.topLeft,
                    end:    Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color:      AppColors.primary.withOpacity(0.3),
                      blurRadius: 20,
                      offset:     const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius:          45,
                      backgroundColor: Colors.white,
                      child: Text(
                        user.name[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize:   38,
                          color:      AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize:   22,
                        color:      Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email,
                      style: const TextStyle(
                        color:   Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    if (user.phone.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        user.phone,
                        style: const TextStyle(
                          color:   Colors.white60,
                          fontSize: 13,
                        ),
                      ),
                    ],
                    if (user.isAdmin) ...[
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical:   6,
                        ),
                        decoration: BoxDecoration(
                          color:        AppColors.orange,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.admin_panel_settings,
                              color: Colors.white,
                              size:  16,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'ADMIN',
                              style: TextStyle(
                                color:      Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize:   13,
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
                icon:    Icons.shopping_bag_outlined,
                title:   'My Orders',
                subtitle: 'View your order history',
                onTap:   () => _showOrders(context, user.id),
              ),
              const SizedBox(height: 10),
              _menuTile(
                icon:    Icons.location_on_outlined,
                title:   'Address',
                subtitle: user.address.isEmpty
                    ? 'No address saved'
                    : user.address,
              ),
              if (user.isAdmin) ...[
                const SizedBox(height: 10),
                _menuTile(
                  icon:    Icons.admin_panel_settings_outlined,
                  title:   'Admin Panel',
                  subtitle: 'Manage products and orders',
                  color:   AppColors.orange,
                  onTap:   () => Get.toNamed('/admin'),
                ),
              ],
              const SizedBox(height: 24),
              // Logout Button
              SizedBox(
                width:  double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () => Get.defaultDialog(
                    title:      'Logout',
                    middleText: 'Are you sure you want to logout?',
                    textConfirm:    'Logout',
                    textCancel:     'Cancel',
                    confirmTextColor: Colors.white,
                    buttonColor:  AppColors.error,
                    onConfirm: () {
                      Get.back();
                      _auth.logout();
                    },
                  ),
                  icon:  const Icon(Icons.logout, color: AppColors.error),
                  label: const Text(
                    'Logout',
                    style: TextStyle(
                      color:    AppColors.error,
                      fontSize: 16,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side:  const BorderSide(color: AppColors.error),
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
    required String   title,
    String?           subtitle,
    Color             color = AppColors.primary,
    VoidCallback?     onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color:        Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color:      Colors.black.withOpacity(0.04),
            blurRadius: 8,
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color:        color.withOpacity(0.1),
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
                style: const TextStyle(color: AppColors.grey, fontSize: 12),
                maxLines:  1,
                overflow:  TextOverflow.ellipsis,
              )
            : null,
        trailing: onTap != null
            ? const Icon(
                Icons.arrow_forward_ios,
                size:  14,
                color: AppColors.grey,
              )
            : null,
        onTap:  onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  void _showOrders(BuildContext context, int userId) {
    Get.bottomSheet(
      isScrollControlled: true,
      Container(
        height:  MediaQuery.of(context).size.height * 0.75,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color:        Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Container(
              width:  40,
              height: 4,
              decoration: BoxDecoration(
                color:        AppColors.lightGrey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'My Orders',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<Map<String, dynamic>>(
                future:  ApiService.getOrders(userId),
                builder: (_, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    );
                  }
                  if (!snap.hasData || snap.data?['status'] != true) {
                    return const Center(child: Text('No orders found'));
                  }
                  final orders = (snap.data!['orders'] as List)
                      .map((e) => OrderModel.fromJson(e))
                      .toList();

                  if (orders.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size:  60,
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
                    itemCount:   orders.length,
                    itemBuilder: (_, i) {
                      final o = orders[i];
                      return Container(
                        margin:  const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color:        AppColors.background,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.lightGrey),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color:        AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.receipt_outlined,
                                color: AppColors.primary,
                                size:  22,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Order #${o.id}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '₹${o.totalAmount.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  Text(
                                    o.createdAt.length >= 10
                                        ? o.createdAt.substring(0, 10)
                                        : o.createdAt,
                                    style: const TextStyle(
                                      color:   AppColors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical:   5,
                              ),
                              decoration: BoxDecoration(
                                color: _statusColor(o.status).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                o.status.toUpperCase(),
                                style: TextStyle(
                                  color:      _statusColor(o.status),
                                  fontSize:   10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'delivered':  return AppColors.success;
      case 'cancelled':  return AppColors.error;
      case 'shipped':    return AppColors.secondary;
      case 'processing': return AppColors.orange;
      default:           return AppColors.grey;
    }
  }
}