<?php
require_once '../config/database.php';

$category = trim($_GET['category'] ?? '');
$search   = trim($_GET['search'] ?? '');

$sql    = "SELECT * FROM products WHERE 1=1";
$params = [];

if (!empty($category)) {
    $sql     .= " AND category = ?";
    $params[] = $category;
}

if (!empty($search)) {
    $sql     .= " AND name LIKE ?";
    $params[] = "%" . $search . "%";
}

$sql .= " ORDER BY created_at DESC";

$stmt = $pdo->prepare($sql);
$stmt->execute($params);
$products = $stmt->fetchAll(PDO::FETCH_ASSOC);

if ($products) {
    echo json_encode([
        "status"   => true,
        "count"    => count($products),
        "products" => $products
    ]);
} else {
    echo json_encode([
        "status"   => true,
        "count"    => 0,
        "products" => [],
        "message"  => "No products found"
    ]);
}
?>