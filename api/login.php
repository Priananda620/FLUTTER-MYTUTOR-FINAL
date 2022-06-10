<?php
require_once 'db_config.php';

$connect = new mysqli($db_host,$db_username,$db_password,$db_name);
$email = $_POST['email'];
$password = $_POST['password'];


header('Content-Type: application/json');

if(empty($email) || empty($password) || $connect->connect_error){
    echo json_encode(array('success' => false, 'no_data' => true, 'authenticated' => false));   
}else{
    $sql = "SELECT * FROM users WHERE email = '$email'";
    
    $result = $connect->query($sql);

    if($result -> num_rows > 0){
        $emailRegistered = true;
        $results = $result->fetch_all(MYSQLI_ASSOC);

        // print_r($results);

        $userData = array();

        foreach ($results as $iterate) {
            $userData['userID'] = $iterate['id'];
            $userData['username'] = $iterate['username'];
            $userData['email'] = $iterate['email'];
            $userData['phone'] = $iterate['phone'];
            $userData['user_image'] = $iterate['user_image'];
            $userData['hashPass'] = $iterate['hashed_password'];
            $userData['address'] = $iterate['address'];
        }

        if(password_verify($password, $userData['hashPass'])){
            $authenticated = true;
        }else{
            $authenticated = false;
        }
    }else{
        $emailRegistered = false;
        $authenticated = false;
    }


    if(!$emailRegistered && !$authenticated) {
        echo json_encode(array('success' => false, 'email_not_registered' => true, 'authenticated' => false)); 
    } else if($emailRegistered && !$authenticated) {
        echo json_encode(array('success' => false, 'wrong_password' => true, 'authenticated' => false));   
    }else if($emailRegistered && $authenticated) {

        session_start();
        $_SESSION["sessionId"] = session_id();

        

        $_SESSION["user_data"] = $userData;
        // $_SESSION["userID"] = $userData['userID'];
        // $_SESSION["user_phone"] = $userData['phone'];
        // $_SESSION["user_email"] = $userData['email'];
        // $_SESSION["user_image"] = $userData['user_image'];

        if(isset($_POST['remember'])) {
            $cookieData = $userData;
            unset($cookieData['hashPass']);

            //for remember me
            setcookie ("user_login", json_encode($cookieData), time() + (86400 * 30), "/");

        } else {
            if(isset($_COOKIE["user_login"])) {
                setcookie ("user_login","");
            }
        }
       
        echo json_encode(array('success' => true, 'remember' => isset($_POST['remember']), 'account_data' => array('username' => $userData['username'], 'userID' => $userData['userID'], 'user_phone' => $userData['phone'], 'user_email' => $userData['email'], 'user_image' => $userData['user_image'], 'user_address' => $userData['address']), 'authenticated' => true));
    }
    
}

?>
