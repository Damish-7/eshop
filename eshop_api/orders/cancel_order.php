<?php
require_once '../config/database.php';

$data = json_decode(file_get_contents("php://input"), true);

if (!$data) {
    echo json_encode(["status" => false, "message" => "Invalid JSON input"]);
    exit();
}

$order_id = intval($data['order_id'] ?? 0);
$user_id  = intval($data['user_id'] ?? 0);

if ($order_id <= 0) {
    echo json_encode(["status" => false, "message" => "Invalid order ID"]);
    exit();
}

if ($user_id <= 0) {
    echo json_encode(["status" => false, "message" => "Invalid user ID"]);
    exit();
}

// Check order exists and belongs to user
$stmt = $pdo->prepare("SELECT id, status FROM orders WHERE id = ? AND user_id = ?");
$stmt->execute([$order_id, $user_id]);
$order = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$order) {
    echo json_encode(["status" => false, "message" => "Order not found"]);
    exit();
}

// Only pending or processing orders can be cancelled
if (!in_array($order['status'], ['pending', 'processing'])) {
    echo json_encode([
        "status"  => false,
        "message" => "Order cannot be cancelled. It is already {$order['status']}"
    ]);
    exit();
}

// Cancel order
$stmt = $pdo->prepare("UPDATE orders SET status = 'cancelled' WHERE id = ?");
$stmt->execute([$order_id]);

// Restore product stock
$stmt = $pdo->prepare("SELECT product_id, quantity FROM order_items WHERE order_id = ?");
$stmt->execute([$order_id]);
$items = $stmt->fetchAll(PDO::FETCH_ASSOC);

foreach ($items as $item) {
    $stmt = $pdo->prepare(
        "UPDATE products SET stock = stock + ? WHERE id = ?"
    );
    $stmt->execute([$item['quantity'], $item['product_id']]);
}

echo json_encode([
    "status"  => true,
    "message" => "Order cancelled successfully. Stock has been restored."
]);
?>