<?php
error_reporting(E_ERROR | E_PARSE);
require_once 'db_config.php';

$connect = new mysqli($db_host,$db_username,$db_password,$db_name);


// echo "dsdasadsa";
header('Content-Type: application/json');

// $_POST['userId'] = 100;
// $_POST['subjectId'] = 13;

if(empty($_POST['userId']) || empty($_POST['subjectId']) || $connect->connect_error){
    echo json_encode(array('success' => false, 'no_data' => true));   
}else{
    $userId = (int)$_POST['userId'];
    $subjectId = (int)$_POST['subjectId'];

    if(is_int($userId) && is_int($subjectId)){
        $sql1 =  "SELECT * FROM tbl_subjects WHERE subject_id = ? LIMIT 1";

        $stmt = $connect->prepare($sql1);

        $stmt->bind_param("i", $subjectId);

        $stmt->execute();

        $result = $stmt->get_result();
        $subjectCheck = $result->fetch_assoc();

        if(!empty($subjectCheck['subject_name'])){
            // echo(json_encode(array('success' => false, 'data' => $subjectCheck['subject_name'])));
            $stmt->close();
            $connect->close();


            $connect = new mysqli($db_host,$db_username,$db_password,$db_name);

            $sql3 =  "SELECT * FROM cart WHERE subject_id = ? AND user_id = ? LIMIT 1";

            $stmt = $connect->prepare($sql3);

            $stmt->bind_param("ii", $subjectId, $userId);

            $stmt->execute();

            $result = $stmt->get_result();
            $cartCheck = $result->fetch_assoc();

            if(!empty($cartCheck['user_id']) && $cartCheck['user_id'] == $userId){
                $stmt->close();
                $connect->close();
                echo json_encode(array('success' => false, 'cart_exist' => true));
            }else{
                
                $stmt->close();
                $connect->close();

                $connect = new mysqli($db_host,$db_username,$db_password,$db_name);

                $sql2 =  "INSERT INTO `cart`(`user_id`, `subject_id`) VALUES (?,?)";
                $stmt = $connect->prepare($sql2);

                $stmt->bind_param("ii", $userId, $subjectId);
                if ($stmt->execute()) {
                    echo(json_encode(array('success' => true, 'subject_id' => $subjectCheck['subject_name'])));
                }else{
                    echo(json_encode(array('success' => false, 'subject_id' => $subjectCheck['subject_name'], 'user' => $userId)));
                }
            }
        }
        die();
    }
    echo(json_encode(array('success' => false, 'forbidden_request' => 'true')));
    
}



?>