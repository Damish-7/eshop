<?php
require_once '../config/database.php';

$data   = json_decode(file_get_contents("php://input"), true);

if (!$data) {
    echo json_encode(["status" => false, "message" => "Invalid JSON input"]);
    exit();
}

$order_id = intval($data['order_id'] ?? 0);
$status   = trim($data['status'] ?? '');

if ($order_id <= 0) {
    echo json_encode(["status" => false, "message" => "Invalid order ID"]);
    exit();
}

$allowed = ['pending', 'processing', 'shipped', 'delivered', 'cancelled'];

if (!in_array($status, $allowed)) {
    echo json_encode(["status" => false, "message" => "Invalid status value"]);
    exit();
}

// Check order exists
$stmt = $pdo->prepare("SELECT id, status FROM orders WHERE id = ?");
$stmt->execute([$order_id]);
$order = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$order) {
    echo json_encode(["status" => false, "message" => "Order not found"]);
    exit();
}

// Update status
$stmt = $pdo->prepare("UPDATE orders SET status = ? WHERE id = ?");
$stmt->execute([$status, $order_id]);

echo json_encode([
    "status"  => true,
    "message" => "Order status updated to $status"
]);
?>