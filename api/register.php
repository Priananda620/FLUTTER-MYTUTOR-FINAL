<?php
error_reporting(E_ERROR | E_PARSE);

function guidv4($data = null)
{
    $data = $data ?? random_bytes(16);
    assert(strlen($data) == 16);
    $data[6] = chr(ord($data[6]) & 0x0f | 0x40);
    $data[8] = chr(ord($data[8]) & 0x3f | 0x80);
    
    return vsprintf('%s%s-%s-%s-%s-%s%s%s', str_split(bin2hex($data), 4));
}

require_once 'db_config.php';

$connect = new mysqli($db_host, $db_username, $db_password, $db_name);

header('Content-Type: application/json');

if (empty($_POST['email']) || empty($_POST['username']) || empty($_POST['phone']) || empty($_POST['password']) || empty($_POST['verify_pass']) || empty($_POST['address']) || empty($_POST['user_image64']) || $connect->connect_error) {
    echo json_encode(array('success' => false, 'no_data' => true));
} else {
    $username = addslashes($_POST['username']);
    $email = addslashes($_POST['email']);
    $phone = addslashes($_POST['phone']);
    $address = addslashes($_POST['address']);
    $user_image64 = $_POST['user_image64'];
    $password = $_POST['password'];
    $verify_pass = $_POST['verify_pass'];

    $ip = $_SERVER['REMOTE_ADDR'];

    try {
        $details = json_decode(file_get_contents("http://ipinfo.io/$ip/json"));
        $city = $details->city;
        $org = $details->org;
    }catch (Exception $e) {
        $city = null;
        $org = null;
    }


    if ($verify_pass != $password) {
        echo json_encode(array('success' => false, 'password_verify_unmatch' => true));
    } else if (!(strlen($verify_pass) >= 8)) {
        echo json_encode(array('success' => false, 'password_length_unmatch' => true));
    } else {
        // $tmp = explode('.', $photo);
        // $file_name = guidv4().'.'.end($tmp);
        $exp = explode(",", $user_image64);
        $ex = reset($exp);

        $extension = reset(explode(";", end(explode("/", $ex))));

        $file_name = guidv4() . '.' . $extension;
        $path = 'assets/user_images/' . $username . "_" . $file_name;

        $sql = "INSERT INTO `users`(`email`, `username`, `phone`, `hashed_password`, `address`, `user_image`, `ip`, `org`, `city`) VALUES (?,?,?,?,?,?,?,?,?)";

        $stmt = $connect->prepare($sql);

        if (empty($org) && empty($city)) {
            $org = null;
            $city = null;
        }

        $hashed_pass = password_hash($password, PASSWORD_DEFAULT);

        $stmt->bind_param("sssssssss", $email, $username, $phone, $hashed_pass, $address, $file_name, $ip, $org, $city);

        if ($stmt->execute()) {
            /////////////////////////////////////
            // move_uploaded_file($_FILES['picture']['tmp_name'], "../".$path);

            $base64only = str_replace(' ', '+', end($exp));
            $base64decoded = base64_decode($base64only);

            $path2write = '../' . $path;
            $is_written = file_put_contents($path2write, $base64decoded);

            // session_start();
            // $_SESSION['username'] = $username;
            echo json_encode(array('success' => true, 'account_created' => true, 'account_data' => array('username' => $username, 'email' => $email, 'phone' => $phone, 'address' => $address, 'user_image' => $user_image64)));
        } else {
            echo json_encode(array('success' => false, 'account_exist' => true));
        }
    }
}
