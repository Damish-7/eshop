<?php
require_once '../config/database.php';

$data = json_decode(file_get_contents("php://input"), true);

if (!$data) {
    echo json_encode(["status" => false, "message" => "Invalid JSON input"]);
    exit();
}

$id = intval($data['id'] ?? 0);

if ($id <= 0) {
    echo json_encode(["status" => false, "message" => "Invalid product ID"]);
    exit();
}

$stmt = $pdo->prepare("SELECT id FROM products WHERE id = ?");
$stmt->execute([$id]);
if (!$stmt->fetch()) {
    echo json_encode(["status" => false, "message" => "Product not found"]);
    exit();
}

$stmt = $pdo->prepare("DELETE FROM products WHERE id = ?");
$stmt->execute([$id]);

if ($stmt->rowCount() > 0) {
    echo json_encode([
        "status"  => true,
        "message" => "Product deleted successfully"
    ]);
} else {
    echo json_encode([
        "status"  => false,
        "message" => "Failed to delete product"
    ]);
}
?>