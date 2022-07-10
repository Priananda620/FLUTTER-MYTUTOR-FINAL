<?php
// error_reporting(E_ERROR | E_PARSE);
require_once 'db_config.php';

$connect = new mysqli($db_host,$db_username,$db_password,$db_name);


header('Content-Type: application/json');

// $_POST['userId'] = 100;

if(empty($_POST['userId']) || $connect->connect_error){
    echo json_encode(array('success' => false, 'no_data' => true));   
}else{
    $userId = (int)$_POST['userId'];

    if(is_int($userId)){
        $sql = "SELECT
            *,
            tbl_subjects.subject_id AS 'subjectId'
            FROM
                tbl_subjects
            INNER JOIN cart ON tbl_subjects.subject_id = cart.subject_id
            WHERE cart.user_id = ?";


        $stmt = $connect->prepare($sql);

        $stmt->bind_param("i", $userId);

        $stmt->execute();

        $result = $stmt->get_result();

        $row = $result->fetch_assoc();
        $payable = 0;

        if(!empty($row['user_id']) && $row['user_id'] == $userId){
            $subjectFetchStore = array();

            do {
                $subjectArray = array();
                $subjectArray['subject_id'] = (string)$row['subjectId'];
                $subjectArray['subject_name'] = (string)$row['subject_name'];
                $subjectArray['subject_description'] = (string)$row['subject_description'];
                $subjectArray['subject_price'] = (string)$row['subject_price'];
                $payable += (int)$row['subject_price'];
                $subjectArray['tutor_id'] = (string)$row['tutor_id'];
                $subjectArray['subject_sessions'] = (string)$row['subject_sessions'];
                $subjectArray['subject_rating'] = (string)$row['subject_rating'];
                $subjectArray['cartIsExist'] = (string)"1";
                array_push($subjectFetchStore, $subjectArray);
                // print_r($subjectArray);
            } while ($row = $result->fetch_assoc());

            $dataResponse = array();
            $dataResponse['success'] = true;
            $dataResponse['total_payable'] = $payable;
            $dataResponse['total_data'] = count($subjectFetchStore);
            $dataResponse['data'] = $subjectFetchStore;
            // echo("aaaa");
            echo json_encode($dataResponse);

        }else{
            // echo("bbbb");
            echo(json_encode(array('success' => false, 'cartIsEmpty' => 'true')));
        }
    }

}
