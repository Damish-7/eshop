class AppConstants {
  static const String baseUrl = 'http://localhost:8888/eshop_api';

  static const String register          = '$baseUrl/auth/register.php';
  static const String login             = '$baseUrl/auth/login.php';
  static const String getProducts       = '$baseUrl/products/get_products.php';
  static const String getProduct        = '$baseUrl/products/get_product.php';
  static const String addProduct        = '$baseUrl/products/add_product.php';
  static const String updateProduct     = '$baseUrl/products/update_product.php';
  static const String deleteProduct     = '$baseUrl/products/delete_product.php';
  static const String addToCart         = '$baseUrl/cart/add_to_cart.php';
  static const String getCart           = '$baseUrl/cart/get_cart.php';
  static const String updateCart        = '$baseUrl/cart/update_cart.php';
  static const String removeCart        = '$baseUrl/cart/remove_from_cart.php';
  static const String placeOrder        = '$baseUrl/orders/place_order.php';
  static const String getOrders         = '$baseUrl/orders/get_orders.php';
  static const String updateOrderStatus = '$baseUrl/orders/update_order_status.php';
  static const String cancelOrder       = '$baseUrl/orders/cancel_order.php';

  // Reviews
  static const String addReview         = '$baseUrl/reviews/add_review.php';
  static const String getReviews        = '$baseUrl/reviews/get_reviews.php';
  static const String checkReview       = '$baseUrl/reviews/check_review.php';

  // Wishlist
  static const String toggleWishlist    = '$baseUrl/wishlist/toggle_wishlist.php';
  static const String getWishlist       = '$baseUrl/wishlist/get_wishlist.php';
}