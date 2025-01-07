@echo off
setlocal

:menu
echo 请选择一个选项:
echo 1. 拷贝 s2-config.json 覆盖 config.json
echo 2. 拷贝 s13-config.json 覆盖 config.json
echo q. 退出脚本
set /p choice=请输入你的选择 (1、2 或 q): 

if /I "%choice%"=="1" (
    if exist s2-config.json (
        copy /Y s2-config.json config.json
        echo 已成功拷贝 s2-config.json 到 config.json
    ) else (
        echo 错误: s2-config.json 文件不存在
    )
) else if /I "%choice%"=="2" (
    if exist s13-config.json (
        copy /Y s13-config.json config.json
        echo 已成功拷贝 s13-config.json 到 config.json
    ) else (
        echo 错误: s13-config.json 文件不存在
    )
) else if /I "%choice%"=="q" (
    echo 退出脚本
    exit /B
) else (
    echo 错误: 请输入有效的选项 (1、2 或 q)
    goto menu
)

endlocal
