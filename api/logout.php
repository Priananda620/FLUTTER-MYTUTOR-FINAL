<?php 
session_start();
// unset ($_SESSION['username']);

// $_SESSION["username"] = $username;
// $_SESSION["userID"] = $userID;
// $_SESSION["user_phone"] = $phone;
// $_SESSION["user_email"] = $email;
// $_SESSION["user_image"] = $user_image;


session_destroy();
// if(isset($_COOKIE["user_login"])) {
//     setcookie ("user_login","");
// }

header("location:../index.php");

?>