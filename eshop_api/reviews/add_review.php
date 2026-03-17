<?php
require_once '../config/database.php';

$data       = json_decode(file_get_contents("php://input"), true);

if (!$data) {
    echo json_encode(["status" => false, "message" => "Invalid JSON input"]);
    exit();
}

$user_id    = intval($data['user_id']    ?? 0);
$product_id = intval($data['product_id'] ?? 0);
$rating     = intval($data['rating']     ?? 0);
$comment    = trim($data['comment']      ?? '');

// Validation
if ($user_id <= 0) {
    echo json_encode(["status" => false, "message" => "Invalid user ID"]);
    exit();
}

if ($product_id <= 0) {
    echo json_encode(["status" => false, "message" => "Invalid product ID"]);
    exit();
}

if ($rating < 1 || $rating > 5) {
    echo json_encode(["status" => false, "message" => "Rating must be between 1 and 5"]);
    exit();
}

// Check if user already reviewed this product
$stmt = $pdo->prepare("SELECT id FROM reviews WHERE user_id = ? AND product_id = ?");
$stmt->execute([$user_id, $product_id]);

if ($stmt->fetch()) {
    // Update existing review
    $stmt = $pdo->prepare(
        "UPDATE reviews SET rating = ?, comment = ? 
         WHERE user_id = ? AND product_id = ?"
    );
    $stmt->execute([$rating, $comment, $user_id, $product_id]);
    $message = "Review updated successfully";
} else {
    // Insert new review
    $stmt = $pdo->prepare(
        "INSERT INTO reviews (user_id, product_id, rating, comment) 
         VALUES (?, ?, ?, ?)"
    );
    $stmt->execute([$user_id, $product_id, $rating, $comment]);
    $message = "Review added successfully";
}

// Update average rating and total reviews in products table
$stmt = $pdo->prepare(
    "UPDATE products SET 
        average_rating = (SELECT AVG(rating) FROM reviews WHERE product_id = ?),
        total_reviews  = (SELECT COUNT(*)    FROM reviews WHERE product_id = ?)
     WHERE id = ?"
);
$stmt->execute([$product_id, $product_id, $product_id]);

echo json_encode(["status" => true, "message" => $message]);
?>