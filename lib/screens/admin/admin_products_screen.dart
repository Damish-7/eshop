import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/product_controller.dart';
import '../../models/product_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/validators.dart';

class AdminProductsScreen extends StatelessWidget {
  AdminProductsScreen({super.key});

  final _ctrl = Get.find<ProductController>();

  // ─── Category Icon Helper ─────────────────────────────────────────────────
  IconData _categoryIcon(String category) {
    switch (category) {
      case 'Electronics':  return Icons.devices_outlined;
      case 'Laptops':      return Icons.laptop_outlined;
      case 'Footwear':     return Icons.snowshoeing_outlined;
      case 'Clothing':     return Icons.checkroom_outlined;
      case 'Furniture':    return Icons.chair_outlined;
      case 'Books':        return Icons.menu_book_outlined;
      case 'Sports':       return Icons.sports_soccer_outlined;
      case 'Toys':         return Icons.toys_outlined;
      case 'Beauty':       return Icons.face_retouching_natural_outlined;
      case 'Grocery':      return Icons.local_grocery_store_outlined;
      case 'Appliances':   return Icons.kitchen_outlined;
      case 'Home decor':   return Icons.home_outlined;  // ← ADD THIS
      default:             return Icons.category_outlined;
    }
  }

  // ─── Image Placeholder ────────────────────────────────────────────────────
  Widget _imagePlaceholder() {
    return Container(
      width:  65,
      height: 65,
      color:  AppColors.lightGrey,
      child:  const Icon(
        Icons.image_not_supported_outlined,
        color: AppColors.grey,
      ),
    );
  }

  // ─── Delete Confirm ───────────────────────────────────────────────────────
  void _confirmDelete(ProductModel p) {
    Get.defaultDialog(
      title:            'Delete Product',
      middleText:       'Are you sure you want to delete "${p.name}"?',
      textConfirm:      'Delete',
      textCancel:       'Cancel',
      confirmTextColor: Colors.white,
      buttonColor:      AppColors.error,
      onConfirm: () {
        Get.back();
        _ctrl.deleteProduct(p.id);
      },
    );
  }

  // ─── Add / Edit Product Form ──────────────────────────────────────────────
  void _showProductForm(BuildContext context, {ProductModel? product}) {
    final formKey    = GlobalKey<FormState>();
    final nameCtrl   = TextEditingController(text: product?.name ?? '');
    final descCtrl   = TextEditingController(text: product?.description ?? '');
    final priceCtrl  = TextEditingController(
        text: product != null ? product.price.toString() : '');
    final stockCtrl  = TextEditingController(
        text: product != null ? product.stock.toString() : '');
    final catCtrl    = TextEditingController(text: product?.category ?? '');
    final imgCtrl    = TextEditingController(text: product?.imageUrl ?? '');

    // Reactive image URL for live preview
    final previewUrl  = (product?.imageUrl ?? '').obs;

    // Reactive category for dropdown
   // All categories list
final categoryList = [
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
  'Home decor',  // ← Add any existing categories here
  'Other',
];

// Reactive category — check if product category exists in list
// If not found, set to empty so dropdown shows hint instead of crashing
final existingCat  = product?.category ?? '';
final selectedCat  = (categoryList.contains(existingCat) ? existingCat : '').obs;

// Sync controller
catCtrl.text = selectedCat.value;

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

                // ─── Handle Bar + Close Button ───────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width:  40,
                      height: 4,
                      decoration: BoxDecoration(
                        color:        AppColors.lightGrey,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    IconButton(
                      icon:      const Icon(Icons.close, color: AppColors.grey),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // ─── Title ───────────────────────────────────────────────
                Text(
                  product == null ? 'Add New Product' : 'Edit Product',
                  style: const TextStyle(
                    fontSize:   20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // ─── Live Image Preview ──────────────────────────────────
                const Text(
                  'Image Preview',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize:   14,
                  ),
                ),
                const SizedBox(height: 10),
                Obx(() => Container(
                  width:  double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color:        AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(14),
                    border:       Border.all(color: AppColors.lightGrey),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: previewUrl.value.isEmpty
                        ? const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate_outlined,
                                size:  50,
                                color: AppColors.grey,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Enter image URL below to preview',
                                style: TextStyle(
                                  color:   AppColors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          )
                        : Image.network(
                            previewUrl.value,
                            fit:   BoxFit.cover,
                            width: double.infinity,
                            loadingBuilder: (_, child, progress) {
                              if (progress == null) return child;
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primary,
                                ),
                              );
                            },
                            errorBuilder: (_, __, ___) => const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.broken_image_outlined,
                                  size:  50,
                                  color: AppColors.error,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Invalid image URL',
                                  style: TextStyle(
                                    color:   AppColors.error,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                )),
                const SizedBox(height: 16),

                // ─── Image URL Field ─────────────────────────────────────
                TextFormField(
                  controller: imgCtrl,
                  onChanged:  (val) => previewUrl.value = val.trim(),
                  decoration: InputDecoration(
                    labelText:  'Image URL',
                    prefixIcon: const Icon(
                      Icons.image_outlined,
                      color: AppColors.primary,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.refresh,
                        color: AppColors.primary,
                      ),
                      tooltip:   'Reload Preview',
                      onPressed: () {
                        final url = imgCtrl.text.trim();
                        previewUrl.value = '';
                        Future.delayed(
                          const Duration(milliseconds: 100),
                          () => previewUrl.value = url,
                        );
                      },
                    ),
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
                  ),
                ),
                const SizedBox(height: 14),

                // ─── Product Name ────────────────────────────────────────
                TextFormField(
                  controller: nameCtrl,
                  validator:  (v) =>
                      Validators.validateRequired(v, 'Product name'),
                  decoration: InputDecoration(
                    labelText:  'Product Name *',
                    prefixIcon: const Icon(
                      Icons.inventory_2_outlined,
                      color: AppColors.primary,
                    ),
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
                      borderSide:
                          const BorderSide(color: AppColors.error),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // ─── Description ─────────────────────────────────────────
                TextFormField(
                  controller: descCtrl,
                  maxLines:   3,
                  decoration: InputDecoration(
                    labelText:  'Description',
                    prefixIcon: const Icon(
                      Icons.description_outlined,
                      color: AppColors.primary,
                    ),
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
                  ),
                ),
                const SizedBox(height: 14),

                // ─── Price & Stock Row ───────────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller:   priceCtrl,
                        validator:    Validators.validatePrice,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText:  'Price (₹) *',
                          prefixIcon: const Icon(
                            Icons.currency_rupee,
                            color: AppColors.primary,
                          ),
                          filled:     true,
                          fillColor:  AppColors.background,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:   BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: AppColors.lightGrey,
                            ),
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
                            borderSide: const BorderSide(
                              color: AppColors.error,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller:   stockCtrl,
                        validator:    Validators.validateStock,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText:  'Stock *',
                          prefixIcon: const Icon(
                            Icons.warehouse_outlined,
                            color: AppColors.primary,
                          ),
                          filled:     true,
                          fillColor:  AppColors.background,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:   BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: AppColors.lightGrey,
                            ),
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
                            borderSide: const BorderSide(
                              color: AppColors.error,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // ─── Category Dropdown ───────────────────────────────────
                const Text(
                  'Category *',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize:   14,
                    color:      AppColors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Obx(() => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical:   4,
                  ),
                  decoration: BoxDecoration(
                    color:        AppColors.background,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: selectedCat.value.isEmpty
                          ? AppColors.lightGrey
                          : AppColors.primary.withOpacity(0.4),
                      width: selectedCat.value.isEmpty ? 1 : 1.5,
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedCat.value.isEmpty
                          ? null
                          : selectedCat.value,
                      hint: const Text(
                        'Select Category',
                        style: TextStyle(
                          color:   AppColors.grey,
                          fontSize: 15,
                        ),
                      ),
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.primary,
                      ),
                      isExpanded: true,
                      items: categoryList.map((cat) {
                        return DropdownMenuItem<String>(
                          value: cat,
                          child: Row(
                            children: [
                              Icon(
                                _categoryIcon(cat), // ✅ works because it's in the same class
                                size:  18,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                cat,
                                style: const TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          selectedCat.value = val;
                          catCtrl.text      = val;
                        }
                      },
                    ),
                  ),
                )),
                // Error text if empty
                Obx(() => selectedCat.value.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.only(left: 12, top: 6),
                        child: Text(
                          'Please select a category',
                          style: TextStyle(
                            color:   AppColors.error,
                            fontSize: 12,
                          ),
                        ),
                      )
                    : const SizedBox.shrink()),
                const SizedBox(height: 24),

                // ─── Submit Button ───────────────────────────────────────
                SizedBox(
                  width:  double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Validate category
                      if (selectedCat.value.isEmpty) {
                        Get.snackbar(
                          'Error',
                          'Please select a category',
                          backgroundColor: Colors.red,
                          colorText:       Colors.white,
                          snackPosition:   SnackPosition.BOTTOM,
                        );
                        return;
                      }

                      if (formKey.currentState!.validate()) {
                        final data = {
                          'name':        nameCtrl.text.trim(),
                          'description': descCtrl.text.trim(),
                          'price':       priceCtrl.text.trim(),
                          'stock':       stockCtrl.text.trim(),
                          'category':    selectedCat.value,
                          'image_url':   imgCtrl.text.trim(),
                        };
                        if (product != null) {
                          data['id'] = product.id.toString();
                          _ctrl.updateProduct(data);
                        } else {
                          _ctrl.addProduct(data);
                        }
                        Future.delayed(
                          const Duration(milliseconds: 300),
                          () {
                            if (Get.isBottomSheetOpen ?? false) {
                              Get.back();
                            }
                          },
                        );
                      }
                    },
                    icon: Icon(
                      product == null
                          ? Icons.add
                          : Icons.save_outlined,
                    ),
                    label: Text(
                      product == null
                          ? 'Add Product'
                          : 'Update Product',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Manage Products'),
        leading: IconButton(
          icon:      const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        onPressed:       () => _showProductForm(context),
        icon:            const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add Product',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Obx(() {
        if (_ctrl.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (_ctrl.products.isEmpty) {
          return const Center(
            child: Text(
              'No products yet. Add one!',
              style: TextStyle(color: AppColors.grey),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _ctrl.fetchProducts,
          color:     AppColors.primary,
          child: ListView.builder(
            padding:     const EdgeInsets.all(12),
            itemCount:   _ctrl.products.length,
            itemBuilder: (_, i) {
              final p = _ctrl.products[i];
              return Container(
                margin:  const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
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
                child: Row(
                  children: [
                    // Product Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: p.imageUrl.isNotEmpty
                          ? Image.network(
                              p.imageUrl,
                              width:  65,
                              height: 65,
                              fit:    BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  _imagePlaceholder(),
                            )
                          : _imagePlaceholder(),
                    ),
                    const SizedBox(width: 12),
                    // Product Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize:   15,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Icon(
                                _categoryIcon(p.category),
                                size:  14,
                                color: AppColors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                p.category,
                                style: const TextStyle(
                                  color:   AppColors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                '₹${p.price.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  color:      AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical:   2,
                                ),
                                decoration: BoxDecoration(
                                  color: p.stock > 0
                                      ? AppColors.success
                                          .withOpacity(0.1)
                                      : AppColors.error
                                          .withOpacity(0.1),
                                  borderRadius:
                                      BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'Stock: ${p.stock}',
                                  style: TextStyle(
                                    color: p.stock > 0
                                        ? AppColors.success
                                        : AppColors.error,
                                    fontSize:   11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Edit / Delete
                    Column(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.edit_outlined,
                            color: AppColors.primary,
                          ),
                          onPressed: () =>
                              _showProductForm(context, product: p),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: AppColors.error,
                          ),
                          onPressed: () => _confirmDelete(p),
                        ),
                      ],
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
}