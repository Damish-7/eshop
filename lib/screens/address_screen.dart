import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/address_controller.dart';
import '../controllers/auth_controller.dart';
import '../models/address_model.dart';
import '../utils/app_colors.dart';
import '../utils/validators.dart';

class AddressScreen extends StatelessWidget {
  AddressScreen({super.key});

  final _ctrl = Get.find<AddressController>();
  final _auth = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Addresses'),
        leading: IconButton(
          icon:      const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        onPressed:       () => _showAddressForm(context),
        icon:            const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add Address',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Obx(() {
        if (_ctrl.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (_ctrl.addresses.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_off_outlined,
                  size:  80,
                  color: AppColors.grey.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                const Text(
                  'No Addresses Saved',
                  style: TextStyle(
                    fontSize:   20,
                    fontWeight: FontWeight.bold,
                    color:      AppColors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Add an address to place orders faster!',
                  style: TextStyle(color: AppColors.grey),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => _showAddressForm(context),
                  icon:  const Icon(Icons.add),
                  label: const Text('Add New Address'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _ctrl.fetchAddresses,
          color:     AppColors.primary,
          child: ListView.builder(
            padding:     const EdgeInsets.fromLTRB(16, 16, 16, 80),
            itemCount:   _ctrl.addresses.length,
            itemBuilder: (_, i) {
              final address = _ctrl.addresses[i];
              return _AddressCard(
                address:   address,
                onEdit:    () => _showAddressForm(context, address: address),
                onDelete:  () => _confirmDelete(address),
                onDefault: () => _ctrl.setDefault(address.id),
              );
            },
          ),
        );
      }),
    );
  }

  void _confirmDelete(AddressModel address) {
    Get.defaultDialog(
      title:      'Delete Address',
      middleText: 'Delete this address?\n${address.address}, ${address.city}',
      textConfirm:      'Delete',
      textCancel:       'Cancel',
      confirmTextColor: Colors.white,
      buttonColor:      AppColors.error,
      onConfirm: () {
        Get.back();
        _ctrl.deleteAddress(address.id);
      },
    );
  }

  void _showAddressForm(BuildContext context, {AddressModel? address}) {
    final formKey       = GlobalKey<FormState>();
    final fullNameCtrl  = TextEditingController(text: address?.fullName ?? '');
    final phoneCtrl     = TextEditingController(text: address?.phone    ?? '');
    final addressCtrl   = TextEditingController(text: address?.address  ?? '');
    final cityCtrl      = TextEditingController(text: address?.city     ?? '');
    final stateCtrl     = TextEditingController(text: address?.state    ?? '');
    final pincodeCtrl   = TextEditingController(text: address?.pincode  ?? '');
    final selectedLabel = (address?.label ?? 'Home').obs;
    final isDefault     = (address?.isDefault ?? false).obs;

    final labels = ['Home', 'Work', 'Other'];

    Get.bottomSheet(
      isScrollControlled: true,
      Container(
        height:  MediaQuery.of(context).size.height * 0.92,
        padding: EdgeInsets.only(
          left:   20,
          right:  20,
          top:    20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        decoration: const BoxDecoration(
          color:        Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle + Close
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 40, height: 4,
                      decoration: BoxDecoration(
                        color:        AppColors.lightGrey,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    IconButton(
                      icon:      const Icon(Icons.close),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
                Text(
                  address == null ? 'Add New Address' : 'Edit Address',
                  style: const TextStyle(
                    fontSize:   20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // Label Selector
                const Text(
                  'Address Label',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize:   14,
                  ),
                ),
                const SizedBox(height: 10),
                Obx(() => Row(
                  children: labels.map((label) {
                    final isSelected = selectedLabel.value == label;
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: GestureDetector(
                        onTap: () => selectedLabel.value = label,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical:   10,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.background,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.lightGrey,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _labelIcon(label),
                                size:  16,
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.grey,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                label,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                )),
                const SizedBox(height: 16),

                // Full Name
                _buildField(
                  controller: fullNameCtrl,
                  label:      'Full Name *',
                  icon:       Icons.person_outlined,
                  validator:  (v) =>
                      Validators.validateRequired(v, 'Full name'),
                ),
                const SizedBox(height: 12),

                // Phone
                _buildField(
                  controller:   phoneCtrl,
                  label:        'Phone Number *',
                  icon:         Icons.phone_outlined,
                  validator:    Validators.validatePhone,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),

                // Address
                _buildField(
                  controller: addressCtrl,
                  label:      'Full Address *',
                  icon:       Icons.home_outlined,
                  validator:  (v) =>
                      Validators.validateRequired(v, 'Address'),
                  maxLines:   3,
                ),
                const SizedBox(height: 12),

                // City + State Row
                Row(
                  children: [
                    Expanded(
                      child: _buildField(
                        controller: cityCtrl,
                        label:      'City *',
                        icon:       Icons.location_city_outlined,
                        validator:  (v) =>
                            Validators.validateRequired(v, 'City'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildField(
                        controller: stateCtrl,
                        label:      'State *',
                        icon:       Icons.map_outlined,
                        validator:  (v) =>
                            Validators.validateRequired(v, 'State'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Pincode
                _buildField(
                  controller:   pincodeCtrl,
                  label:        'Pincode *',
                  icon:         Icons.pin_drop_outlined,
                  validator:    (v) =>
                      Validators.validateRequired(v, 'Pincode'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),

                // Set as Default Toggle
                Obx(() => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical:   12,
                  ),
                  decoration: BoxDecoration(
                    color:        AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.lightGrey),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.star_outlined,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Set as Default',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Use this address automatically at checkout',
                              style: TextStyle(
                                color:   AppColors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value:          isDefault.value,
                        onChanged:      (val) => isDefault.value = val,
                        activeColor:    AppColors.primary,
                      ),
                    ],
                  ),
                )),
                const SizedBox(height: 24),

                // Submit Button
                SizedBox(
                  width:  double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        final data = {
                          'label':      selectedLabel.value,
                          'full_name':  fullNameCtrl.text.trim(),
                          'phone':      phoneCtrl.text.trim(),
                          'address':    addressCtrl.text.trim(),
                          'city':       cityCtrl.text.trim(),
                          'state':      stateCtrl.text.trim(),
                          'pincode':    pincodeCtrl.text.trim(),
                          'is_default': isDefault.value ? 1 : 0,
                        };
                        if (address != null) {
                          data['id'] = address.id;
                          _ctrl.updateAddress(data);
                        } else {
                          _ctrl.addAddress(data);
                        }
                      }
                    },
                    icon: Icon(
                      address == null
                          ? Icons.add_location_alt_outlined
                          : Icons.save_outlined,
                    ),
                    label: Text(
                      address == null
                          ? 'Save Address'
                          : 'Update Address',
                      style: const TextStyle(
                        fontSize:   17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _labelIcon(String label) {
    switch (label) {
      case 'Home':  return Icons.home_outlined;
      case 'Work':  return Icons.work_outlined;
      default:      return Icons.location_on_outlined;
    }
  }

  Widget _buildField({
    required TextEditingController controller,
    required String                label,
    required IconData              icon,
    String? Function(String?)?     validator,
    int                            maxLines    = 1,
    TextInputType?                 keyboardType,
  }) {
    return TextFormField(
      controller:   controller,
      validator:    validator,
      maxLines:     maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText:  label,
        prefixIcon: Icon(icon, color: AppColors.primary),
        filled:     true,
        fillColor:  AppColors.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:   BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              const BorderSide(color: AppColors.lightGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.error),
        ),
      ),
    );
  }
}

// ─── Address Card Widget ──────────────────────────────────────────────────────
class _AddressCard extends StatelessWidget {
  final AddressModel address;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onDefault;

  const _AddressCard({
    required this.address,
    required this.onEdit,
    required this.onDelete,
    required this.onDefault,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:  const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:        Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: address.isDefault
              ? AppColors.primary
              : AppColors.lightGrey,
          width: address.isDefault ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color:      Colors.black.withOpacity(0.05),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label Row + Default Badge
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical:   5,
                ),
                decoration: BoxDecoration(
                  color:        AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      _labelIcon(address.label),
                      size:  14,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      address.label,
                      style: const TextStyle(
                        color:      AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize:   12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (address.isDefault)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical:   5,
                  ),
                  decoration: BoxDecoration(
                    color:        Colors.amber.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.star,
                        size:  12,
                        color: Colors.amber,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Default',
                        style: TextStyle(
                          color:      Colors.amber,
                          fontWeight: FontWeight.bold,
                          fontSize:   12,
                        ),
                      ),
                    ],
                  ),
                ),
              const Spacer(),
              // Edit Button
              IconButton(
                icon: const Icon(
                  Icons.edit_outlined,
                  color: AppColors.primary,
                  size:  20,
                ),
                onPressed: onEdit,
                padding:   EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 8),
              // Delete Button
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: AppColors.error,
                  size:  20,
                ),
                onPressed: onDelete,
                padding:   EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Name + Phone
          Text(
            address.fullName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize:   16,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            address.phone,
            style: const TextStyle(
              color:   AppColors.grey,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 6),

          // Address
          Text(
            '${address.address}, ${address.city}',
            style: const TextStyle(fontSize: 14),
          ),
          Text(
            '${address.state} - ${address.pincode}',
            style: const TextStyle(
              color:   AppColors.grey,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 12),

          // Set as Default Button
          if (!address.isDefault)
            GestureDetector(
              onTap: onDefault,
              child: Container(
                width:   double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color:        AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.lightGrey),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.star_border,
                      size:  16,
                      color: AppColors.grey,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Set as Default',
                      style: TextStyle(
                        color:      AppColors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  IconData _labelIcon(String label) {
    switch (label) {
      case 'Home':  return Icons.home_outlined;
      case 'Work':  return Icons.work_outlined;
      default:      return Icons.location_on_outlined;
    }
  }
}