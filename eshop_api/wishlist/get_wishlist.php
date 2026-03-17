<?php
require_once '../config/database.php';

$user_id = intval($_GET['user_id'] ?? 0);

if ($user_id <= 0) {
    echo json_encode(["status" => false, "message" => "Invalid user ID"]);
    exit();
}

$stmt = $pdo->prepare("
    SELECT 
        w.id         AS wishlist_id,
        p.id         AS product_id,
        p.name,
        p.price,
        p.image_url,
        p.category,
        p.stock,
        p.average_rating,
        p.total_reviews
    FROM wishlist w
    INNER JOIN products p ON w.product_id = p.id
    WHERE w.user_id = ?
    ORDER BY w.created_at DESC
");
$stmt->execute([$user_id]);
$wishlist = $stmt->fetchAll(PDO::FETCH_ASSOC);

echo json_encode([
    "status"   => true,
    "wishlist" => $wishlist,
    "count"    => count($wishlist)
]);
?>