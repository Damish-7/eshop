import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/admin_controller.dart';
import '../../utils/app_colors.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  final _ctrl = Get.find<AdminController>();

  // All possible statuses
  final List<String> _statuses = [
    'pending',
    'processing',
    'shipped',
    'delivered',
    'cancelled',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ctrl.fetchAllOrders();
    });
  }

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
            tooltip:   'Refresh',
            onPressed: () => _ctrl.fetchAllOrders(),
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
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.receipt_long_outlined,
                  size:  80,
                  color: AppColors.grey.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                const Text(
                  'No orders yet',
                  style: TextStyle(
                    fontSize: 18,
                    color:    AppColors.grey,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () => _ctrl.fetchAllOrders(),
                  icon:  const Icon(Icons.refresh),
                  label: const Text('Refresh'),
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
                margin:  const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color:        Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color:      Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset:     const Offset(0, 3),
                    ),
                  ],
                ),
                child: ExpansionTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  collapsedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  leading: Container(
                    width:  46,
                    height: 46,
                    decoration: BoxDecoration(
                      color:        AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
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
                    o.userName.isNotEmpty
                        ? o.userName
                        : 'Order #${o.id}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize:   15,
                    ),
                  ),
                  subtitle: Text(
                    '₹${o.totalAmount.toStringAsFixed(2)} • '
                    '${o.createdAt.length >= 10 ? o.createdAt.substring(0, 10) : o.createdAt}',
                    style: const TextStyle(
                      color:   AppColors.grey,
                      fontSize: 12,
                    ),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical:   5,
                    ),
                    decoration: BoxDecoration(
                      color: _statusColor(o.status).withOpacity(0.12),
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
                  // ─── Expanded Details ──────────────────────────────────
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Divider(),
                          const SizedBox(height: 8),
                          // Info Rows
                          if (o.userName.isNotEmpty)
                            _infoRow(Icons.person_outlined,     'Customer', o.userName),
                          const SizedBox(height: 6),
                          if (o.userEmail.isNotEmpty)
                            _infoRow(Icons.email_outlined,      'Email',    o.userEmail),
                          const SizedBox(height: 6),
                          _infoRow(Icons.location_on_outlined,  'Address',  o.address),
                          const SizedBox(height: 6),
                          _infoRow(Icons.shopping_bag_outlined, 'Items',    '${o.itemCount} item(s)'),
                          const SizedBox(height: 6),
                          _infoRow(Icons.currency_rupee,        'Total',    '₹${o.totalAmount.toStringAsFixed(2)}'),
                          const SizedBox(height: 6),
                          _infoRow(Icons.calendar_today_outlined,'Date',
                            o.createdAt.length >= 10
                                ? o.createdAt.substring(0, 10)
                                : o.createdAt,
                          ),
                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 12),

                          // ─── Status Update Section ─────────────────────
                          const Text(
                            'Update Order Status',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize:   15,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Status Steps Visual
                          _buildStatusStepper(o.status),
                          const SizedBox(height: 16),

                          // Status Dropdown Button
                          Container(
                            width:   double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical:   4,
                            ),
                            decoration: BoxDecoration(
                              color:        AppColors.background,
                              borderRadius: BorderRadius.circular(10),
                              border:       Border.all(
                                color: AppColors.lightGrey,
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value:        o.status,
                                isExpanded:   true,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: AppColors.primary,
                                ),
                                items: _statuses.map((s) {
                                  return DropdownMenuItem<String>(
                                    value: s,
                                    child: Row(
                                      children: [
                                        Container(
                                          width:  10,
                                          height: 10,
                                          decoration: BoxDecoration(
                                            color:  _statusColor(s),
                                            shape:  BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          s.capitalizeFirst!,
                                          style: TextStyle(
                                            color:      _statusColor(s),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (newStatus) {
                                  if (newStatus != null &&
                                      newStatus != o.status) {
                                    _confirmStatusChange(
                                      o.id,
                                      o.status,
                                      newStatus,
                                    );
                                  }
                                },
                              ),
                            ),
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

  // ─── Status Stepper Visual ────────────────────────────────────────────────
  Widget _buildStatusStepper(String currentStatus) {
    final steps = ['pending', 'processing', 'shipped', 'delivered'];
    final currentIndex = steps.indexOf(currentStatus);

    return Row(
      children: steps.asMap().entries.map((entry) {
        final index  = entry.key;
        final step   = entry.value;
        final isDone = currentIndex >= index;
        final isLast = index == steps.length - 1;

        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      width:  28,
                      height: 28,
                      decoration: BoxDecoration(
                        color:  isDone
                            ? _statusColor(step)
                            : AppColors.lightGrey,
                        shape:  BoxShape.circle,
                      ),
                      child: Icon(
                        _stepIcon(step),
                        size:  14,
                        color: isDone ? Colors.white : AppColors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      step.capitalizeFirst!,
                      style: TextStyle(
                        fontSize:   9,
                        color:      isDone
                            ? _statusColor(step)
                            : AppColors.grey,
                        fontWeight: isDone
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              // Connector Line
              if (!isLast)
                Expanded(
                  child: Container(
                    height: 2,
                    margin: const EdgeInsets.only(bottom: 18),
                    color:  currentIndex > index
                        ? AppColors.success
                        : AppColors.lightGrey,
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  IconData _stepIcon(String status) {
    switch (status) {
      case 'pending':    return Icons.hourglass_empty;
      case 'processing': return Icons.settings_outlined;
      case 'shipped':    return Icons.local_shipping_outlined;
      case 'delivered':  return Icons.check_circle_outline;
      default:           return Icons.circle_outlined;
    }
  }

  // ─── Confirm Dialog ───────────────────────────────────────────────────────
  void _confirmStatusChange(
      int orderId, String oldStatus, String newStatus) {
    Get.defaultDialog(
      title:      'Update Status',
      titleStyle: const TextStyle(fontWeight: FontWeight.bold),
      middleText:
          'Change order #$orderId status from\n'
          '"${oldStatus.capitalizeFirst}" → "${newStatus.capitalizeFirst}"?',
      textConfirm:      'Yes, Update',
      textCancel:       'Cancel',
      confirmTextColor: Colors.white,
      buttonColor:      AppColors.primary,
      onConfirm: () {
        Get.back();
        _ctrl.updateOrderStatus(orderId, newStatus);
      },
    );
  }

  // ─── Info Row ─────────────────────────────────────────────────────────────
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

  // ─── Status Color ─────────────────────────────────────────────────────────
  Color _statusColor(String status) {
    switch (status) {
      case 'pending':    return AppColors.orange;
      case 'processing': return Colors.blue;
      case 'shipped':    return AppColors.secondary;
      case 'delivered':  return AppColors.success;
      case 'cancelled':  return AppColors.error;
      default:           return AppColors.grey;
    }
  }
}