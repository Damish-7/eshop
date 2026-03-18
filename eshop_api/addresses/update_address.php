<?php
require_once '../config/database.php';

$data = json_decode(file_get_contents("php://input"), true);

if (!$data) {
    echo json_encode(["status" => false, "message" => "Invalid JSON input"]);
    exit();
}

$id         = intval($data['id']        ?? 0);
$user_id    = intval($data['user_id']   ?? 0);
$label      = trim($data['label']      ?? 'Home');
$full_name  = trim($data['full_name']  ?? '');
$phone      = trim($data['phone']      ?? '');
$address    = trim($data['address']    ?? '');
$city       = trim($data['city']       ?? '');
$state      = trim($data['state']      ?? '');
$pincode    = trim($data['pincode']    ?? '');
$is_default = intval($data['is_default'] ?? 0);

if ($id <= 0 || $user_id <= 0) {
    echo json_encode(["status" => false, "message" => "Invalid ID"]);
    exit();
}

if (empty($full_name) || empty($phone) || empty($address) ||
    empty($city) || empty($state) || empty($pincode)) {
    echo json_encode(["status" => false, "message" => "All fields are required"]);
    exit();
}

// Check address belongs to user
$stmt = $pdo->prepare("SELECT id FROM addresses WHERE id = ? AND user_id = ?");
$stmt->execute([$id, $user_id]);
if (!$stmt->fetch()) {
    echo json_encode(["status" => false, "message" => "Address not found"]);
    exit();
}

// If setting as default — remove default from others
if ($is_default == 1) {
    $stmt = $pdo->prepare(
        "UPDATE addresses SET is_default = 0 WHERE user_id = ?"
    );
    $stmt->execute([$user_id]);
}

$stmt = $pdo->prepare(
    "UPDATE addresses
     SET label = ?, full_name = ?, phone = ?,
         address = ?, city = ?, state = ?,
         pincode = ?, is_default = ?
     WHERE id = ? AND user_id = ?"
);
$stmt->execute([
    $label, $full_name, $phone,
    $address, $city, $state,
    $pincode, $is_default, $id, $user_id
]);

echo json_encode(["status" => true, "message" => "Address updated successfully"]);
?>