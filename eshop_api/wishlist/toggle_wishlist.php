<?php
require_once '../config/database.php';

$data = json_decode(file_get_contents("php://input"), true);

if (!$data) {
    echo json_encode(["status" => false, "message" => "Invalid JSON input"]);
    exit();
}

$user_id    = intval($data['user_id']    ?? 0);
$product_id = intval($data['product_id'] ?? 0);

if ($user_id <= 0 || $product_id <= 0) {
    echo json_encode(["status" => false, "message" => "Invalid input"]);
    exit();
}

// Check if already in wishlist
$stmt = $pdo->prepare(
    "SELECT id FROM wishlist WHERE user_id = ? AND product_id = ?"
);
$stmt->execute([$user_id, $product_id]);
$existing = $stmt->fetch(PDO::FETCH_ASSOC);

if ($existing) {
    // Remove from wishlist
    $stmt = $pdo->prepare("DELETE FROM wishlist WHERE id = ?");
    $stmt->execute([$existing['id']]);
    echo json_encode([
        "status"      => true,
        "wishlisted"  => false,
        "message"     => "Removed from wishlist"
    ]);
} else {
    // Add to wishlist
    $stmt = $pdo->prepare(
        "INSERT INTO wishlist (user_id, product_id) VALUES (?, ?)"
    );
    $stmt->execute([$user_id, $product_id]);
    echo json_encode([
        "status"     => true,
        "wishlisted" => true,
        "message"    => "Added to wishlist"
    ]);
}
?>