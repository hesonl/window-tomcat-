@echo off
rem echo off���������ļ��е��������ʹ��������������ʾ��������ʾ��ǰ�����@��Ϊ��ʹ�䱾����ʾ
rem setlocal���������ػ���һ�ֲ�������ִ��setlocal֮�������Ļ����Ķ�ֻ�����������ļ�
rem ENABLEDELAYEDEXPANSION ���ñ����ӳ٣�ֱ������ƥ���endlocal����
SETLOCAL ENABLEDELAYEDEXPANSION
 
rem ����  
set URL="http://localhost/PMLF_TCMA_GD/authorize?command=UserPasswordChangeForm"
rem tomcatĿ¼  
set TOMCAT_HOME="F:\apache-tomcat-6.0.48"
rem �ر�tomcat�����·��  
set CLOSE_CMD=%TOMCAT_HOME%\bin\shutdown.bat
rem ����tomcat�����·��  
set START_CMD=%TOMCAT_HOME%\bin\startup.bat
rem tomcat����Ŀ¼  
set TOMCAT_CACHE=%TOMCAT_HOME%\work
rem ��־�ļ���·��  
set LOG_PATH=%TOMCAT_HOME%\check.log
rem ÿ�μ�����ȴ�ʱ�䣬�ٽ�����һ�μ�⣬����������ϵͳ�ƻ����񣬿ɺ���  
set TIME_WAIT=30
rem ����֪ͨ�ӿڵĹ��߳���
set NOTIFICATION_MESS="C:\Program Files\messagePush.exe"
 
rem :loop �������goto��ϳ�ѭ��
:loop

set httpcode=0
rem ��tomcatĿ¼
cd /d %TOMCAT_HOME%\bin
rem ��ӡʱ��
echo %date% %time%
rem ����Ļ�ϴ�ӡִ��״̬
echo 'begin checking tomcat'  
 
rem ����¼��������־�ļ���
echo %date% %time% >>%LOG_PATH%
rem ѭ��
rem FOR [����] %%������ IN (����ļ�������)   DO ִ�е����� /d
rem ���в�����/d /l /r /f
rem ���� /d (����ֻ����ʾ��ǰĿ¼�µ�Ŀ¼����)
rem ���� /R (����ָ��·����������Ŀ¼����set����ϵ������ļ�)
rem ���� /L (�ü���ʾ��������ʽ�ӿ�ʼ��������һ���������С�����ʹ�ø��� Step)
rem ���� /F (ʹ���ļ���������������������ַ������ļ����ݡ�)
rem (����ļ�������)ָ��һ����һ���ļ�������ʹ��ͨ���

for /l %%i in (1,1,10) do (  
    echo %%i
rem �������߻����Ŀ��״̬ͷ��curl���ߵİ�װ���������ἰ��
rem	������r��ֵ��ֵ��httpcode
    for /f "delims=" %%r in ('curl -sL -w "%%{http_code}" %URL% -o /dev/null -m 10') do (
        set httpcode=%%r
        if !httpcode!==200 (
            GOTO :OUTFOR
        )
    )
)
  
:OUTFOR  
echo %httpcode% >>%LOG_PATH%  
  
if not %httpcode%==200 (
rem    start /min "" "C:\Program Files\crul\KXunOnlineState.exe"
rem	call %NOTIFICATION_MESS%
    echo close tomcat >>%LOG_PATH%
rem �ر�tomcat   call�������������ڵ�����һ���������ļ���start����ִ��һЩ�ⲿ����
	call %CLOSE_CMD% 
    timeout -t 10 >nul
rem ��¼��־
    echo success to close tomcat >>%LOG_PATH%  
rem ���tomcatwork�ռ� /s��˼�ǲ���Ҫȷ�ϵ�ɾ��  /Q�����Ŀ¼����Ŀ¼
    rd /S /Q %TOMCAT_CACHE%  
    echo start tomcat >>%LOG_PATH%
rem ����tomcat,ִ��bat�ļ�
 	call %START_CMD%      
    echo success to start tomcat  
    echo success to start tomcat >>%LOG_PATH%  
) else (
    echo the tomcat is running  
    echo the tomcat is running>>%LOG_PATH%  
)  
timeout -t 3 >nul  
rem �����ű�������ϵͳ�ƻ������У������´����ע��  
timeout -t %TIME_WAIT% >nul  
GOTO :loop
