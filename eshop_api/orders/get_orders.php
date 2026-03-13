<?php
require_once '../config/database.php';

$user_id = intval($_GET['user_id'] ?? 0);
$all     = isset($_GET['all']) && $_GET['all'] === '1';

if ($all) {
    $stmt = $pdo->query(
        "SELECT
            o.id,
            o.user_id,
            o.total_amount,
            o.status,
            o.address,
            o.created_at,
            u.name  AS user_name,
            u.email AS user_email,
            (SELECT COUNT(*) FROM order_items oi WHERE oi.order_id = o.id) AS item_count
         FROM orders o
         INNER JOIN users u ON o.user_id = u.id
         ORDER BY o.created_at DESC"
    );
} else {
    if ($user_id <= 0) {
        echo json_encode(["status" => false, "message" => "Invalid user ID"]);
        exit();
    }

    $stmt = $pdo->prepare(
        "SELECT
            o.id,
            o.user_id,
            o.total_amount,
            o.status,
            o.address,
            o.created_at,
            (SELECT COUNT(*) FROM order_items oi WHERE oi.order_id = o.id) AS item_count
         FROM orders o
         WHERE o.user_id = ?
         ORDER BY o.created_at DESC"
    );
    $stmt->execute([$user_id]);
}

$orders = $stmt->fetchAll(PDO::FETCH_ASSOC);

echo json_encode([
    "status"      => true,
    "order_count" => count($orders),
    "orders"      => $orders
]);
?>
