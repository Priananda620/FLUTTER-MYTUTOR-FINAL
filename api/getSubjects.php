<?php
    require_once 'db_config.php';
    $sqlcnt = new mysqli($db_host, $db_username, $db_password, $db_name);

    $view = 5;

    if (isset($_GET['page'])) {
        $active_page = (int)$_GET['page'];
    }else if(isset($_POST['page'])){
        $active_page = (int)$_POST['page'];
    } else {
        $active_page = 1;
    }

    $start = ($active_page - 1) * $view;
    $limit = " LIMIT $start, $view";

    if(isset($_POST['searchstr']) && $_POST['searchstr'] != ""){
        $searchStr = $_POST['searchstr'];
        $string = "%" . strtolower(htmlspecialchars(addslashes($searchStr), ENT_QUOTES, 'UTF-8')) . "%";


        $sql = "SELECT * FROM tbl_subjects WHERE LOWER( subject_name ) LIKE ? ".$limit;
        $stmt = $sqlcnt->prepare($sql);
        $stmt->bind_param("s", $string);
        $stmt->execute();
        $query = $stmt->get_result();
        $total_data = $query->num_rows;
    }else{
        $sql = "SELECT * FROM tbl_subjects";
        $query = $sqlcnt->query($sql . $limit);
        $total_data = $query->num_rows;
    }



    $row = $query->fetch_assoc();

    $subjectFetchStore = array();

    if($total_data != 0){
        do {
            $subjectArray = array();
            $subjectArray['subject_id'] = (string)$row['subject_id'];
            $subjectArray['subject_name'] = (string)$row['subject_name'];
            $subjectArray['subject_description'] = (string)$row['subject_description'];
            $subjectArray['subject_price'] = (string)$row['subject_price'];
            $subjectArray['tutor_id'] = (string)$row['tutor_id'];
            $subjectArray['subject_sessions'] = (string)$row['subject_sessions'];
            $subjectArray['subject_rating'] = (string)$row['subject_rating'];
            array_push($subjectFetchStore, $subjectArray);
        } while ($row = $query->fetch_assoc());
    }
    
    if(isset($searchStr)){

        $string = "%" . strtolower(htmlspecialchars(addslashes($searchStr), ENT_QUOTES, 'UTF-8')) . "%";

        $sql2 = "SELECT * FROM tbl_subjects WHERE LOWER( subject_name ) LIKE ?";
        $stmtTotal = $sqlcnt->prepare($sql2);
        $stmtTotal->bind_param("s", $string);
        $stmtTotal->execute();
        $queryTotal = $stmtTotal->get_result();
        $total_data = $queryTotal->num_rows;
    }else{
        $sql2 = "SELECT * FROM tbl_subjects";
        $query = $sqlcnt->query($sql2);
        $total_data = $query->num_rows;
    }

    // echo "<h1>".$total_data."</h1>";
    $total_page = ceil($total_data / $view);

    $dataResponse = array();
    $dataResponse['success'] = true;
    $dataResponse['data_per_page'] = $view;
    $dataResponse['total_page'] = $total_page;
    if(isset($searchStr)){
        $dataResponse['search'] = $searchStr;
    }
    $dataResponse['total_data'] = $total_data;
    $dataResponse['active_page'] = $active_page;
    $dataResponse['data'] = $subjectFetchStore;

    header('Content-Type: application/json');

    echo json_encode($dataResponse); 
?>