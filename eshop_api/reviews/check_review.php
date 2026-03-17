<?php
require_once '../config/database.php';

$user_id    = intval($_GET['user_id']    ?? 0);
$product_id = intval($_GET['product_id'] ?? 0);

if ($user_id <= 0 || $product_id <= 0) {
    echo json_encode(["status" => false, "message" => "Invalid input"]);
    exit();
}

// Check if user already reviewed this product
$stmt = $pdo->prepare(
    "SELECT * FROM reviews WHERE user_id = ? AND product_id = ?"
);
$stmt->execute([$user_id, $product_id]);
$review = $stmt->fetch(PDO::FETCH_ASSOC);

if ($review) {
    echo json_encode([
        "status"  => true,
        "reviewed" => true,
        "review"   => $review
    ]);
} else {
    echo json_encode([
        "status"   => true,
        "reviewed" => false
    ]);
}
?>