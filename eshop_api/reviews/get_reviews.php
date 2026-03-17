<?php
require_once '../config/database.php';

$product_id = intval($_GET['product_id'] ?? 0);

if ($product_id <= 0) {
    echo json_encode(["status" => false, "message" => "Invalid product ID"]);
    exit();
}

// Get all reviews for a product with user name
$stmt = $pdo->prepare("
    SELECT 
        r.id,
        r.rating,
        r.comment,
        r.created_at,
        u.name AS user_name
    FROM reviews r
    INNER JOIN users u ON r.user_id = u.id
    WHERE r.product_id = ?
    ORDER BY r.created_at DESC
");
$stmt->execute([$product_id]);
$reviews = $stmt->fetchAll(PDO::FETCH_ASSOC);

// Get average rating
$stmt = $pdo->prepare(
    "SELECT AVG(rating) as average, COUNT(*) as total 
     FROM reviews WHERE product_id = ?"
);
$stmt->execute([$product_id]);
$stats = $stmt->fetch(PDO::FETCH_ASSOC);

echo json_encode([
    "status"         => true,
    "reviews"        => $reviews,
    "average_rating" => round(floatval($stats['average']), 1),
    "total_reviews"  => intval($stats['total'])
]);
?>