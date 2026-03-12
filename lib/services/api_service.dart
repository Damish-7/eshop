import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/app_constants.dart';

class ApiService {

  // ─── Generic POST ───────────────────────────────────────────────────────────
  static Future<Map<String, dynamic>> post(
    String url,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 15));
      return jsonDecode(response.body);
    } catch (e) {
      return {"status": false, "message": "Connection error: $e"};
    }
  }

  // ─── Generic GET ────────────────────────────────────────────────────────────
  static Future<Map<String, dynamic>> get(
    String url, {
    Map<String, String>? params,
  }) async {
    try {
      final uri = Uri.parse(url).replace(queryParameters: params);
      final response = await http
          .get(uri)
          .timeout(const Duration(seconds: 15));
      return jsonDecode(response.body);
    } catch (e) {
      return {"status": false, "message": "Connection error: $e"};
    }
  }

  // ─── AUTH ────────────────────────────────────────────────────────────────────
  static Future<Map<String, dynamic>> register(
      Map<String, dynamic> data) async {
    return await post(AppConstants.register, data);
  }

  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    return await post(AppConstants.login, {
      'email':    email,
      'password': password,
    });
  }

  // ─── PRODUCTS ────────────────────────────────────────────────────────────────
  static Future<Map<String, dynamic>> getProducts({
    String? category,
    String? search,
  }) async {
    return await get(AppConstants.getProducts, params: {
      if (category != null && category.isNotEmpty) 'category': category,
      if (search != null && search.isNotEmpty) 'search': search,
    });
  }

  static Future<Map<String, dynamic>> getProduct(int id) async {
    return await get(AppConstants.getProduct, params: {
      'id': id.toString(),
    });
  }

  static Future<Map<String, dynamic>> addProduct(
      Map<String, dynamic> data) async {
    return await post(AppConstants.addProduct, data);
  }

  static Future<Map<String, dynamic>> updateProduct(
      Map<String, dynamic> data) async {
    return await post(AppConstants.updateProduct, data);
  }

  static Future<Map<String, dynamic>> deleteProduct(int id) async {
    return await post(AppConstants.deleteProduct, {'id': id});
  }

  // ─── CART ────────────────────────────────────────────────────────────────────
  static Future<Map<String, dynamic>> addToCart(
      int userId, int productId, int quantity) async {
    return await post(AppConstants.addToCart, {
      'user_id':    userId,
      'product_id': productId,
      'quantity':   quantity,
    });
  }

  static Future<Map<String, dynamic>> getCart(int userId) async {
    return await get(AppConstants.getCart, params: {
      'user_id': userId.toString(),
    });
  }

  static Future<Map<String, dynamic>> updateCart(
      int cartId, int quantity) async {
    return await post(AppConstants.updateCart, {
      'cart_id':  cartId,
      'quantity': quantity,
    });
  }

  static Future<Map<String, dynamic>> removeFromCart(int cartId) async {
    return await post(AppConstants.removeCart, {'cart_id': cartId});
  }

  // ─── ORDERS ──────────────────────────────────────────────────────────────────
  static Future<Map<String, dynamic>> placeOrder(
      Map<String, dynamic> data) async {
    return await post(AppConstants.placeOrder, data);
  }

  static Future<Map<String, dynamic>> getOrders(int userId) async {
    return await get(AppConstants.getOrders, params: {
      'user_id': userId.toString(),
    });
  }

  static Future<Map<String, dynamic>> getAllOrders() async {
    return await get(AppConstants.getOrders, params: {'all': '1'});
  }

  // Update Order Status
static Future<Map<String, dynamic>> updateOrderStatus(
    int orderId, String status) async {
  return await post(AppConstants.updateOrderStatus, {
    'order_id': orderId,
    'status':   status,
  });
}


// Cancel Order
static Future<Map<String, dynamic>> cancelOrder(
    int orderId, int userId) async {
  return await post(AppConstants.cancelOrder, {
    'order_id': orderId,
    'user_id':  userId,
  });
}
}