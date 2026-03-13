<?php
require_once '../config/database.php';

$user_id = intval($_GET['user_id'] ?? 0);

if ($user_id <= 0) {
    echo json_encode(["status" => false, "message" => "Invalid user ID"]);
    exit();
}

$stmt = $pdo->prepare("
    SELECT
        c.id,
        c.quantity,
        c.user_id,
        p.id        AS product_id,
        p.name      AS name,
        p.price     AS price,
        p.image_url AS image_url,
        p.stock     AS stock,
        (c.quantity * p.price) AS total_price
    FROM cart c
    INNER JOIN products p ON c.product_id = p.id
    WHERE c.user_id = ?
    ORDER BY c.id DESC
");
$stmt->execute([$user_id]);
$cart = $stmt->fetchAll(PDO::FETCH_ASSOC);

$grandTotal = 0;
foreach ($cart as $item) {
    $grandTotal += $item['total_price'];
}

echo json_encode([
    "status"      => true,
    "cart"        => $cart,
    "item_count"  => count($cart),
    "grand_total" => $grandTotal
]);
?>