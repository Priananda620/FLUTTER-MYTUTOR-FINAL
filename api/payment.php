<?php

// $email = $_GET['email'];
// $mobile = $_GET['mobile']; 

$email = "prianandaazhar2001@gmail.com";
$mobile = "01234567895"; 
$name = $_GET['name']; 
$amount = $_GET['amount']; 
$userId = $_GET['userId']; 


$api_key = '75923fb5-eda7-4454-adff-a7db1fa3115f';
$collection_id = 'ncwa3tdt';
 
$host = 'https://www.billplz-sandbox.com/api/v3/bills';


$data = array(
          'collection_id' => $collection_id,
          'email' => $email,
          'mobile' => $mobile,
          'name' => $name,
          'amount' => ($amount + 1) * 100, // RM20
		  'description' => 'Payment for order by '.$name,
          'callback_url' => "https://azharpriananda.000webhostapp.com/api/return_url",
          'redirect_url' => "https://azharpriananda.000webhostapp.com/api/payment_update.php?email=$email&mobile=$mobile&amount=$amount&name=$name&userId=$userId"
);


$process = curl_init($host );
curl_setopt($process, CURLOPT_HEADER, 0);
curl_setopt($process, CURLOPT_USERPWD, $api_key . ":");
curl_setopt($process, CURLOPT_TIMEOUT, 30);
curl_setopt($process, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($process, CURLOPT_SSL_VERIFYHOST, 0);
curl_setopt($process, CURLOPT_SSL_VERIFYPEER, 0);
curl_setopt($process, CURLOPT_POSTFIELDS, http_build_query($data) ); 

$return = curl_exec($process);
curl_close($process);

$bill = json_decode($return, true);
header("Location: {$bill['url']}");
?>