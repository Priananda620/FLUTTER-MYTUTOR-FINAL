<?php
// error_reporting(E_ERROR | E_PARSE);
require_once 'db_config.php';

$connect = new mysqli($db_host, $db_username, $db_password, $db_name);


header('Content-Type: application/json');

// $_POST['userId'] = 100;

if (empty($_POST['userId']) || $connect->connect_error) {
    echo json_encode(array('success' => false, 'no_data' => true));
} else {
    $userId = (int)$_POST['userId'];

    if (is_int($userId)) {
        $sql = "DELETE FROM cart WHERE user_id = ?";


        $stmt = $connect->prepare($sql);

        $stmt->bind_param("i", $userId);

        if ($stmt->execute()) {
            echo (json_encode(array('success' => true, 'user_id' => $userId)));
        } else {
            echo (json_encode(array('success' => false, 'user_id' => $userId)));
        }
    }
}
