<?php
require_once '../config/database.php';

$data    = json_decode(file_get_contents("php://input"), true);
$id      = intval($data['id']      ?? 0);
$user_id = intval($data['user_id'] ?? 0);

if ($id <= 0 || $user_id <= 0) {
    echo json_encode(["status" => false, "message" => "Invalid ID"]);
    exit();
}

// Remove default from all addresses of user
$stmt = $pdo->prepare(
    "UPDATE addresses SET is_default = 0 WHERE user_id = ?"
);
$stmt->execute([$user_id]);

// Set new default
$stmt = $pdo->prepare(
    "UPDATE addresses SET is_default = 1 WHERE id = ? AND user_id = ?"
);
$stmt->execute([$id, $user_id]);

echo json_encode(["status" => true, "message" => "Default address updated"]);
?>