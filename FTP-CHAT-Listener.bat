@echo off
title ITCMD FTP-CHAT Listener
CMDS /ts "ITCMD FTP-CHAT    Signing In . . ."
if %errorlevel%==1 goto tryagain
set pid=%errorlevel%
goto pidload
:tryagain
timeout /t 10 >nul
CMDS /ts "ITCMD FTP-CHAT    Signing In . . ."
if %errorlevel%==1 goto exit /b
set pid=%errorlevel%
goto pidload


:pidload
cls
echo found on: %PID%
ren "C:\users\%username%\Appdata\FTPCHAT\ServerInfo.itcmd" "ServerInfo.bat"
call "C:\users\%username%\Appdata\FTPCHAT\ServerInfo.bat"
ren "C:\users\%username%\Appdata\FTPCHAT\ServerInfo.bat" "ServerInfo.itcmd"
if not exist "C:\users\%username%\Appdata\FTPCHAT\UserInfo.itcmd" goto setupUser
ren "C:\users\%username%\Appdata\FTPCHAT\UserInfo.itcmd" "UserInfo.bat"
call "C:\users\%username%\Appdata\FTPCHAT\UserInfo.bat"
ren "C:\users\%username%\Appdata\FTPCHAT\UserInfo.bat" "UserInfo.itcmd"
:looped
tasklist /FI "PID eq %PID%" | find "No tasks are running"
if %errorlevel%==0 goto off
timeout /t 10 >nul
goto looped


:off
cls
echo Title lost. Sending offline message.
for /f "tokens=1-7 delims=:/-, " %%i in ('echo exit^|cmd /q /k"prompt $d $t"') do (
   for /f "tokens=2-4 delims=/-,() skip=1" %%a in ('echo.^|date') do (
      set dow=%%i
      set %%a=%%j
      set %%b=%%k
      set %%c=%%l
      set hh=%%m
      set min=%%n
      set ss=%%o
   )
)
for /F "skip=1 delims=" %%F in ('
    wmic PATH Win32_LocalTime GET Day^,Month^,Year /FORMAT:TABLE
') do (
    for /F "tokens=1-3" %%L in ("%%F") do (
        set CurrDay=0%%L
        set CurrMonth=0%%M
        set CurrYear=%%N
    )
)
echo %hh%:%min%:%ss%} %usr% left the server.   >%CurrMonth%%CurrDay%%hh%%min%%ss%.chat.%usercolor%
call :ftp "nul" "cd CHAT" "cd Chats" "put %CurrMonth%%CurrDay%%hh%%min%%ss%.chat.0f"
del /f /q %CurrMonth%%CurrDay%%hh%%min%%ss%.chat.0f

:ftp
set out=%~1
shift
(echo %ftpusr%)>temp.ftp
(echo %ftppass%)>>temp.ftp
:ftploop
if "%~1"=="" goto endftploop
(echo %~1)>>temp.ftp
shift
goto ftploop
:endftploop
(echo quit)>>temp.ftp
ftp -s:temp.ftp %server% >%out%
del /f /q temp.ftp
exit /b


:CMDS
set oldnum=NO
setlocal EnableDelayedExpansion
pushd "%TEMP%"
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
set "DEL=%%a"
)
rem Prepare a file "X" with only one dot
<nul > X set /p ".=."


if "%1"=="/TS" goto ts
if "%1"=="/ts" goto ts
if "%1"=="/Ts" goto ts
if "%1"=="/tS" goto ts
if "%1"=="/s" tasklist /fi "imagename eq cmd.exe" /fo list /v & exit /b
if "%1"=="/S" tasklist /fi "imagename eq cmd.exe" /fo list /v & exit /b
if "%1"=="/?" goto help
goto nxt

:ts
set num=0
tasklist /fi "imagename eq cmd.exe" /fo list /v | find /I "Window Title:" >System
for /F "tokens=*" %%A in  (System) do  (
set /a num+=1
set Title!num!=%%A
set totalnum=!num!
)



:: ===================== Memory =======================
set num=0
tasklist /fi "imagename eq cmd.exe" /fo list /v | find /I "Mem Usage:" >System
for /F "tokens=*" %%A in  (System) do  (
set /a num+=1
set Mem!num!=%%A
)

:: ===================== PID ========================
set num=0
tasklist /fi "imagename eq cmd.exe" /fo list /v | find /I "PID:" >System
for /F "tokens=*" %%A in  (System) do  (
set /a num+=1
set PID!num!=%%A
)
setlocal EnabledelayedExpansion
set num=0
:tsloop
set /a num+=1
if "%~2"=="" exit /b 2
if "!Title%num%!"=="Window Title: %~2" goto isrite
if %num%==%totalnum% goto nonets
goto tsloop
:isrite
::window was found
set str=!PID%num%!
set "result=%str::=" & set "result=%"
set result=%result: =%
popd
exit /b %result%

:nonets
popd
endlocal
exit /b 1

:colorEcho21
set "param=^%~2" !
set "param=!param:"=\"!"
findstr /p /A:%1 "." "!param!\..\X" nul
<nul set /p ".=%DEL%%DEL%%DEL%%DEL%%DEL%%DEL%%DEL%"
exit /b


:exit
popd
endlocal
exit /b
