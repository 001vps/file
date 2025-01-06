<?
$pagestartime=microtime();//页面开始时间
function memory_usage() { 
    $memory     = ( ! function_exists('memory_get_usage')) ? '0' : round(memory_get_usage()/1024/1024, 2).'MB'; 
    return $memory; 
}
function rs($k)
{
    $ch = curl_init();
curl_setopt($ch, CURLOPT_URL, 'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=AIzaSyBjEkK60sUaZZLHxZTeaVsK94gZH6mkPCQ');
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_CUSTOMREQUEST, 'POST');
curl_setopt($ch, CURLOPT_HTTPHEADER, array('Content-Type: application/json'));
//$k = urlencode ( $k );
curl_setopt($ch, CURLOPT_POSTFIELDS, "{\"contents\":[{\"parts\":[{\"text\":\" $k\"}]}]}");

$response = curl_exec($ch);

curl_close($ch);
//print_r($response);
return $response;
    
}
?>
<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta charset="utf-8"/>
    <title>AI查询</title>
    <link href="/bootstrap-combined.min.css" rel="stylesheet" type="text/css">
    <style>
        #editor {
            width: 100%;
            height: 50px;
        }
    </style>
</head>
<body>
<div id='content' class='row-fluid'>
<div class='span12'>
    <form method="post" action="<?php echo $_SERVER['PHP_SELF']; ?>">
        <textarea id="editor" name="code"><?php echo isset($_POST['code']) ? $_POST['code'] : ''; ?></textarea>
        <br>
        <input type="submit" value="AI查询">
    </form>

    <?php
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        $k = $_POST['code'];
       $r= rs($k);
       //print_r($r);
        $r= json_decode ( $r ,  true );
        //echo "<hr>";
        //print_r($r);
       $text = $r['candidates'][0]['content']['parts'][0]['text'];

        echo "<p>".$k."</p><p>".$text."</p>";
    }
    ?>
<?php
$pageendtime = microtime();
$starttime = explode(" ",$pagestartime);
$endtime = explode(" ",$pageendtime);
$totaltime = $endtime[0]-$starttime[0]+$endtime[1]-$starttime[1];
$timecost = sprintf("%s",$totaltime);
$timecost = substr($timecost,0,5);
?>
<p><?php echo " 消耗:".$timecost."秒"; echo "  内存".memory_usage();?> </p>
</div>
</div>
</body>
</html>