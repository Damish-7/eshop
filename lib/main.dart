
import 'package:eshop/screens/wishlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/auth_controller.dart';
import 'controllers/product_controller.dart';
import 'controllers/cart_controller.dart';
import 'controllers/admin_controller.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/admin/admin_dashboard_screen.dart';
import 'screens/admin/admin_products_screen.dart';
import 'screens/admin/admin_orders_screen.dart';
import 'utils/app_colors.dart';
import 'controllers/wishlist_controller.dart'; 
import 'controllers/address_controller.dart'; 
import 'screens/address_screen.dart';       


void main() {
  runApp(const EShopApp());
}

class EShopApp extends StatelessWidget {
  const EShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title:                    'eShop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation:       0,
          centerTitle:     false,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled:    true,
          fillColor: AppColors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:   BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:   const BorderSide(color: AppColors.lightGrey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:   const BorderSide(color: AppColors.primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:   const BorderSide(color: AppColors.error),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:   const BorderSide(color: AppColors.error, width: 2),
          ),
        ),
      ),
      initialBinding: BindingsBuilder(() {
        Get.put(AuthController());
        Get.put(ProductController());
        Get.put(CartController());
        Get.put(AdminController());
        Get.put(WishlistController());
        Get.put(AddressController()); 
        
      }),
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash',         page: () => const SplashScreen()),
        GetPage(name: '/login',          page: () => LoginScreen()),
        GetPage(name: '/register',       page: () => RegisterScreen()),
        GetPage(name: '/home',           page: () => HomeScreen()),
        GetPage(name: '/cart',           page: () => CartScreen()),
        GetPage(name: '/profile',        page: () => ProfileScreen()),
        GetPage(name: '/product-detail', page: () => ProductDetailScreen()),
        GetPage(name: '/admin',          page: () => AdminDashboardScreen()),
        GetPage(name: '/admin-products', page: () => AdminProductsScreen()),
        GetPage(name: '/admin-orders',   page: () => AdminOrdersScreen()),
        GetPage(name: '/wishlist',       page: () => WishlistScreen()),
        GetPage(name: '/addresses',      page: () => AddressScreen()),
        
      ],
    );
  }
}



//- Email: `admin@eshop.com`
//- Password: `admin123`