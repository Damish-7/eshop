<?php
require_once '../config/database.php';

$data = json_decode(file_get_contents("php://input"), true);

if (!$data) {
    echo json_encode(["status" => false, "message" => "Invalid JSON input"]);
    exit();
}

$user_id    = intval($data['user_id'] ?? 0);
$product_id = intval($data['product_id'] ?? 0);
$quantity   = intval($data['quantity'] ?? 1);

if ($user_id <= 0) {
    echo json_encode(["status" => false, "message" => "Invalid user ID"]);
    exit();
}

if ($product_id <= 0) {
    echo json_encode(["status" => false, "message" => "Invalid product ID"]);
    exit();
}

if ($quantity <= 0) {
    echo json_encode(["status" => false, "message" => "Quantity must be at least 1"]);
    exit();
}

$stmt = $pdo->prepare("SELECT id, stock FROM products WHERE id = ?");
$stmt->execute([$product_id]);
$product = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$product) {
    echo json_encode(["status" => false, "message" => "Product not found"]);
    exit();
}

if ($product['stock'] < $quantity) {
    echo json_encode(["status" => false, "message" => "Insufficient stock"]);
    exit();
}

$stmt = $pdo->prepare(
    "SELECT id, quantity FROM cart WHERE user_id = ? AND product_id = ?"
);
$stmt->execute([$user_id, $product_id]);
$existing = $stmt->fetch(PDO::FETCH_ASSOC);

if ($existing) {
    $newQty = $existing['quantity'] + $quantity;
    $stmt   = $pdo->prepare("UPDATE cart SET quantity = ? WHERE id = ?");
    $stmt->execute([$newQty, $existing['id']]);
    echo json_encode([
        "status"  => true,
        "message" => "Cart quantity updated"
    ]);
} else {
    $stmt = $pdo->prepare(
        "INSERT INTO cart (user_id, product_id, quantity) VALUES (?, ?, ?)"
    );
    $stmt->execute([$user_id, $product_id, $quantity]);
    echo json_encode([
        "status"  => true,
        "message" => "Item added to cart successfully"
    ]);
}
?>