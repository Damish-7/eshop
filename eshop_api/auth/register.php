<?php
require_once '../config/database.php';

$data = json_decode(file_get_contents("php://input"), true);

if (!$data) {
    echo json_encode(["status" => false, "message" => "Invalid JSON input"]);
    exit();
}

$name  = trim($data['name'] ?? '');
$email = trim($data['email'] ?? '');
$pass  = trim($data['password'] ?? '');
$phone = trim($data['phone'] ?? '');

if (empty($name)) {
    echo json_encode(["status" => false, "message" => "Name is required"]);
    exit();
}

if (empty($email)) {
    echo json_encode(["status" => false, "message" => "Email is required"]);
    exit();
}

if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    echo json_encode(["status" => false, "message" => "Invalid email format"]);
    exit();
}

if (empty($pass)) {
    echo json_encode(["status" => false, "message" => "Password is required"]);
    exit();
}

if (strlen($pass) < 6) {
    echo json_encode(["status" => false, "message" => "Password must be at least 6 characters"]);
    exit();
}

$stmt = $pdo->prepare("SELECT id FROM users WHERE email = ?");
$stmt->execute([$email]);
if ($stmt->fetch()) {
    echo json_encode(["status" => false, "message" => "Email already registered"]);
    exit();
}

$hashed = md5($pass);
$stmt   = $pdo->prepare(
    "INSERT INTO users (name, email, password, phone) VALUES (?, ?, ?, ?)"
);
$stmt->execute([$name, $email, $hashed, $phone]);

if ($stmt->rowCount() > 0) {
    echo json_encode(["status" => true, "message" => "Registration successful"]);
} else {
    echo json_encode(["status" => false, "message" => "Registration failed. Try again"]);
}
?>