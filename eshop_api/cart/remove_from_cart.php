<?php
require_once '../config/database.php';

$data = json_decode(file_get_contents("php://input"), true);

if (!$data) {
    echo json_encode(["status" => false, "message" => "Invalid JSON input"]);
    exit();
}

$cart_id = intval($data['cart_id'] ?? 0);

if ($cart_id <= 0) {
    echo json_encode(["status" => false, "message" => "Invalid cart ID"]);
    exit();
}

$stmt = $pdo->prepare("SELECT id FROM cart WHERE id = ?");
$stmt->execute([$cart_id]);
if (!$stmt->fetch()) {
    echo json_encode(["status" => false, "message" => "Cart item not found"]);
    exit();
}

$stmt = $pdo->prepare("DELETE FROM cart WHERE id = ?");
$stmt->execute([$cart_id]);

if ($stmt->rowCount() > 0) {
    echo json_encode([
        "status"  => true,
        "message" => "Item removed from cart successfully"
    ]);
} else {
    echo json_encode([
        "status"  => false,
        "message" => "Failed to remove item"
    ]);
}
?>