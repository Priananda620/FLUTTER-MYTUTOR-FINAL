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

    $sql = "SELECT * FROM tbl_tutors";

    $query = $sqlcnt->query($sql . $limit);
    $row = $query->fetch_assoc();

    $tutorFetchStore = array();

    do {
        $tutorArray = array();
        $tutorArray['tutor_id'] = $row['tutor_id'];
        $tutorArray['tutor_email'] = $row['tutor_email'];
        $tutorArray['tutor_phone'] = $row['tutor_phone'];
        $tutorArray['tutor_name'] = $row['tutor_name'];
        $tutorArray['tutor_password'] = $row['tutor_password'];
        $tutorArray['tutor_description'] = $row['tutor_description'];
        $tutorArray['tutor_datereg'] = $row['tutor_datereg'];
        array_push($tutorFetchStore, $tutorArray);
    } while ($row = $query->fetch_assoc());

    


    $sqltotal = $sql;
    $qtotal = $sqlcnt->query($sqltotal);
    $total_data = $qtotal->num_rows;
    // echo "<h1>".$total_data."</h1>";
    $total_page = ceil($total_data / $view);

    $dataResponse = array();
    $dataResponse['success'] = true;
    $dataResponse['data_per_page'] = $view;
    $dataResponse['total_page'] = $total_page;
    $dataResponse['total_data'] = $total_data;
    $dataResponse['active_page'] = $active_page;
    $dataResponse['data'] = $tutorFetchStore;

    header('Content-Type: application/json');

    echo json_encode($dataResponse); 
?>