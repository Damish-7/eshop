<?php
require_once '../config/database.php';

$user_id = intval($_GET['user_id'] ?? 0);

if ($user_id <= 0) {
    echo json_encode(["status" => false, "message" => "Invalid user ID"]);
    exit();
}

$stmt = $pdo->prepare(
    "SELECT * FROM addresses 
     WHERE user_id = ? 
     ORDER BY is_default DESC, created_at DESC"
);
$stmt->execute([$user_id]);
$addresses = $stmt->fetchAll(PDO::FETCH_ASSOC);

echo json_encode([
    "status"    => true,
    "addresses" => $addresses,
    "count"     => count($addresses)
]);
?>