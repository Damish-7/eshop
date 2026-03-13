<?php
require_once '../config/database.php';

$id = intval($_GET['id'] ?? 0);

if ($id <= 0) {
    echo json_encode([
        "status"  => false,
        "message" => "Invalid product ID"
    ]);
    exit();
}

$stmt = $pdo->prepare("SELECT * FROM products WHERE id = ?");
$stmt->execute([$id]);
$product = $stmt->fetch(PDO::FETCH_ASSOC);

if ($product) {
    echo json_encode([
        "status"  => true,
        "product" => $product
    ]);
} else {
    echo json_encode([
        "status"  => false,
        "message" => "Product not found"
    ]);
}
?>