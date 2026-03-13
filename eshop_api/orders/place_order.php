<?php
require_once '../config/database.php';

$data = json_decode(file_get_contents("php://input"), true);

if (!$data) {
    echo json_encode(["status" => false, "message" => "Invalid JSON input"]);
    exit();
}

$user_id = intval($data['user_id'] ?? 0);
$address = trim($data['address'] ?? '');
$items   = $data['items'] ?? [];
$total   = floatval($data['total'] ?? 0);

if ($user_id <= 0) {
    echo json_encode(["status" => false, "message" => "Invalid user ID"]);
    exit();
}

if (empty($address)) {
    echo json_encode(["status" => false, "message" => "Delivery address is required"]);
    exit();
}

if (empty($items)) {
    echo json_encode(["status" => false, "message" => "Order items are required"]);
    exit();
}

if ($total <= 0) {
    echo json_encode(["status" => false, "message" => "Invalid order total"]);
    exit();
}

$stmt = $pdo->prepare("SELECT id FROM users WHERE id = ?");
$stmt->execute([$user_id]);
if (!$stmt->fetch()) {
    echo json_encode(["status" => false, "message" => "User not found"]);
    exit();
}

$pdo->beginTransaction();

try {
    $stmt = $pdo->prepare(
        "INSERT INTO orders (user_id, total_amount, address, status)
         VALUES (?, ?, ?, 'pending')"
    );
    $stmt->execute([$user_id, $total, $address]);
    $order_id = $pdo->lastInsertId();

    foreach ($items as $item) {
        $p_id  = intval($item['product_id'] ?? 0);
        $qty   = intval($item['quantity'] ?? 1);
        $price = floatval($item['price'] ?? 0);

        if ($p_id <= 0 || $qty <= 0 || $price <= 0) {
            throw new Exception("Invalid order item data");
        }

        $stmt = $pdo->prepare(
            "INSERT INTO order_items (order_id, product_id, quantity, price)
             VALUES (?, ?, ?, ?)"
        );
        $stmt->execute([$order_id, $p_id, $qty, $price]);

        $stmt = $pdo->prepare(
            "UPDATE products SET stock = stock - ? WHERE id = ? AND stock >= ?"
        );
        $stmt->execute([$qty, $p_id, $qty]);

        if ($stmt->rowCount() === 0) {
            throw new Exception("Insufficient stock for product ID: $p_id");
        }
    }

    $stmt = $pdo->prepare("DELETE FROM cart WHERE user_id = ?");
    $stmt->execute([$user_id]);

    $pdo->commit();

    echo json_encode([
        "status"   => true,
        "message"  => "Order placed successfully",
        "order_id" => $order_id
    ]);

} catch (Exception $e) {
    $pdo->rollBack();
    echo json_encode([
        "status"  => false,
        "message" => "Order failed: " . $e->getMessage()
    ]);
}
?>