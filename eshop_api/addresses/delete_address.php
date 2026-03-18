<?php
require_once '../config/database.php';

$data    = json_decode(file_get_contents("php://input"), true);
$id      = intval($data['id']      ?? 0);
$user_id = intval($data['user_id'] ?? 0);

if ($id <= 0 || $user_id <= 0) {
    echo json_encode(["status" => false, "message" => "Invalid ID"]);
    exit();
}

// Check address belongs to user
$stmt = $pdo->prepare(
    "SELECT id, is_default FROM addresses WHERE id = ? AND user_id = ?"
);
$stmt->execute([$id, $user_id]);
$address = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$address) {
    echo json_encode(["status" => false, "message" => "Address not found"]);
    exit();
}

// Delete address
$stmt = $pdo->prepare("DELETE FROM addresses WHERE id = ?");
$stmt->execute([$id]);

// If deleted address was default — make first remaining address default
if ($address['is_default'] == 1) {
    $stmt = $pdo->prepare(
        "UPDATE addresses SET is_default = 1 
         WHERE user_id = ? 
         ORDER BY created_at ASC 
         LIMIT 1"
    );
    $stmt->execute([$user_id]);
}

echo json_encode(["status" => true, "message" => "Address deleted successfully"]);
?>