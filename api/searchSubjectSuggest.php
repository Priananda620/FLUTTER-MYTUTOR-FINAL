<?php
error_reporting(E_ERROR | E_PARSE);

require_once 'db_config.php';

$connect = new mysqli($db_host, $db_username, $db_password, $db_name);

header('Content-Type: application/json');

if (empty($_POST['string']) || $connect->connect_error) {
    echo json_encode(array('success' => false, 'no_data' => true));
} else {
    $string = "%" . strtolower(htmlspecialchars($_POST['string'], ENT_QUOTES, 'UTF-8')) . "%";

    $sql = "SELECT * FROM tbl_subjects WHERE LOWER( subject_name ) LIKE ?";
    $stmt = $connect->prepare($sql);
    $stmt->bind_param("s", $string);
    $stmt->execute();
    $query = $stmt->get_result();
    $total_data = $query->num_rows;
    $row = $query->fetch_assoc();

    $subjectFetchStore = array();

    if($total_data != 0){
        do {
            $subjectArray = array();
            $subjectArray['subject_id'] = $row['subject_id'];
            $subjectArray['subject_name'] = $row['subject_name'];
            $subjectArray['subject_description'] = $row['subject_description'];
            $subjectArray['subject_price'] = $row['subject_price'];
            $subjectArray['tutor_id'] = $row['tutor_id'];
            $subjectArray['subject_sessions'] = $row['subject_sessions'];
            $subjectArray['subject_rating'] = $row['subject_rating'];
            array_push($subjectFetchStore, $subjectArray);
        } while ($row = $query->fetch_assoc());
    }


    $dataResponse = array();
    $dataResponse['str_request'] = $string;
    $dataResponse['success'] = true;
    $dataResponse['total_result'] = $total_data;
    $dataResponse['data'] = $subjectFetchStore;

    
    echo json_encode($dataResponse); 
}

?>