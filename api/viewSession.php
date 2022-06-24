<?php
    session_start();
    var_dump($_SESSION);
    echo "<br>";
    echo "<br>";
    if(isset($_COOKIE["user_login"])) {
        print_r(json_decode($_COOKIE['user_login'], true));
    }

    echo md5(1);
    
?>