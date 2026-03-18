import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/address_model.dart';
import '../services/api_service.dart';
import 'auth_controller.dart';

class AddressController extends GetxController {
  final RxList<AddressModel>   addresses       = <AddressModel>[].obs;
  final Rx<AddressModel?>      selectedAddress = Rx<AddressModel?>(null);
  final RxBool                 isLoading       = false.obs;

  final AuthController _auth = Get.find<AuthController>();

  // Get default address
  AddressModel? get defaultAddress {
    try {
      return addresses.firstWhere((a) => a.isDefault);
    } catch (_) {
      return addresses.isNotEmpty ? addresses.first : null;
    }
  }

  @override
  void onInit() {
    super.onInit();
    ever(_auth.user, (_) => fetchAddresses());
    fetchAddresses();
  }

  Future<void> fetchAddresses() async {
    if (_auth.user.value == null) {
      addresses.clear();
      selectedAddress.value = null;
      return;
    }
    isLoading.value = true;
    try {
      final res = await ApiService.getAddresses(_auth.user.value!.id);
      if (res['status'] == true) {
        addresses.value = (res['addresses'] as List)
            .map((e) => AddressModel.fromJson(e))
            .toList();
        // Auto select default address
        selectedAddress.value = defaultAddress;
      }
    } catch (e) {
      addresses.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addAddress(Map<String, dynamic> data) async {
    isLoading.value = true;
    try {
      data['user_id'] = _auth.user.value!.id;
      final res = await ApiService.addAddress(data);
      if (res['status'] == true) {
        await fetchAddresses();
        Get.back();
        Get.snackbar(
          'Success',
          'Address added successfully',
          backgroundColor: Colors.green,
          colorText:       Colors.white,
          snackPosition:   SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Error',
          res['message'] ?? 'Failed to add address',
          backgroundColor: Colors.red,
          colorText:       Colors.white,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateAddress(Map<String, dynamic> data) async {
    isLoading.value = true;
    try {
      data['user_id'] = _auth.user.value!.id;
      final res = await ApiService.updateAddress(data);
      if (res['status'] == true) {
        await fetchAddresses();
        Get.back();
        Get.snackbar(
          'Success',
          'Address updated successfully',
          backgroundColor: Colors.green,
          colorText:       Colors.white,
          snackPosition:   SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Error',
          res['message'] ?? 'Failed to update address',
          backgroundColor: Colors.red,
          colorText:       Colors.white,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteAddress(int id) async {
    try {
      final res = await ApiService.deleteAddress(
        id,
        _auth.user.value!.id,
      );
      if (res['status'] == true) {
        await fetchAddresses();
        Get.snackbar(
          'Deleted',
          'Address removed successfully',
          backgroundColor: Colors.orange,
          colorText:       Colors.white,
          snackPosition:   SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete address',
        backgroundColor: Colors.red,
        colorText:       Colors.white,
      );
    }
  }

  Future<void> setDefault(int id) async {
    try {
      final res = await ApiService.setDefaultAddress(
        id,
        _auth.user.value!.id,
      );
      if (res['status'] == true) {
        await fetchAddresses();
        Get.snackbar(
          'Success',
          'Default address updated',
          backgroundColor: Colors.green,
          colorText:       Colors.white,
          snackPosition:   SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to set default',
        backgroundColor: Colors.red,
        colorText:       Colors.white,
      );
    }
  }

  void selectAddress(AddressModel address) {
    selectedAddress.value = address;
  }
}