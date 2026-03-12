import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/product_controller.dart';
import '../../controllers/admin_controller.dart';
import '../../utils/app_colors.dart';

class AdminDashboardScreen extends StatelessWidget {
  AdminDashboardScreen({super.key});

  final _auth = Get.find<AuthController>();
  final _productCtrl = Get.find<ProductController>();
  final _adminCtrl = Get.find<AdminController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.storefront_outlined),
            tooltip: 'View Store',
            onPressed: () => Get.toNamed('/home'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => Get.defaultDialog(
              title: 'Logout',
              middleText: 'Are you sure?',
              textConfirm: 'Logout',
              textCancel: 'Cancel',
              confirmTextColor: Colors.white,
              buttonColor: AppColors.error,
              onConfirm: () {
                Get.back();
                _auth.logout();
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome
            Obx(() => Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, Color(0xFF9C97FF)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 24,
                        child: Icon(
                          Icons.admin_panel_settings,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome, ${_auth.user.value?.name ?? 'Admin'}!',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const Text(
                            'Manage your eShop',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 24),
            const Text(
              'Overview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            // Stats Row
            Row(
              children: [
                Expanded(
                  child: Obx(() => _statCard(
                        label: 'Products',
                        value: '${_productCtrl.products.length}',
                        icon: Icons.inventory_2_outlined,
                        color: AppColors.primary,
                      )),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Obx(() => _statCard(
                        label: 'Orders',
                        value: '${_adminCtrl.orders.length}',
                        icon: Icons.receipt_long_outlined,
                        color: AppColors.success,
                      )),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            // Action Cards
            _actionCard(
              icon: Icons.inventory_2_outlined,
              title: 'Manage Products',
              subtitle: 'Add, edit or delete products',
              color: AppColors.primary,
              onTap: () => Get.toNamed('/admin-products'),
            ),
            const SizedBox(height: 12),
            _actionCard(
              icon: Icons.receipt_long_outlined,
              title: 'View All Orders',
              subtitle: 'Monitor and manage customer orders',
              color: AppColors.success,
              onTap: () {
                _adminCtrl.fetchAllOrders(); // ← refresh before navigating
                Get.toNamed('/admin-orders');
              },
            ),
            const SizedBox(height: 12),
            _actionCard(
              icon: Icons.storefront_outlined,
              title: 'View Store',
              subtitle: 'Preview store as a customer',
              color: AppColors.orange,
              onTap: () => Get.toNamed('/home'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                label,
                style: const TextStyle(color: AppColors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.grey,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: AppColors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
