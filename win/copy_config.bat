@echo off
setlocal

:menu
echo ��ѡ��һ��ѡ��:
echo 1. ���� s2-config.json ���� config.json
echo 2. ���� s13-config.json ���� config.json
echo q. �˳��ű�
set /p choice=���������ѡ�� (1��2 �� q): 

if /I "%choice%"=="1" (
    if exist s2-config.json (
        copy /Y s2-config.json config.json
        echo �ѳɹ����� s2-config.json �� config.json
    ) else (
        echo ����: s2-config.json �ļ�������
    )
) else if /I "%choice%"=="2" (
    if exist s13-config.json (
        copy /Y s13-config.json config.json
        echo �ѳɹ����� s13-config.json �� config.json
    ) else (
        echo ����: s13-config.json �ļ�������
    )
) else if /I "%choice%"=="q" (
    echo �˳��ű�
    exit /B
) else (
    echo ����: ��������Ч��ѡ�� (1��2 �� q)
    goto menu
)

endlocal
