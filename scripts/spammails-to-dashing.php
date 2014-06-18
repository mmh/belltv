#!/usr/bin/php
<?php

error_reporting(E_ALL ^ E_NOTICE);

mysql_connect("localhost", "dashing", "XXXXXXX") or die(mysql_error());
mysql_select_db("amavisd") or die(mysql_error());

$result = mysql_query("
    SELECT
        msgs.subject, msgs.time_iso,
        sender.email AS sender_email,
        recip.email AS recipient
    FROM msgs
    LEFT JOIN msgrcpt ON msgs.mail_id = msgrcpt.mail_id
    LEFT JOIN maddr AS sender ON msgs.sid = sender.id
    LEFT JOIN maddr AS recip ON msgrcpt.rid = recip.id
    WHERE
        msgs.quar_type = 'Q'
         AND (sender.domain='dk.bellcom' OR recip.domain='dk.bellcom')
    ORDER BY msgs.time_num DESC
    LIMIT 10;
")
or die(mysql_error());
                                                                                                                                                                                                                                                                               
$output = "<tr><th>Time</th><th>Subject</th><th>Sender</th><th>Recipient</th></th>";                                                                                                                                                                                           
                                                                                                                                                                                                                                                                               
$row1 = mysql_fetch_array( $result );                                                                                                                                                                                                                                          
$new = $row1['time_iso'];                                                                                                                                                                                                                                                      
$file = '/tmp/spammail-dashing-last';                                                                                                                                                                                                                                          
$handle = fopen($file, 'r');                                                                                                                                                                                                                                                   
$old = fread($handle,filesize($file));                                                                                                                                                                                                                                         
$now = date('YmdHis');                                                                                                                                                                                                                                                         
                                                                                                                                                                                                                                                                               
if ( ($new > $old) || ($now - $old > 3600) ) {                                                                                                                                                                                                                                 
                                                                                                                                                                                                                                                                               
  $handle = fopen($file, 'w') or die('Cannot open file:  '.$file);                                                                                                                                                                                                             
  $data = $now;                                                                                                                                                                                                                                                                
  fwrite($handle, $data);                                                                                                                                                                                                                                                      
                                                                                                                                                                                                                                                                               
  mysql_data_seek($result, 0);                                                                                                                                                                                                                                                 
                                                                                                                                                                                                                                                                               
  while ($row = mysql_fetch_array( $result )) {                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                               
  $time = date('H:i', strtotime($row['time_iso']."+2 hours"));                                                                                                                                                                                                                 
  $subject = (mb_strlen($row['subject']) > 43) ? mb_substr($row['subject'],0,40).'...' : $row['subject'];                                                                                                                                                                      
  $sender = (mb_strlen($row['sender_email']) > 28) ? mb_substr($row['sender_email'],0,25).'...' : $row['sender_email'];                                                                                                                                                        
                                                                                                                                                                                                                                                                               
  $output .= "<tr>";                                                                                                                                                                                                                                                           
  $output .= "<td>".$time."</td>";                                                                                                                                                                                                                                             
  $output .= "<td>".$subject."</td>";                                                                                                                                                                                                                                          
  $output .= "<td>".$sender."</td>";                                                                                                                                                                                                                                           
  $output .= "<td>".$row['recipient']."</td>";                                                                                                                                                                                                                                 
  $output .= "</tr>";                                                                                                                                                                                                                                                          
  }                                                                                                                                                                                                                                                                            
                                                                                                                                                                                                                                                                               
  $output = iconv('UTF-8', 'UTF-8//IGNORE', $output);
  $output = iconv('UTF-8', 'UTF-8//TRANSLIT', $output);

  $data = array("auth_token" => "XXXXXXXXXX", "spammails" => $output);
  $data_string = json_encode($data);

  $ch = curl_init('http://belltv.bellcom.dk:3031/widgets/spammails');
  curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "POST");
  curl_setopt($ch, CURLOPT_POSTFIELDS, $data_string);
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
  curl_setopt($ch, CURLOPT_HTTPHEADER, array(
      'Content-Type: application/json',
      'Content-Length: ' . strlen($data_string))
  );

  $result = curl_exec($ch);
}

