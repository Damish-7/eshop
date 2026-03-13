<?php
require_once '../config/database.php';

$data = json_decode(file_get_contents("php://input"), true);

if (!$data) {
    echo json_encode(["status" => false, "message" => "Invalid JSON input"]);
    exit();
}

$id          = intval($data['id'] ?? 0);
$name        = trim($data['name'] ?? '');
$description = trim($data['description'] ?? '');
$price       = floatval($data['price'] ?? 0);
$stock       = intval($data['stock'] ?? 0);
$category    = trim($data['category'] ?? '');
$image_url   = trim($data['image_url'] ?? '');

if ($id <= 0) {
    echo json_encode(["status" => false, "message" => "Invalid product ID"]);
    exit();
}

if (empty($name)) {
    echo json_encode(["status" => false, "message" => "Product name is required"]);
    exit();
}

if ($price <= 0) {
    echo json_encode(["status" => false, "message" => "Valid price is required"]);
    exit();
}

if ($stock < 0) {
    echo json_encode(["status" => false, "message" => "Stock cannot be negative"]);
    exit();
}

if (empty($category)) {
    echo json_encode(["status" => false, "message" => "Category is required"]);
    exit();
}

$stmt = $pdo->prepare("SELECT id FROM products WHERE id = ?");
$stmt->execute([$id]);
if (!$stmt->fetch()) {
    echo json_encode(["status" => false, "message" => "Product not found"]);
    exit();
}

$stmt = $pdo->prepare(
    "UPDATE products
     SET name        = ?,
         description = ?,
         price       = ?,
         stock       = ?,
         category    = ?,
         image_url   = ?
     WHERE id = ?"
);
$stmt->execute([$name, $description, $price, $stock, $category, $image_url, $id]);

echo json_encode([
    "status"  => true,
    "message" => "Product updated successfully"
]);
?>