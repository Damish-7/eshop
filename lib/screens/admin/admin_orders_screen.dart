import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/admin_controller.dart';
import '../../utils/app_colors.dart';

class AdminOrdersScreen extends StatelessWidget {
  AdminOrdersScreen({super.key});

  final _ctrl = Get.find<AdminController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('All Orders'),
        leading: IconButton(
          icon:      const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon:      const Icon(Icons.refresh),
            onPressed: _ctrl.fetchAllOrders,
          ),
        ],
      ),
      body: Obx(() {
        if (_ctrl.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (_ctrl.orders.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.receipt_long_outlined,
                  size:  80,
                  color: AppColors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'No orders yet',
                  style: TextStyle(
                    fontSize: 18,
                    color:    AppColors.grey,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _ctrl.fetchAllOrders,
          color:     AppColors.primary,
          child: ListView.builder(
            padding:     const EdgeInsets.all(12),
            itemCount:   _ctrl.orders.length,
            itemBuilder: (_, i) {
              final o = _ctrl.orders[i];
              return Container(
                margin:  const EdgeInsets.only(bottom: 10),
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
                child: ExpansionTile(
                  leading: Container(
                    width:  44,
                    height: 44,
                    decoration: BoxDecoration(
                      color:        AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        '#${o.id}',
                        style: const TextStyle(
                          color:      AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize:   12,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    o.userName.isNotEmpty ? o.userName : 'Order #${o.id}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '₹${o.totalAmount.toStringAsFixed(2)} • ${o.createdAt.length >= 10 ? o.createdAt.substring(0, 10) : o.createdAt}',
                    style: const TextStyle(color: AppColors.grey),
                  ),
                  trailing: Container(
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
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Divider(),
                          const SizedBox(height: 8),
                          // Customer Email
                          if (o.userEmail.isNotEmpty)
                            _infoRow(
                              Icons.email_outlined,
                              'Email',
                              o.userEmail,
                            ),
                          const SizedBox(height: 6),
                          // Address
                          _infoRow(
                            Icons.location_on_outlined,
                            'Address',
                            o.address,
                          ),
                          const SizedBox(height: 6),
                          // Items Count
                          _infoRow(
                            Icons.shopping_bag_outlined,
                            'Items',
                            '${o.itemCount} item(s)',
                          ),
                          const SizedBox(height: 6),
                          // Total
                          _infoRow(
                            Icons.currency_rupee,
                            'Total',
                            '₹${o.totalAmount.toStringAsFixed(2)}',
                          ),
                          const SizedBox(height: 12),
                          // Status Dropdown
                          Row(
                            children: [
                              const Text(
                                'Status: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical:   6,
                                ),
                                decoration: BoxDecoration(
                                  color: _statusColor(o.status).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: _statusColor(o.status).withOpacity(0.4),
                                  ),
                                ),
                                child: Text(
                                  o.status.capitalizeFirst!,
                                  style: TextStyle(
                                    color:      _statusColor(o.status),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.grey),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize:   13,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color:   AppColors.grey,
              fontSize: 13,
            ),
          ),
        ),
      ],
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