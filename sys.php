<?php

function formatBytes($bytes, $precision = 2) {
    $units = array('KB', 'MB', 'GB', 'TB');
    $bytes = max($bytes, 0);
    $pow = floor(($bytes ? log($bytes) : 0) / log(1024));
    $pow = min($pow, count($units) - 1);
    $bytes /= (1 << (10 * $pow));
    return round($bytes, $precision) . ' ' . $units[$pow];
}

// 自定义函数，获取系统信息
function getSystemInfo() {
    // 获取服务器当前时间
    $current_time = date("Y-m-d H:i:s");

    // 获取服务器已运行时间
    $uptime = file_get_contents('/proc/uptime');
    $uptime_seconds = (float)explode(' ', trim($uptime))[0]; // 只取第一个数字

    // 计算天、小时、分钟和秒
    $days = floor($uptime_seconds / 86400);
    $hours = floor(($uptime_seconds % 86400) / 3600);
    $minutes = floor(($uptime_seconds % 3600) / 60);
    $seconds = $uptime_seconds % 60;

    // 格式化输出
    $uptime = sprintf("%d天 %d小时 %d分钟 %d秒", $days, $hours, $minutes, $seconds);

    // 获取内存大小
    $memory_info = file_get_contents('/proc/meminfo');
    preg_match('/MemTotal:\s+(\d+)/', $memory_info, $matches);
    $total_memory = isset($matches[1]) ? $matches[1] : '';

    // 获取已用内存
    preg_match('/MemAvailable:\s+(\d+)/', $memory_info, $matches);
    $available_memory = isset($matches[1]) ? $matches[1] : '';

    // 计算已用内存
    $used_memory = $total_memory - $available_memory;

    // 格式化输出内存大小、已用内存和剩余内存
    $total_memory_formatted = formatBytes($total_memory);
    $used_memory_formatted = formatBytes($used_memory);
    $available_memory_formatted = formatBytes($available_memory);

    // 获取系统平均负载
    $load_average = sys_getloadavg();
    $load_average = implode(", ", $load_average);

    // 获取硬盘使用状况
    $total_space = disk_total_space('/');
    $used_space = disk_total_space('/') - disk_free_space('/');
    $disk_usage = round(($used_space / $total_space) * 100, 2);

    // 构建系统信息数组
    $system_info = array(
        '服务器当前时间' => $current_time,
        '服务器已运行时间' => $uptime,
        '内存大小' => $total_memory_formatted,
        '已用内存' => $used_memory_formatted,
        '可用内存' => $available_memory_formatted,
        '系统平均负载' => $load_average,
        '硬盘使用状况' => $disk_usage . '%'
    );

    return $system_info;
}

if($_GET['s']=="json") {
    $system_info = getSystemInfo();
    header('Content-Type: application/json');
    echo json_encode($system_info);
    exit;
}

?>
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>System Info</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>

        body {
            font-family: Arial, sans-serif;
            background-color: #f4f7fc;
            color: #333;
            margin: 0;
            padding: 0;
        }
        h1 {
            text-align: center;
            color: #4CAF50;
            margin-top: 20px;
        }
        .container {
            width: 90%;
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        .info-item {
            background-color: #fff;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 15px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }
        .info-item span {
            display: inline-block;
            margin-right: 15px;
            font-size: 16px;
        }
        @media (max-width: 768px) {
            .container {
                padding: 10px;
            }
            .info-item {
                padding: 12px;
            }
            h1 {
                font-size: 24px;
            }
        }
    </style>
    <script>
       $(document).ready(function() {
            setInterval(function() {
                $.ajax({
                    url: '<?php echo $_SERVER['PHP_SELF']; ?>?s=json', 
                    dataType: 'json',
                    success: function(data) {
                        $('#current_time').html('<strong>服务器当前时间:</strong> ' + data['服务器当前时间']);
                        $('#uptime').html('<strong>已运行时间:</strong> ' + data['服务器已运行时间']);
                        $('#total_memory').html('<strong>内存:</strong> ' + data['内存大小']);
                        $('#used_memory').html('<strong>已用:</strong> ' + data['已用内存']);
                        $('#available_memory').html('<strong>可用:</strong> ' + data['可用内存']);
                        $('#load_average').html('<strong>系统平均负载:</strong> ' + data['系统平均负载']);
                        $('#disk_usage').html('<strong>硬盘使用状况:</strong> ' + data['硬盘使用状况']);
                    }
                });
            }, 1000); // 每秒钟执行一次Ajax请求
        });
    </script>
</head>
<body>
    <div class="container">
        <h1>服务器信息</h1>
        <div class="info-item" id="current_time"></div>
        <div class="info-item" id="uptime"></div>
<div class="info-item">
	<span id="total_memory"></span>
	<span id="used_memory"></span>
	<span id="available_memory"></span>
</div>

        <div class="info-item" id="load_average"></div>
        <div class="info-item" id="disk_usage"></div>
    </div>
</body>
</html>








