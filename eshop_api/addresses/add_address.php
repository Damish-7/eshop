<?php
require_once '../config/database.php';

$data = json_decode(file_get_contents("php://input"), true);

if (!$data) {
    echo json_encode(["status" => false, "message" => "Invalid JSON input"]);
    exit();
}

$user_id    = intval($data['user_id']   ?? 0);
$label      = trim($data['label']      ?? 'Home');
$full_name  = trim($data['full_name']  ?? '');
$phone      = trim($data['phone']      ?? '');
$address    = trim($data['address']    ?? '');
$city       = trim($data['city']       ?? '');
$state      = trim($data['state']      ?? '');
$pincode    = trim($data['pincode']    ?? '');
$is_default = intval($data['is_default'] ?? 0);

// Validation
if ($user_id <= 0) {
    echo json_encode(["status" => false, "message" => "Invalid user ID"]);
    exit();
}
if (empty($full_name)) {
    echo json_encode(["status" => false, "message" => "Full name is required"]);
    exit();
}
if (empty($phone)) {
    echo json_encode(["status" => false, "message" => "Phone is required"]);
    exit();
}
if (empty($address)) {
    echo json_encode(["status" => false, "message" => "Address is required"]);
    exit();
}
if (empty($city)) {
    echo json_encode(["status" => false, "message" => "City is required"]);
    exit();
}
if (empty($state)) {
    echo json_encode(["status" => false, "message" => "State is required"]);
    exit();
}
if (empty($pincode)) {
    echo json_encode(["status" => false, "message" => "Pincode is required"]);
    exit();
}

// Check how many addresses user has
$stmt = $pdo->prepare("SELECT COUNT(*) as count FROM addresses WHERE user_id = ?");
$stmt->execute([$user_id]);
$count = $stmt->fetch(PDO::FETCH_ASSOC)['count'];

// If first address — make it default automatically
if ($count == 0) {
    $is_default = 1;
}

// If setting as default — remove default from others
if ($is_default == 1) {
    $stmt = $pdo->prepare(
        "UPDATE addresses SET is_default = 0 WHERE user_id = ?"
    );
    $stmt->execute([$user_id]);
}

// Insert address
$stmt = $pdo->prepare(
    "INSERT INTO addresses 
        (user_id, label, full_name, phone, address, city, state, pincode, is_default)
     VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)"
);
$stmt->execute([
    $user_id, $label, $full_name, $phone,
    $address, $city, $state, $pincode, $is_default
]);

echo json_encode([
    "status"  => true,
    "message" => "Address added successfully"
]);
?>