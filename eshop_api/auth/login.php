<?php
require_once '../config/database.php';

$data = json_decode(file_get_contents("php://input"), true);

if (!$data) {
    echo json_encode(["status" => false, "message" => "Invalid JSON input"]);
    exit();
}

$email    = trim($data['email'] ?? '');
$password = trim($data['password'] ?? '');

if (empty($email)) {
    echo json_encode(["status" => false, "message" => "Email is required"]);
    exit();
}

if (empty($password)) {
    echo json_encode(["status" => false, "message" => "Password is required"]);
    exit();
}

if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    echo json_encode(["status" => false, "message" => "Invalid email format"]);
    exit();
}

$hashed = md5($password);

$stmt = $pdo->prepare("SELECT * FROM users WHERE email = ? AND password = ?");
$stmt->execute([$email, $hashed]);
$user = $stmt->fetch(PDO::FETCH_ASSOC);

if ($user) {
    unset($user['password']);
    echo json_encode([
        "status"  => true,
        "message" => "Login successful",
        "user"    => $user
    ]);
} else {
    echo json_encode([
        "status"  => false,
        "message" => "Invalid email or password"
    ]);
}
?>