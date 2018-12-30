@echo off
if not exist "C:\users\%username%\Appdata\FTPCHAT\ServerInfo.itcmd" exit /b
if not exist "C:\users\%username%\Appdata\FTPCHAT\UserInfo.itcmd" exit /b
ren "C:\users\%username%\Appdata\FTPCHAT\ServerInfo.itcmd" "ServerInfo.bat"
call "C:\users\%username%\Appdata\FTPCHAT\ServerInfo.bat"
ren "C:\users\%username%\Appdata\FTPCHAT\ServerInfo.bat" "ServerInfo.itcmd"
if not exist "C:\users\%username%\Appdata\FTPCHAT\UserInfo.itcmd" goto setupUser
ren "C:\users\%username%\Appdata\FTPCHAT\UserInfo.itcmd" "UserInfo.bat"
call "C:\users\%username%\Appdata\FTPCHAT\UserInfo.bat"
ren "C:\users\%username%\Appdata\FTPCHAT\UserInfo.bat" "UserInfo.itcmd"
set >test.txt.txt
echo searching for title.
timeout /t 2 >nul
title ITCMD FTP-CHAT Listener
call :CMDS /ts "ITCMD FTP-CHAT    Signing In . . ."
if %errorlevel%==1 goto tryagain
set pid=%errorlevel%
goto pidload
:tryagain
echo failed. Trying again . . .
timeout /t 10 >nul
call :CMDS /ts "ITCMD FTP-CHAT    Signing In . . ."
if %errorlevel%==1 exit /b
set pid=%errorlevel%
goto pidload


:pidload
echo Loaded >loaded.status
call :on
cls
echo found on: %PID%
:looped
tasklist /FI "PID eq %PID%" | find "No tasks are running"
if %errorlevel%==0 goto off
timeout /t 10 >nul
goto looped

:on
cls
echo Sending join message
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
set CurrMonth=%CurrMonth:~-2%
set CurrDay=%CurrDay:~-2%
echo %hh%:%min% [32m+[90m%usr% >%CurrMonth%%CurrDay%%hh%%min%%ss%.chat.08
call :ftp "nul" "cd CHAT" "cd Chats" "put %CurrMonth%%CurrDay%%hh%%min%%ss%.chat.08"
del /f /q %CurrMonth%%CurrDay%%hh%%min%%ss%.chat.08
exit /b


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
set CurrMonth=%CurrMonth:~-2%
set CurrDay=%CurrDay:~-2%
echo %hh%:%min% [31m-[90m%usr% >%CurrMonth%%CurrDay%%hh%%min%%ss%.chat.08
call :ftp "nul" "cd CHAT" "cd Chats" "put %CurrMonth%%CurrDay%%hh%%min%%ss%.chat.08"
del /f /q %CurrMonth%%CurrDay%%hh%%min%%ss%.chat.08
exit

:ftp
set out=%~1
shift
echo. 2>temp2.ftp 1>nul
:ftploop
if "%~1"=="" goto endftploop
(echo %~1)>>temp2.ftp
shift
goto ftploop
:endftploop
(echo exit)>>temp2.ftp
echo Set oShell = CreateObject ("Wscript.Shell") >WinSCP2.vbs
echo Dim strArgs>>WinSCP2.vbs
(
echo strArgs = "cmd.exe /c """"%bincd%\winscp.com"" /ini=nul /script=""%cd%\temp2.ftp"" ftp://%ftpusr%:%ftppass%@%server%"" >%out%"
)>>WinSCP2.vbs
echo oShell.Run strArgs, 0, true>>WinSCP2.vbs
cscript WinSCP2.vbs >VBResult
if %errorlevel%==0 (
	del /f /q VBResult
) ELSE (
	echo %time% %date% >> VBResult
	ren VBResult VBS-Error-%random%.txt
)
::"%bincd%\WinSCP.com" /open /ini=nul /script=temp2.ftp  >%out%
del /f /q temp2.ftp
del /f /q WinSCP2.vbs
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
:nxt
::Setlocal EnableDelayedExpansion
:: ===================== Window Title =================
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
if "%1"=="/w" goto lloop
if "%1"=="/W" goto lloop
:Display
echo [92mCMDS by IT Command       (use /? for help)     %totalnum% Windows Open[0m
echo =====================================================================================
set num=0
setlocal EnableDelayedExpansion
:tpds
set /a num+=1
if %num% LSS 10 call :Colorecho21 08 "%num% ]   "
if %num% GTR 9 call :Colorecho21 08 "%num%]   "

set str=!PID%num%!
set "result=%str::=" & set "result=%"
set result=%result: =%
call :Colorecho21 0b "PID:  %result%  "
if %result% LSS 10000 call :Colorecho21 0f " "
call :Colorecho21 0e "!Mem%num%!  "
echo [92m!Title%num%![0m
if %num%==%totalnum% goto stops11
goto tpds
:stops11
echo =====================================================================================
endlocal
if "%1"=="/p" pause
if "%1"=="/P" pause
if "%2"=="/P" pause
if "%2"=="/p" pause
if "%3"=="/P" pause
if "%3"=="/p" pause

if "%1"=="/l" echo Press any key to continue or CTRL+C to quit . . . & pause>nul & cls & goto nxt
if "%1"=="/L" echo Press any key to continue or CTRL+C to quit . . . & pause>nul & cls & goto nxt
if "%2"=="/l" echo Press any key to continue or CTRL+C to quit . . . & pause>nul & cls & goto nxt
if "%2"=="/L" echo Press any key to continue or CTRL+C to quit . . . & pause>nul & cls & goto nxt
if "%3"=="/l" echo Press any key to continue or CTRL+C to quit . . . & pause>nul & cls & goto nxt
if "%3"=="/L" echo Press any key to continue or CTRL+C to quit . . . & pause>nul & cls & goto nxt
goto exit


:Displayl1
echo [92mCMDS by IT Command       (use /? for help)     %totalnum% Windows Open[0m
echo =====================================================================================
set num=0
setlocal EnableDelayedExpansion
:tpdsl1
set /a num+=1
if %num% LSS 10 call :Colorecho21 08 "%num% ]   "
if %num% GTR 9 call :Colorecho21 08 "%num%]   "

set str=!PID%num%!
set "result=%str::=" & set "result=%"
set result=%result: =%
call :Colorecho21 0b "PID:  %result%  "
if %result% LSS 10000 call :Colorecho21 0f " "
call :Colorecho21 0e "!Mem%num%!  "
echo [92m!Title%num%![0m
if %num%==%totalnum% goto stops11l11
goto tpdsl1
:stops11l11
echo =====================================================================================
:stops11l1
(
endlocal
set oldnum=%num%
)
timeout /t 3 >nul
Setlocal EnableDelayedExpansion
goto nxt


:lloop
if %oldnum%==NOT goto displayl1
if %num%==%oldnum% goto stops11l1
cls
goto displayl1





:help
call :Colorecho21 0f "CMDS Command Prompt Window Lister by IT Command"
echo.
echo.
echo CMDS [/S] [/P] [/L] [/W] [/TS String]
echo.
echo  /S         Displays the simple but high information version (fast)
echo  /P         Pauses Before Exiting. Usefull if using from Run.
echo  /L         Pauses and refreshes on press of key. Use CTRL+C to quit.
echo  /W         Refreshes only when a new cmd instance starts (new PID).
echo             Note: This will not refresh if an old window closes
echo                   and a new one opens at the same time.
echo  /TS        Use within a batch file to search for a Window Title
echo  String     The Window Title to search for with /TS 
echo.
echo.
echo  with /TS the errorlevel will be set to 1 if the title was not found.
echo  If it is found, the errorlevel will be set to the PID of the cmd instance.
echo.
pause
echo.
echo Example:
echo.
echo    CMDS /TS "My Window"
echo.
echo     The Above Command Will set the errorlevel to the PID of the cmd instance
echo     with the title "My Window" (set with the title command). If the instance
echo     is not found (there is no running window) the errorlevel will be 1.
echo     if the Syntax was incorrect, errorlevel will be set to 2.
echo.
echo.
call :Colorecho21 07 " Created by Lucas Elliott with IT Command"
call :Colorecho21 0b "  www.ITCommand.tech"
echo.
echo.
goto exit

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
