@echo off
set ver=2.0.15
set defaultColor=0f
set usercolor=0a
set debug=false
set CodeColor=70
set updateDelay=7
set Update=No
if exist "C:\users\%username%\Appdata\FTPCHAT\UserColor.cmd" call "C:\users\%username%\Appdata\FTPCHAT\UserColor.cmd"
setlocal EnableDelayedExpansion
if "%~1"=="antiviral" goto antiviral
:reset
color 07
if not exist Bin\ md Bin
cd Bin
if not exist "Winhttpjs.bat" call :Winhttpjs
if not exist Chat\ md Chat\
if not exist batbox.exe call winhttpjs.bat "https://github.com/ITCMD/ITCMD-STORAGE/raw/master/batbox.exe" -saveto "%cd%\batbox.exe" >nul
if not exist tick.wav  call winhttpjs.bat "https://github.com/ITCMD/ITCMD-STORAGE/raw/master/tick.wav" -saveto "%cd%\tick.wav" >nul
if not exist cmdwiz.exe call winhttpjs.bat "https://github.com/ITCMD/ITCMD-STORAGE/raw/master/cmdwiz.exe" -saveto "%cd%\cmdwiz.exe" >nul
if not exist LC.exe call winhttpjs.bat "https://github.com/ITCMD/ITCMD-STORAGE/raw/master/LC.exe" -saveto "%cd%\LC.exe" >nul
if not exist "C:\users\%username%\Appdata\FTPCHAT\" md "C:\users\%username%\Appdata\FTPCHAT\"
if "%~1"=="updated" goto cleanupdate
if not exist "C:\users\%username%\Appdata\FTPCHAT\ServerInfo.itcmd" goto setup
ren "C:\users\%username%\Appdata\FTPCHAT\ServerInfo.itcmd" "ServerInfo.bat"
call "C:\users\%username%\Appdata\FTPCHAT\ServerInfo.bat"
ren "C:\users\%username%\Appdata\FTPCHAT\ServerInfo.bat" "ServerInfo.itcmd"
if not exist "C:\users\%username%\Appdata\FTPCHAT\UserInfo.itcmd" goto setupUser
ren "C:\users\%username%\Appdata\FTPCHAT\UserInfo.itcmd" "UserInfo.bat"
call "C:\users\%username%\Appdata\FTPCHAT\UserInfo.bat"
ren "C:\users\%username%\Appdata\FTPCHAT\UserInfo.bat" "UserInfo.itcmd"
if not exist "Listener-Launcher.vbs" call :makevbs
if not exist "FTP-CHAT-Listener.bat" call winhttpjs.bat "https://github.com/ITCMD/ftpchat/raw/master/FTP-CHAT-Listener.bat" -saveto "%cd%\FTP-CHAT-Listener.bat" >nul
for /F "skip=1 delims=" %%F in ('
    wmic PATH Win32_LocalTime GET Day^,Month^,Year /FORMAT:TABLE
') do (
    for /F "tokens=1-3" %%L in ("%%F") do (
        set CurrDay=0%%L
        set CurrMonth=0%%M
        set CurrYear=%%N
    )
)
set CurrDay=%CurrDay:~-2%
if not exist LastUpdate.txt (echo %currDay%)>LastUpdate.txt
set /p OldDay=<LastUpdate.txt
if not "%OldDay%"=="%CurrDay%" call :updateCheckup
goto start
::+_++#$(#(#(#)# ??
::Load



:UpdateCheckup
bitsadmin /transfer myDownloadJob /download /priority Low https://github.com/ITCMD/ftpchat/raw/master/version.download "%cd%\versionDownload.txt" >nul
find "%ver%" "versionDownload.txt" >nul
if %errorlevel%==0 exit /b
set update=Yes



:setupUser
cls
call :c 0a "Welcome. Please Enter a Username to use."
call :c 08 "You can use: a-z, 0-9, @#$].~+-=_/\:;"
set /p usr=">"
call :c 08 "Checking if available . . ."
call :ftp "out.txt" "cd CHAT" "get 54.dll"
find /I "%usr%Pass" "54.dll" >nul
if %errorlevel%==0 goto login
call :c 0a "Great %usr%, Enter a password."
call :c 08 "You can use: a-z, 0-9, @#$].~+-=_/\:;"
set /p pas=">"
call :C 0f "Re-enter password to verify"
set /p pas2=">"
if not "%pas%"=="%pas2%" echo Does not match & pause & goto setupUser
call :C 0a "Great. Saving . . ."
call :ftp "nul" "cd CHAT" "get 54.dll"
(echo set %Usr%Pass=%pas%)>>54.dll
pause
call :ftp "nul" "cd CHAT" "put 54.dll"
del /f /q 54.dll
call :c 0a "Logging in" /n
timeout /t 1 >nul
call :c 0a " ." /n
timeout /t 1 >nul
call :c 0a " ." /n
timeout /t 1 >nul
call :c 0a " ." /n
goto start

:login
cls
call :c 0f "Username is in use. Enter Password or X to cancel."
call :c 08 "Password will be hidden."
call batbox /c 0x00
set /p pas=">"
call batbox /c 0x%defaultColor%
setlocal EnableDelayedExpansion
find /I "%usr%pass=%pas%" "54.dll"
if not %errorlevel%==0 goto nope
del /f /q 54.dll
Endlocal
(echo set usr=%usr%)>"C:\users\%username%\Appdata\FTPCHAT\UserInfo.itcmd"
call :C 0a "Logging in . . ."
cls
goto start

:nope
cls
echo Password incorrect. %usr%Pass=%pas%
del /f /q 54.dll
set >test.t
Endlocal
pause
cd ..
goto reset

:start
cls
if "%update%"=="yes" call :c 02 "An update is available. Install by pressing U in main chat."
if exist loaded.status del /f /q loaded.status
title ITCMD FTP-CHAT    Signing In . . .
start "" "Listener-Launcher.vbs"
if exist Welcome.bat del /f /q Welcome.bat
call :ftp "nul" "cd CHAT" "get admin/Welcome.bat"
if not exist Welcome.bat goto offline
call :c 08 "Running ITCMD OS Version %ver%"
echo.
call Welcome.bat
call :c 0a "Logging in . . ."
set num=0
:startloop
set /a num+=1
timeout /t 3 >nul
if exist loaded.status goto mainchat
if %num%==10 echo Login failed. Press any key to retry . . . & pause & goto reset
goto startloop

:offline
call :c 0c "SERVER OFFLINE!"
pause
exit /b


:makevbs
echo Dim WinScriptHost >Listener-Launcher.vbs
echo set WinScriptHost = CreateObject("wscript.shell") >>Listener-Launcher.vbs
echo WinScriptHost.CurrentDirectory = "%cd%" >>Listener-Launcher.vbs
echo  WinScriptHost.Run chr(34) ^& "%cd%\FTP-CHAT-Listener.bat" ^& chr(34), 0 >>Listener-Launcher.vbs
echo Set WinScriptHost = Nothing>>Listener-Launcher.vbs
exit /b


:recom
cls
echo loading . . .
call winhttpjs.bat "https://raw.githubusercontent.com/ITCMD/ftpchat/master/RecommendedSettings.download" -saveto "%cd%\Recommended settings.txt" >nul
call :c 0f "The Recommended settings for your FTP server are as follows:"
type "Recommended Settings.txt"
call :c 0f "=================================================================================================="
pause

:setup
cls
call :c 0a "Welcome to the ITCMD FTP Chat Setup"
call :c 08 "To access this menu once set up go to " /n
call :c 08 "Options" /u /n
call :c 08 " then " /n
call :c 08 "Setup" /u
echo.
echo 1] Recommended FTP Server settings (please view if new!).
echo 2] Begin Setup
choice /c 12
if %errorlevel%==1 goto recom
call :c 0f "Please Enter an ftp server" /n
call :c 08 "  e.g. ftp.server.com"
set /p server=">"
call :c 0f "Please Enter in the ftp server username"
set /p ftpusr=">"
call :c 0f "Please Enter in the ftp user's password."
call :c 08 "Text Will be hidden."
batbox /c 0x00
set /p ftppass="Hidden:"
cls
batbox /c 0x07
echo testing . . .
echo. 2>t.ftp
(echo %ftpusr%
echo %ftppass%
echo quit)>>t.ftp
ftp -s:t.ftp %server% >test.ftp
::del /f /q t.ftp
del /f /q t.ftp
find "Login failed." "test.ftp" >nul
if %errorlevel%==0 goto badlog
call :c 0a "login success . . ."
echo Testing if server is setup for chat . . .
call :ftp "t.ftp" "ls"
find "CHAT" "t.ftp" >nul
if not %errorlevel%==0 goto notsetup
call :c 0a "server is set up . . ."
echo saving . . .
(echo set server=%server%)>"C:\users\%username%\Appdata\FTPCHAT\ServerInfo.itcmd"
(echo set ftpusr=%ftpusr%)>>"C:\users\%username%\Appdata\FTPCHAT\ServerInfo.itcmd"
(echo set ftppass=%ftppass%)>>"C:\users\%username%\Appdata\FTPCHAT\ServerInfo.itcmd"
call :c 0a "Setup Saved. Resetting . . ."
timeout /t 2 >nul
cd ..
goto reset

:notsetup
cls
echo Not Set Up. Would you like to set up now?
choice /c YN
if %errorlevel%==1 goto setupdir
echo cancled.
pause
goto setup


:setupdir
call :c 0a "Setting up . . ."
echo echo FTP-Chat Server by IT Command (www.itcommand.tech) >Welcome.txt
echo echo Running on %server% since %date% @ %time% >>Welcome.txt
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
for /f "skip=1" %%x in ('wmic os get localdatetime') do set timestamp=%%x & goto endstamp1
:endstamp1
echo %hh%:%min%:%ss%]SERVER} Beginning of Chat >%timestamp%.chat.0a
echo CREATED SERVER %date% %time% >log.txt
echo. 2>54.dll
call :ftp "rep.txt" "prompt" "mkdir CHAT" "cd CHAT" "mkdir Files" "mkdir Chats" "mkdir Bin" "mkdir mods" "mkdir admin" "mkdir online" "mkdir log" "cd admin: "put Welcome.txt Welcome.bat" "cd .." "cd Chats" "put %timestamp%.chat.07" "cd .." "put 54.dll" "cd log" "put log.txt"
del /f /q Welcome.txt
call :c 0a "Testing if Setup was Successful"
call :ftp "test.ftp" "cd CHAT" "ls"
findstr "Files" "test.ftp" >nul
if %errorlevel%==1 goto failed
findstr "Chats" "test.ftp" >nul
if %errorlevel%==1 goto failed
findstr "Bin" "test.ftp" >nul
if %errorlevel%==1 goto failed
findstr "mods" "test.ftp" >nul
if %errorlevel%==1 goto failed
findstr "admin" "test.ftp" >nul
if %errorlevel%==1 goto failed
findstr "online" "test.ftp" >nul
if %errorlevel%==1 goto failed
findstr "log" "test.ftp" >nul
if %errorlevel%==1 goto failed
::USE NO SUBFOLDERS!
call :c 0a "Setup Success!"
echo Saving . . .
(echo set server=%server%)>"C:\users\%username%\Appdata\FTPCHAT\ServerInfo.itcmd"
(echo set ftpusr=%ftpusr%)>>"C:\users\%username%\Appdata\FTPCHAT\ServerInfo.itcmd"
(echo set ftppass=%ftppass%)>>"C:\users\%username%\Appdata\FTPCHAT\ServerInfo.itcmd"
call :c 0a "Setup Saved."
pause
cd ..
goto reset


:failed
cls
call :c 0c "Setup Failed. Please check ftp server permissions." /u
echo This is the report file from attempting to set up server:
echo =============================================================
type rep.txt
del /f /q rep.txt
echo =============================================================
type test.ftp
echo =============================================================
pause
goto setup

:badlog
cls
echo Failed to connect to server. Please check credentials.
if %debug%==true type test.ftp
del /f /q test.ftp
pause
goto setup


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


:update
cd ..
cls
call :c 0a "Checking for update . . ."
call :c 08 "This Version: %ver%"
bitsadmin /transfer myDownloadJob /download /priority High https://github.com/ITCMD/ftpchat/raw/master/version.download "%cd%\versionDownload.txt" >nul
find "%ver%" "versionDownload.txt" >nul
if %errorlevel%==0 call :c a0 "You are up to date." & pause & cls & goto type
set /p nv=<"versionDownload.txt"
call :c 0f "An Update is available: %nv%"
call :c 0f "Downloading . . ."
bitsadmin /transfer myDownloadJob /download /priority High https://raw.githubusercontent.com/ITCMD/ftpchat/master/ftpCHAT.bat "%cd%\chatUPDATE.txt" >nul
call :c 08 "Checking Notification Updates . . ."
call :c 08 "Installing . . ."
echo @echo off >update.bat
(echo title Update Installer . . .
echo color 0a
echo echo Installing Update . . .
echo if not exist chatUPDATE.txt echo ERROR ^&pause ^&exit /b
echo copy /b/v/y "chatUPDATE.txt" "%~nx0" ^>nul
echo start "" "%~nx0" updated
echo timeout /t 2 ^>nul
echo exit)>>update.bat
start "" "update.bat"
exit 


:cleanupdate
cls
cd..
call :c a0 "Update Installed."
call :c 08 "Cleaning up . . ."
timeout /t 3 >nul
del /f /q "chatUPDATE.txt"
del /f /q "update.bat"
del /f /q "versionDownload.txt"
if exist "FTP-CHAT-Listener.bat" del /f /q "FTP-CHAT-Listener.bat"
if exist "Listener-Launcher.vbs" del /f /q "Listener-Launcher.vbs"
call :c 08 "Cleanup complete."
echo.
call :c f0 "changelog:"
echo First Update
pause
goto reset





:mainchat
cls
cd chat
call :ftp "nul" "prompt" "cd CHAT" "cd Chats" "mget *"
cd ..
dir /b Chat >chatorder.txt
set CodeCount=0
setlocal EnableDelayedExpansion
for /f "tokens=*" %%A in (chatorder.txt) do (
	cd Chat
	set color=%%~xA
	set color=!color:~1!
	set /p text=<"%%A"
	if "!color!"=="code" for /f "tokens=*" %%I in ("%%A") do (
		set /a CodeCount+=1
		set code!CodeCount!=%%A
		set color=!CodeColor! 
		for /f %%W in ("%%~nA") do (set text=%%~xW)
		set text=!text:~1!] [4m{Press B and select !CodeCount! to View Code}[0m)
		
	call :c !color! "!text!"
	cd ..
)
:wait
title ITCMD FTP-Chat by Lucas Elliott ^| T-Talk ^| H-Help ^| U-Update ^| O-Options ^| F-Files
cd Chat
for /f %%A in ('dir ^| find "File(s)"') do set cnt=%%A
cd ..
choice /c QTBUOF /d Q /t %updateDelay% /n >nul
if %errorlevel%==1 goto refresh
if %errorlevel%==2 goto talk
if %errorlevel%==4 goto update
if %errorlevel%==5 goto options
if %errorlevel%==3 goto viewCode
if %errorlevel%==6 goto fileman
goto wait

11
:fileman
cls
call :c 0f "====== File Manager 3.6 ======"
call :c 0a "1] Upload a file"
call :c 0a "2] View files"
call :c 02 "X] Go Back"
choice /c 12x
if %errorlevel%==3 goto mainchat
if %errorlevel%==1 goto upload
:viewFiles
cls
call :c 0f "====== File Manager 3.6 ======"
call :ftp "FileListBase.txt" "cd CHAT/Files" "ls"
for /F "delims=" %%j in (FileListBase.txt) do (
  set /A count+=1
)
set /a count-=3
set count2=0
echo. 2>FileList.txt 1>nul
for /F "delims=" %%j in (FileListBase.txt) do (
  set /A count2+=1
  if !count2!==!count! goto eo
  (echo %%j)>>FileList.txt
)
:eo
call :c 0a "Please select a file to open."
del /f /q FileListBase.txt
set Files=0
for /f "tokens=* skip=11" %%A in (FileList.txt) do (
	set /a Files+=1
	set File!Files!=%%A
	call :c 0f "!Files!] %%A"
)
call :c 08 "Enter -X to Exit"
set /p fcho=">"
if /i "%fcho%"=="-x" goto fileman
if "!File%fcho%!"=="" goto eo
cls
call :c 07 "Downloading !File%fcho%! . . ."
if not exist ..\Files\ md ..\Files\
cd ..\Files
call :ftp "nul" "cd CHAT/Files" "get !File%fcho%!"
cd ..\Bin
call :c 07 "Download Complete."
call :c 0a "Would You like to scan this file with Windows Defender?"
choice 
if %errorlevel%==1 (
	cd ..\Files
	call :scan "%cd%\!File%fcho%!"
	cd ..\Bin
)
call :c 0a "Opening File . . ."
timeout /t 2 >nul
explorer /select,"..\Files\!File%fcho%!"
pause
goto mainchat


:Upload
cls
call :c 0f "====== File Manager 3.6 ======"
echo.
call :c 0a "Drag and Drop File Onto Screen."
call :c 08 "Or Enter Path Manually. Enter -X to cancel."
set /p FileUpload=">"
if /i %FileUpload%==-X goto Fileman
if not exist "%FileUpload%" echo File Not Found. & pause & goto Upload
call :c 0a "Uploading File . . ."
(echo %ftpusr%)>temp.ftp
(echo %ftppass%)>>temp.ftp
(echo cd CHAT/Files)>>temp.ftp
(echo put %FileUpload%)>>temp.ftp
(echo quit)>>temp.ftp
ftp -s:temp.ftp %server% >temp.output.txt
del /f /q temp.ftp
find "bytes sent in" "temp.output.txt" >nul
if not %errorlevel%==0 goto uploadfail
del /f /q temp.output.txt
call :c 0a "Upload Successful."
pause
goto mainchat

:uploadfail
color 08
call :c 0c "Upload Failed."
call :c 02 "Log File:"
type temp.output.txt"
pause
goto mainchat



:ViewCode
if "%CodeCount%"=="" goto wait
call :C 0f "Which Code Would You Like To Select?"
call :c 08 "Choose option 1-%CodeCount%"
:choc
choice /c 123456789 /n
cls
if %errorlevel% GTR %CodeCount% goto choc
set Num=%errorlevel%
:LoadCode
call :c 0a "Displaying Code . . ."
batbox /c 0x02
type !Code%Num%!
echo.
batbox /c 0x%defaultColor%
call :c 0f "Would you like to copy that code to your clipboard?"
choice /c yn
if %errorlevel%==2 goto mainchat
call :c 0a "Copying to clipboard . . ."
clip < !Code%Num%!
call :c 0a "Success."
pause
goto mainchat




:options
Title OPTIONS      FTP-CHAT
cls
call :c 0f " Options Menu:"
call :c 0b "------------------------------"
call :c 0f "1] Sound:" /n
if exist "C:\users\%username%\Appdata\FTPCHAT\Mute" call :c 0c " Muted"
if not exist "C:\users\%username%\Appdata\FTPCHAT\Mute" call :c 0a " On"
call :c 0f "2] Color Settings
call :c 0f "3] Log Out User"
call :c 0f "4] Log Out Server"
call :c 0f "5] View Log" 
call :c 0f "6] Report Bugs"
call :c 0f "7] Clear Chat"
call :c 08 "8] Exit"
choice /c "12345678"
if %errorlevel%==1 call :muteChange
if %errorlevel%==8 goto mainchat
if %errorlevel%==7 goto clear
if %errorlevel%==3 del /f /q "C:\users\%username%\Appdata\FTPCHAT\UserInfo.itcmd" & cd .. & goto reset
if %errorlevel%==4 del /f /q "C:\users\%username%\Appdata\FTPCHAT\ServerInfo.itcmd" & del /f /q "C:\users\%username%\Appdata\FTPCHAT\UserInfo.itcmd" & cd .. & goto reset
if %errorlevel%==2 goto colorchange
goto mainchat

:muteChange
if exist "C:\users\%username%\Appdata\FTPCHAT\Mute" del /f /q "C:\users\%username%\Appdata\FTPCHAT\Mute" & exit /b
if not exist "C:\users\%username%\Appdata\FTPCHAT\Mute" echo. > "C:\users\%username%\Appdata\FTPCHAT\Mute"
exit /b


:colorchange
cls
call :c 0f "Please Select Your Color:"
call :c 0a "1] Green"
call :c 0b "2] Aqua"
call :c 0e "3] Yellow"
call :c 07 "4] White"
call :c %usercolor% "5] Unchanged"
choice /c 12345
if %errorlevel%==1 set usercolor=0a
if %errorlevel%==2 set usercolor=0b
if %errorlevel%==3 set usercolor=0e
if %errorlevel%==4 set usercolor=07
if %errorlevel%==5 echo.
(echo set UserColor=%usercolor%)> "C:\users\%username%\Appdata\FTPCHAT\UserColor.cmd"
echo Color Changed.
timeout /t 2 >nul
goto mainchat


:scan
if not exist "%~1" call :c 0c "File not found: `%~1` & exit /b
call :c 07 "Scanning . . ."
if not exist "%programFiles%\Windows Defender\MpCmdRun.exe" call :c 0c "Windows Defender Not Installed." & exit /b
call :c 08 "Note that your pc may detect it automatically and delete it before this program can remove it."
"%programFiles%\Windows Defender\MpCmdRun" -Scan -ScanType 3 -File "%~1" >nul
if %errorlevel%==0 call :c 0a "No Threats Found" & exit /b
call :c 0c "Either a Threat was found or an error occured."
call :c 08 "Testing if the file was removed."
if not exist "%~1" call :c 0a  "The File was Removed from your PC Successfuly." & exit /b
call :c 0c "The File Was Not Removed. Removing it manually..."
call :c 08 "Del /f /q '%~1'"
del /f /q "%~1"
if not exist "%~1" call :c 0a  "The File was Removed from your PC Successfuly." & exit /b
call :c c0 "ALERT!  The file could not be removed!"
call :c 0c "Starting a system Wide Scan . . ."
call :c 08 "Please Accept Admin Prompt to scan"
echo %cd%>"C:\users\%username%\CDC.txt"
powershell start -verb runas '%0' antiviral "%~1" & exit
:antiviral
set /p cdd=<"C:\users\%username%\CDC.txt"
cd %cdd%
call :c 0c "Scanning Individual File First"
"%programFiles%\Windows Defender\MpCmdRun" -Scan -ScanType 3 -File "%~2"
if not %errorlevel%==0 call :c 0c "Failure."
call :c 0c "Starting Full System Scan . . ."
"%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 2
pause
exit


:clear
echo. 2>log
for /f "tokens=*" %%A in (chatorder.txt) do (
	echo %%A
	set /p text=<"chat\%%A"
	echo !text! >>log
)

call :ftp "nul" "cd CHAT" "cd log" "get log.txt"
type log >> log.txt
call :ftp "nul" "cd CHAT" "cd log" "put log.txt"

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
echo %hh%:%min%:%ss%} SERVER] Chat Cleared.>00000000001.Message.06
call :ftp "nul" "cd CHAT" "prompt" "cd Chats" "mdelete *" "put 00000000001.Message.06"
del /f /q Chat\*.*.*
goto mainchat

:refresh
::echo cur time into file
del /f /q Chat\*.*.*
(echo %time::=%)>%usr%
cd chat
call :ftp "nul" "prompt" "cd CHAT" "cd Chats" "mget *" "cd .." "cd Online" "put ..\%usr%"
for /f %%A in ('dir ^| find "File(s)"') do set cnt2=%%A
cd ..
dir /b chat >chatorder2.txt
fc chatorder.txt chatorder2.txt >nul
if %errorlevel%==1 goto nextrefresh
goto wait

:nextrefresh
if not exist "C:\users\%username%\Appdata\FTPChat\Mute" cmdwiz playsound tick.wav
if %cnt2% LSS %cnt% goto mainchat
lc chatorder.txt chatorder2.txt
for /f "tokens=*" %%A in (new.txt) do (
	cd Chat
	set color=%%~xA
	set color=!color:~1!
	set /p text=<"%%A"
	if "!color!"=="code" for /f "tokens=*" %%I in ("%%A") do (
		set /a CodeCount+=1
		set code!CodeCount!=%%A
		set color=!CodeColor! 
		for /f %%W in ("%%~nA") do (set text=%%~xW)
		set text=!text:~1!] [4m{Press B and select !CodeCount! to View Code}[0m)
		
	call :c !color! "!text!"
	cd ..
)
dir /b Chat >chatorder.txt
goto wait


:codeshare
call :c 0f "A Window will open. Enter script, save it, and close it."
echo. 2>code.txt
notepad code.txt
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
ren code.txt %CurrMonth%%CurrDay%%hh%%min%%ss%.%usr%.code
call :ftp "nul" "cd CHAT" "cd Chats" "put %CurrMonth%%CurrDay%%hh%%min%%ss%.%usr%.code"
call :c 0a "Success."
timeout /t 2 >nul
goto mainchat

:talk
title Enter "-C" to enter code. Enter "-X" to cancel.
Batbox /c 0x%usercolor%
set /p Msg="Message}%usr%>"
Batbox /c 0x%defaultcolor%
title ITCMD FTP-Chat by Lucas Elliott ^| T-Talk ^| H-Help ^| U-Update ^| O-Options ^| F-Files
if /i "%msg%"=="-x" goto refresh
if /i "%msg%"=="-c" goto codeshare
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
:endstamp2
echo %hh%:%min%:%ss%} %usr%] %msg% >%CurrMonth%%CurrDay%%hh%%min%%ss%.chat.%usercolor%
call :ftp "nul" "cd CHAT" "cd Chats" "put %CurrMonth%%CurrDay%%hh%%min%%ss%.chat.%usercolor%"
del /f /q %CurrMonth%%CurrDay%%hh%%min%%ss%.chat.%usercolor%
goto refresh



:c
Rem use:                             call :color HexColorCodeLikeInColorCommand "Text to say" /u(underline) /n(Does no create new like)
setlocal EnableDelayedExpansion
set "text=%~2"
set color=%1
set FG=%color:~-1%
set BG=%color:~0,1%
set Sameline=False
set Underline=False
if /i "%~3"=="/n" set Sameline=True
if /i "%~3"=="/u" set Underline=True
if /i "%~4"=="/n" set Sameline=True
if /i "%~4"=="/u" set Underline=True


if /i "%FG%"=="0" set c1=30
if /i "%FG%"=="1" set c1=34
if /i "%FG%"=="2" set c1=32
if /i "%FG%"=="3" set c1=36
if /i "%FG%"=="4" set c1=31
if /i "%FG%"=="5" set c1=35
if /i "%FG%"=="6" set c1=33
if /i "%FG%"=="7" set c1=37
if /i "%FG%"=="8" set c1=90
if /i "%FG%"=="9" set c1=94
if /i "%FG%"=="a" set c1=92
if /i "%FG%"=="b" set c1=96
if /i "%FG%"=="c" set c1=91
if /i "%FG%"=="d" set c1=95
if /i "%FG%"=="e" set c1=93
if /i "%FG%"=="f" set c1=97

if /i "%BG%"=="0" set c2=40
if /i "%BG%"=="1" set c2=44
if /i "%BG%"=="2" set c2=42
if /i "%BG%"=="3" set c2=46
if /i "%BG%"=="4" set c2=41
if /i "%BG%"=="5" set c2=45
if /i "%BG%"=="6" set c2=43
if /i "%BG%"=="7" set c2=47
if /i "%BG%"=="8" set c2=100
if /i "%BG%"=="9" set c2=104
if /i "%BG%"=="a" set c2=102
if /i "%BG%"=="b" set c2=106
if /i "%BG%"=="c" set c2=101
if /i "%BG%"=="d" set c2=105
if /i "%BG%"=="e" set c2=103
if /i "%BG%"=="f" set c2=107

if %SameLine%==True call :NoNewLine & endlocal & exit /b

if %Underline%==False echo [%c1%m[%c2%m%Text%[0m
if %Underline%==True echo [4m[%c1%m[%c2%m%Text%[0m
endlocal
exit /b

:NoNewLine
if %Underline%==False echo|set /p="[%c1%m[%c2%m%Text%[0m"
if %Underline%==True echo|set /p="[4m[%c1%m[%c2%m%Text%[0m"
endlocal
exit /b

:winhttpjs
if exist "winhttpjs.bat" goto 12093163769741218092587122853 
(echo -----BEGIN CERTIFICATE-----)>temp.txt 
( 
echo QGlmIChAWCkgPT0gKEBZKSBAZW5kIC8qIEpTY3JpcHQgY29tbWVudCANCiAgICAg 
echo ICAgQGVjaG8gb2ZmIA0KICAgICAgICANCiAgICAgICAgcmVtIDo6IHRoZSBmaXJz 
echo dCBhcmd1bWVudCBpcyB0aGUgc2NyaXB0IG5hbWUgYXMgaXQgd2lsbCBiZSB1c2Vk 
echo IGZvciBwcm9wZXIgaGVscCBtZXNzYWdlIA0KICAgICAgICBjc2NyaXB0IC8vRTpK 
echo U2NyaXB0IC8vbm9sb2dvICIlfmYwIiAiJX5ueDAiICUqIA0KDQogICAgICAgIGV4 
echo aXQgL2IgJWVycm9ybGV2ZWwlIA0KICAgICAgICANCkBpZiAoQFgpPT0oQFkpIEBl 
echo bmQgSlNjcmlwdCBjb21tZW50ICovDQoNCi8vIHVzZWQgcmVzb3VyY2VzDQoNCi8v 
echo IHVwZGF0ZSAxMi4xMC4xNSANCi8vIG9zdmlrdmkoaHR0cHM6Ly9naXRodWIuY29t 
echo L29zdmlrdmkpIGhhcyBub2RpdGVkIHRoYXQgdGhlIC1wYXNzd29yZCBvcHRpb24g 
echo aXMgbm90IHNldCAsIHNvIHRoaXMgaXMgZml4ZWQNCg0KLy9odHRwczovL21zZG4u 
echo bWljcm9zb2Z0LmNvbS9lbi11cy9saWJyYXJ5L3dpbmRvd3MvZGVza3RvcC9hYTM4 
echo NDA1OCh2PXZzLjg1KS5hc3B4IA0KLy9odHRwczovL21zZG4ubWljcm9zb2Z0LmNv 
echo bS9lbi11cy9saWJyYXJ5L3dpbmRvd3MvZGVza3RvcC9hYTM4NDA1NSh2PXZzLjg1 
echo KS5hc3B4IA0KLy9odHRwczovL21zZG4ubWljcm9zb2Z0LmNvbS9lbi11cy9saWJy 
echo YXJ5L3dpbmRvd3MvZGVza3RvcC9hYTM4NDA1OSh2PXZzLjg1KS5hc3B4IA0KDQov 
echo LyBnbG9iYWwgdmFyaWFibGVzIGFuZCBjb25zdGFudHMgDQoNCg0KLy8gLS0tLS0t 
echo LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSANCi8vIC0tIGFzeW5jaCByZXF1 
echo ZXN0cyBub3QgaW5jbHVkZWQgLS0gDQovLyAtLS0tLS0tLS0tLS0tLS0tLS0tLS0t 
echo LS0tLS0tLS0tLS0tIA0KDQoNCi8vdG9kbyAtIHNhdmUgcmVzcG9uY2VTdHJlYW0g 
echo aW5zdGVhZCBvZiByZXNwb25jZUJvZHkgISEgDQovL3RvZG8gLSBzZXQgYWxsIHdp 
echo bnRodHRwIG9wdGlvbnMgLT4vL2h0dHBzOi8vbXNkbi5taWNyb3NvZnQuY29tL2Vu 
echo LXVzL2xpYnJhcnkvd2luZG93cy9kZXNrdG9wL2FhMzg0MTA4KHY9dnMuODUpLmFz 
echo cHggDQovL3RvZG8gLSBsb2cgYWxsIG9wdGlvbnMgDQovL3RvZG8gLSBpbXByb3Zl 
echo IGhlbHAgbWVzc2FnZSAuIGV2ZW50dWFsIHZlcmJvc2Ugb3B0aW9uIA0KDQoNCnZh 
echo ciBBUkdTID0gV1NjcmlwdC5Bcmd1bWVudHM7DQp2YXIgc2NyaXB0TmFtZSA9IEFS 
echo R1MuSXRlbSgwKTsNCg0KdmFyIHVybCA9ICIiOw0KdmFyIHNhdmVUbyA9ICIiOw0K 
echo DQp2YXIgdXNlciA9IDA7DQp2YXIgcGFzcyA9IDA7DQoNCnZhciBwcm94eSA9IDA7 
echo DQp2YXIgYnlwYXNzID0gMDsNCnZhciBwcm94eV91c2VyID0gMDsNCnZhciBwcm94 
echo eV9wYXNzID0gMDsNCg0KdmFyIGNlcnRpZmljYXRlID0gMDsNCg0KdmFyIGZvcmNl 
echo ID0gdHJ1ZTsNCg0KdmFyIGJvZHkgPSAiIjsNCg0KLy9BY3RpdmVYIG9iamVjdHMg 
echo DQp2YXIgV2luSFRUUE9iaiA9IG5ldyBBY3RpdmVYT2JqZWN0KCJXaW5IdHRwLldp 
echo bkh0dHBSZXF1ZXN0LjUuMSIpOw0KdmFyIEZpbGVTeXN0ZW1PYmogPSBuZXcgQWN0 
echo aXZlWE9iamVjdCgiU2NyaXB0aW5nLkZpbGVTeXN0ZW1PYmplY3QiKTsNCnZhciBB 
echo ZG9EQk9iaiA9IG5ldyBBY3RpdmVYT2JqZWN0KCJBRE9EQi5TdHJlYW0iKTsNCg0K 
echo Ly8gSHR0cFJlcXVlc3QgU2V0Q3JlZGVudGlhbHMgZmxhZ3MuIA0KdmFyIHByb3h5 
echo X3NldHRpbmdzID0gMDsNCg0KLy8gDQpIVFRQUkVRVUVTVF9TRVRDUkVERU5USUFM 
echo U19GT1JfU0VSVkVSID0gMDsNCkhUVFBSRVFVRVNUX1NFVENSRURFTlRJQUxTX0ZP 
echo Ul9QUk9YWSA9IDE7DQoNCi8vdGltZW91dHMgYW5kIHRoZWlyIGRlZmF1bHQgdmFs 
echo dWVzIA0KdmFyIFJFU09MVkVfVElNRU9VVCA9IDA7DQp2YXIgQ09OTkVDVF9USU1F 
echo T1VUID0gOTAwMDA7DQp2YXIgU0VORF9USU1FT1VUID0gOTAwMDA7DQp2YXIgUkVD 
echo RUlWRV9USU1FT1VUID0gOTAwMDA7DQoNCi8vSHR0cFJlcXVlc3RNZXRob2QgDQp2 
echo YXIgaHR0cF9tZXRob2QgPSAnR0VUJzsNCg0KLy9oZWFkZXIgDQp2YXIgaGVhZGVy 
echo X2ZpbGUgPSAiIjsNCg0KLy9yZXBvcnQgDQp2YXIgcmVwb3J0ZmlsZSA9ICIiOw0K 
echo DQovL3Rlc3QtdGhpczogDQp2YXIgdXNlX3N0cmVhbSA9IGZhbHNlOw0KDQovL2F1 
echo dG9sb2dvbiBwb2xpY3kgDQp2YXIgYXV0b2xvZ29uX3BvbGljeSA9IDE7IC8vMCwx 
echo LDIgDQoNCg0KLy9oZWFkZXJzIHdpbGwgYmUgc3RvcmVkIGFzIG11bHRpLWRpbWVu 
echo c2lvbmFsIGFycmF5IA0KdmFyIGhlYWRlcnMgPSBbXTsNCg0KLy91c2VyLWFnZW50 
echo IA0KdmFyIHVhID0gIiI7DQoNCi8vZXNjYXBlIFVSTCANCnZhciBlc2NhcGUgPSBm 
echo YWxzZTsNCg0KZnVuY3Rpb24gcHJpbnRIZWxwKCkgew0KICAgIFdTY3JpcHQuRWNo 
echo byhzY3JpcHROYW1lICsgIiAtIHNlbmRzIEhUVFAgcmVxdWVzdCBhbmQgc2F2ZXMg 
echo dGhlIHJlcXVlc3QgYm9keSBhcyBhIGZpbGUgYW5kL29yIGEgcmVwb3J0IG9mIHRo 
echo ZSBzZW50IHJlcXVlc3QiKTsNCiAgICBXU2NyaXB0LkVjaG8oc2NyaXB0TmFtZSAr 
echo ICIgdXJsICBbLWZvcmNlIHllc3xub10gWy11c2VyIHVzZXJuYW1lIC1wYXNzd29y 
echo ZCBwYXNzd29yZF0gWy1wcm94eSBwcm94eXNlcnZlcjpwb3J0XSBbLWJ5cGFzcyBi 
echo eXBhc3NfbGlzdF0iKTsNCiAgICBXU2NyaXB0LkVjaG8oIiAgICAgICAgICAgICAg 
echo ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgWy1wcm94 
echo eXVzZXIgcHJveHlfdXNlcm5hbWUgLXByb3h5cGFzc3dvcmQgcHJveHlfcGFzc3dv 
echo cmRdIFstY2VydGlmaWNhdGUgY2VydGlmaWNhdGVTdHJpbmddIik7DQogICAgV1Nj 
echo cmlwdC5FY2hvKCIgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg 
echo ICAgICAgICAgICAgICAgICAgIFstbWV0aG9kIEdFVHxQT1NUfFBBVENIfERFTEVU 
echo RXxIRUFEfE9QVElPTlN8Q09OTkVDVF0iKTsNCiAgICBXU2NyaXB0LkVjaG8oIiAg 
echo ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg 
echo ICAgICAgWy1zYXZlVG8gZmlsZV0gLSB0byBwcmludCByZXNwb25zZSB0byBjb25z 
echo b2xlIHVzZSBjb24iKTsNCg0KICAgIFdTY3JpcHQuRWNobygiICAgICAgICAgICAg 
echo ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBbLXNl 
echo bmRUaW1lb3V0IGludChtaWxsaXNlY29uZHMpXSIpOw0KICAgIFdTY3JpcHQuRWNo 
echo bygiICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg 
echo ICAgICAgICAgICBbLXJlc29sdmVUaW1lb3V0IGludChtaWxsaXNlY29uZHMpXSIp 
echo Ow0KICAgIFdTY3JpcHQuRWNobygiICAgICAgICAgICAgICAgICAgICAgICAgICAg 
echo ICAgICAgICAgICAgICAgICAgICAgICAgICAgICBbLWNvbm5lY3RUaW1lb3V0IGlu 
echo dChtaWxsaXNlY29uZHMpXSIpOw0KICAgIFdTY3JpcHQuRWNobygiICAgICAgICAg 
echo ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBb 
echo LXJlY2VpdmVUaW1lb3V0IGludChtaWxsaXNlY29uZHMpXSIpOw0KDQogICAgV1Nj 
echo cmlwdC5FY2hvKCIgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg 
echo ICAgICAgICAgICAgICAgICAgIFstYXV0b2xvZ29uUG9saWN5IDF8MnwzXSIpOw0K 
echo ICAgIFdTY3JpcHQuRWNobygiICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg 
echo ICAgICAgICAgICAgICAgICAgICAgICAgICBbLXByb3h5U2V0dGluZ3MgMXwyfDNd 
echo IChodHRwczovL21zZG4ubWljcm9zb2Z0LmNvbS9lbi11cy9saWJyYXJ5L3dpbmRv 
echo d3MvZGVza3RvcC9hYTM4NDA1OSh2PXZzLjg1KS5hc3B4KSIpOw0KDQogICAgLy9o 
echo ZWFkZXIgDQogICAgV1NjcmlwdC5FY2hvKCIgICAgICAgICAgICAgICAgICAgICAg 
echo ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFstaGVhZGVycy1maWxl 
echo IGhlYWRlcl9maWxlXSIpOw0KICAgIC8vcmVwb3J0ZmlsZSANCiAgICBXU2NyaXB0 
echo LkVjaG8oIiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg 
echo ICAgICAgICAgICAgICAgWy1yZXBvcnRmaWxlIHJlcG9ydGZpbGVdIik7DQogICAg 
echo V1NjcmlwdC5FY2hvKCIgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg 
echo ICAgICAgICAgICAgICAgICAgICAgIFstdWEgdXNlci1hZ2VudF0iKTsNCiAgICBX 
echo U2NyaXB0LkVjaG8oIiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg 
echo ICAgICAgICAgICAgICAgICAgICAgWy11YS1maWxlIHVzZXItYWdlbnQtZmlsZV0i 
echo KTsNCg0KICAgIFdTY3JpcHQuRWNobygiICAgICAgICAgICAgICAgICAgICAgICAg 
echo ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBbLWVzY2FwZSB5ZXN8bm9d 
echo Iik7DQoNCiAgICBXU2NyaXB0LkVjaG8oIiAgICAgICAgICAgICAgICAgICAgICAg 
echo ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgWy1ib2R5IGJvZHktc3Ry 
echo aW5nXSIpOw0KICAgIFdTY3JpcHQuRWNobygiICAgICAgICAgICAgICAgICAgICAg 
echo ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBbLWJvZHktZmlsZSBi 
echo b2R5LWZpbGVdIik7DQoNCiAgICBXU2NyaXB0LkVjaG8oIi1mb3JjZSAgLSBkZWNp 
echo ZGUgdG8gbm90IG9yIHRvIG92ZXJ3cml0ZSBpZiB0aGUgbG9jYWwgZmlsZXMgZXhp 
echo c3RzIik7DQoNCiAgICBXU2NyaXB0LkVjaG8oInByb3h5c2VydmVyOnBvcnQgLSB0 
echo aGUgcHJveHkgc2VydmVyIik7DQogICAgV1NjcmlwdC5FY2hvKCJieXBhc3MtIGJ5 
echo cGFzcyBsaXN0Iik7DQogICAgV1NjcmlwdC5FY2hvKCJwcm94eV91c2VyICwgcHJv 
echo eHlfcGFzc3dvcmQgLSBjcmVkZW50aWFscyBmb3IgcHJveHkgc2VydmVyIik7DQog 
echo ICAgV1NjcmlwdC5FY2hvKCJ1c2VyICwgcGFzc3dvcmQgLSBjcmVkZW50aWFscyBm 
echo b3IgdGhlIHNlcnZlciIpOw0KICAgIFdTY3JpcHQuRWNobygiY2VydGlmaWNhdGUg 
echo LSBsb2NhdGlvbiBvZiBTU0wgY2VydGlmaWNhdGUiKTsNCiAgICBXU2NyaXB0LkVj 
echo aG8oIm1ldGhvZCAtIHdoYXQgSFRUUCBtZXRob2Qgd2lsbCBiZSB1c2VkLkRlZmF1 
echo bHQgaXMgR0VUIik7DQogICAgV1NjcmlwdC5FY2hvKCJzYXZlVG8gLSBzYXZlIHRo 
echo ZSByZXNwb25jZSBhcyBiaW5hcnkgZmlsZSIpOw0KICAgIFdTY3JpcHQuRWNobygi 
echo ICIpOw0KICAgIFdTY3JpcHQuRWNobygiSGVhZGVyIGZpbGUgc2hvdWxkIGNvbnRh 
echo aW4ga2V5OnZhbHVlIHBhaXJzLkxpbmVzIHN0YXJ0aW5nIHdpdGggXCIjXCIgd2ls 
echo bCBiZSBpZ25vcmVkLiIpOw0KICAgIFdTY3JpcHQuRWNobygidmFsdWUgc2hvdWxk 
echo IE5PVCBiZSBlbmNsb3NlZCB3aXRoIHF1b3RlcyIpOw0KICAgIFdTY3JpcHQuRWNo 
echo bygiICIpOw0KICAgIFdTY3JpcHQuRWNobygiRXhhbXBsZXM6Iik7DQoNCiAgICBX 
echo U2NyaXB0LkVjaG8oc2NyaXB0TmFtZSArICIgaHR0cDovL3NvbWVsaW5rLmNvbS9z 
echo b21lZmlsZS56aXAgLXNhdmVUbyBjOlxcc29tZWZpbGUuemlwIC1jZXJ0aWZpY2F0 
echo ZSBcIkxPQ0FMX01BQ0hJTkVcXFBlcnNvbmFsXFxNeSBNaWRkbGUtVGllciBDZXJ0 
echo aWZpY2F0ZVwiIik7DQogICAgV1NjcmlwdC5FY2hvKHNjcmlwdE5hbWUgKyAiIGh0 
echo dHA6Ly9zb21lbGluay5jb20vc29tZXRoaW5nLmh0bWwgIC1tZXRob2QgUE9TVCAg 
echo LWNlcnRpZmljYXRlIFwiTE9DQUxfTUFDSElORVxcUGVyc29uYWxcXE15IE1pZGRs 
echo ZS1UaWVyIENlcnRpZmljYXRlXCIgLWhlYWRlciBjOlxcaGVhZGVyX2ZpbGUgLXJl 
echo cG9ydGZpbGUgYzpcXHJlcG9ydGZpbGUudHh0Iik7DQogICAgV1NjcmlwdC5FY2hv 
echo KHNjcmlwdE5hbWUgKyAiXCJodHRwOi8vc29tZWxpbmtcIiAgLW1ldGhvZCBQT1NU 
echo ICAgLWhlYWRlciBoZHJzLnR4dCAtcmVwb3J0ZmlsZSByZXBvcnRmaWxlMi50eHQg 
echo LXNhdmVUbyByZXNwb25zZWZpbGUyIC11YSBcIk1vemlsbGEvNS4wIChXaW5kb3dz 
echo IE5UIDYuMSkgQXBwbGVXZWJLaXQvNTM3LjM2IChLSFRNTCwgbGlrZSBHZWNrbykg 
echo Q2hyb21lLzQxLjAuMjIyOC4wIFNhZmFyaS81MzcuMzZcIiAgLWJvZHktZmlsZSBz 
echo b21lLmpzb24iKTsNCg0KfQ0KDQpmdW5jdGlvbiBwYXJzZUFyZ3MoKSB7DQogICAg 
echo Ly8gDQogICAgaWYgKEFSR1MuTGVuZ3RoIDwgMikgew0KICAgICAgICBXU2NyaXB0 
echo LkVjaG8oImluc3VmZmljaWVudCBhcmd1bWVudHMiKTsNCiAgICAgICAgcHJpbnRI 
echo ZWxwKCk7DQogICAgICAgIFdTY3JpcHQuUXVpdCg0Myk7DQogICAgfQ0KICAgIC8v 
echo ICEhISANCiAgICB1cmwgPSBBUkdTLkl0ZW0oMSk7DQogICAgLy8gISEhIA0KICAg 
echo IGlmIChBUkdTLkxlbmd0aCAlIDIgIT0gMCkgew0KICAgICAgICBXU2NyaXB0LkVj 
echo aG8oImlsbGVnYWwgYXJndW1lbnRzIik7DQogICAgICAgIHByaW50SGVscCgpOw0K 
echo ICAgICAgICBXU2NyaXB0LlF1aXQoNDQpOw0KICAgIH0NCg0KICAgIGZvciAodmFy 
echo IGkgPSAyOyBpIDwgQVJHUy5MZW5ndGggLSAxOyBpID0gaSArIDIpIHsNCiAgICAg 
echo ICAgdmFyIGFyZyA9IEFSR1MuSXRlbShpKS50b0xvd2VyQ2FzZSgpOw0KICAgICAg 
echo ICB2YXIgbmV4dCA9IEFSR1MuSXRlbShpICsgMSk7DQoNCg0KICAgICAgICB0cnkg 
echo ew0KICAgICAgICAgICAgc3dpdGNoIChhcmcpIHsgLy8gdGhlIHRyeS1jYXRjaCBp 
echo cyBzZXQgbWFpbmx5IGJlY2F1c2Ugb2YgdGhlIHBhcnNlSW50cyANCiAgICAgICAg 
echo ICAgICAgICBjYXNlICItZm9yY2UiOg0KICAgICAgICAgICAgICAgICAgICBpZiAo 
echo bmV4dCA9PSAibm8iKSB7DQogICAgICAgICAgICAgICAgICAgICAgICBmb3JjZSA9 
echo IGZhbHNlOw0KICAgICAgICAgICAgICAgICAgICB9DQogICAgICAgICAgICAgICAg 
echo ICAgIGJyZWFrOw0KICAgICAgICAgICAgICAgIGNhc2UgIi1lc2NhcGUiOg0KICAg 
echo ICAgICAgICAgICAgICAgICBpZiAobmV4dCA9PSAieWVzIikgew0KICAgICAgICAg 
echo ICAgICAgICAgICAgICAgZXNjYXBlID0gdHJ1ZTsNCiAgICAgICAgICAgICAgICAg 
echo ICAgfQ0KICAgICAgICAgICAgICAgICAgICBicmVhazsNCiAgICAgICAgICAgICAg 
echo ICBjYXNlICItc2F2ZXRvIjoNCiAgICAgICAgICAgICAgICAgICAgc2F2ZVRvID0g 
echo bmV4dDsNCiAgICAgICAgICAgICAgICAgICAgYnJlYWs7DQogICAgICAgICAgICAg 
echo ICAgY2FzZSAiLXVzZXIiOg0KICAgICAgICAgICAgICAgIGNhc2UgIi11IjoNCiAg 
echo ICAgICAgICAgICAgICAgICAgdXNlciA9IG5leHQ7DQogICAgICAgICAgICAgICAg 
echo ICAgIGJyZWFrOw0KICAgICAgICAgICAgICAgIGNhc2UgIi1wYXNzIjoNCiAgICAg 
echo ICAgICAgICAgICBjYXNlICItcGFzc3dvcmQiOg0KICAgICAgICAgICAgICAgIGNh 
echo c2UgIi1wIjoNCiAgICAgICAgICAgICAgICAgICAgcGFzcyA9IG5leHQ7DQogICAg 
echo ICAgICAgICAgICAgICAgIGJyZWFrOw0KICAgICAgICAgICAgICAgIGNhc2UgIi1w 
echo cm94eSI6DQogICAgICAgICAgICAgICAgICAgIHByb3h5ID0gbmV4dDsNCiAgICAg 
echo ICAgICAgICAgICAgICAgYnJlYWs7DQogICAgICAgICAgICAgICAgY2FzZSAiLWJ5 
echo cGFzcyI6DQogICAgICAgICAgICAgICAgICAgIGJ5cGFzcyA9IG5leHQ7DQogICAg 
echo ICAgICAgICAgICAgICAgIGJyZWFrOw0KICAgICAgICAgICAgICAgIGNhc2UgIi1w 
echo cm94eXVzZXIiOg0KICAgICAgICAgICAgICAgIGNhc2UgIi1wdSI6DQogICAgICAg 
echo ICAgICAgICAgICAgIHByb3h5X3VzZXIgPSBuZXh0Ow0KICAgICAgICAgICAgICAg 
echo ICAgICBicmVhazsNCiAgICAgICAgICAgICAgICBjYXNlICItcHJveHlwYXNzd29y 
echo ZCI6DQogICAgICAgICAgICAgICAgY2FzZSAiLXBwIjoNCiAgICAgICAgICAgICAg 
echo ICAgICAgcHJveHlfcGFzcyA9IG5leHQ7DQogICAgICAgICAgICAgICAgICAgIGJy 
echo ZWFrOw0KICAgICAgICAgICAgICAgIGNhc2UgIi11YSI6DQogICAgICAgICAgICAg 
echo ICAgICAgIHVhID0gbmV4dDsNCiAgICAgICAgICAgICAgICAgICAgYnJlYWs7DQog 
echo ICAgICAgICAgICAgICAgY2FzZSAiLXVhLWZpbGUiOg0KICAgICAgICAgICAgICAg 
echo ICAgICB1YSA9IHJlYWRGaWxlKG5leHQpOw0KICAgICAgICAgICAgICAgICAgICBi 
echo cmVhazsNCiAgICAgICAgICAgICAgICBjYXNlICItYm9keSI6DQogICAgICAgICAg 
echo ICAgICAgICAgIGJvZHkgPSBuZXh0Ow0KICAgICAgICAgICAgICAgICAgICBicmVh 
echo azsNCiAgICAgICAgICAgICAgICBjYXNlICItdXNlc3RyZWFtIjoNCiAgICAgICAg 
echo ICAgICAgICAgICAgLy9XU2NyaXB0LkVjaG8oIn5+Iik7IA0KICAgICAgICAgICAg 
echo ICAgICAgICBpZiAobmV4dC50b0xvd2VyQ2FzZSgpID09PSAieWVzIikgew0KICAg 
echo ICAgICAgICAgICAgICAgICAgICAgdXNlX3N0cmVhbSA9IHRydWUNCiAgICAgICAg 
echo ICAgICAgICAgICAgfTsNCiAgICAgICAgICAgICAgICAgICAgYnJlYWs7DQogICAg 
echo ICAgICAgICAgICAgY2FzZSAiLWJvZHktZmlsZSI6DQogICAgICAgICAgICAgICAg 
echo ICAgIGJvZHkgPSByZWFkRmlsZShuZXh0KTsNCiAgICAgICAgICAgICAgICAgICAg 
echo YnJlYWs7DQogICAgICAgICAgICAgICAgY2FzZSAiLWNlcnRpZmljYXRlIjoNCiAg 
echo ICAgICAgICAgICAgICAgICAgY2VydGlmaWNhdGUgPSBuZXh0Ow0KICAgICAgICAg 
echo ICAgICAgICAgICBicmVhazsNCiAgICAgICAgICAgICAgICBjYXNlICItbWV0aG9k 
echo IjoNCiAgICAgICAgICAgICAgICAgICAgc3dpdGNoIChuZXh0LnRvTG93ZXJDYXNl 
echo KCkpIHsNCiAgICAgICAgICAgICAgICAgICAgICAgIGNhc2UgInBvc3QiOg0KICAg 
echo ICAgICAgICAgICAgICAgICAgICAgICAgIGh0dHBfbWV0aG9kID0gJ1BPU1QnOw0K 
echo ICAgICAgICAgICAgICAgICAgICAgICAgICAgIGJyZWFrOw0KICAgICAgICAgICAg 
echo ICAgICAgICAgICAgY2FzZSAiZ2V0IjoNCiAgICAgICAgICAgICAgICAgICAgICAg 
echo ICAgICBodHRwX21ldGhvZCA9ICdHRVQnOw0KICAgICAgICAgICAgICAgICAgICAg 
echo ICAgICAgIGJyZWFrOw0KICAgICAgICAgICAgICAgICAgICAgICAgY2FzZSAiaGVh 
echo ZCI6DQogICAgICAgICAgICAgICAgICAgICAgICAgICAgaHR0cF9tZXRob2QgPSAn 
echo SEVBRCc7DQogICAgICAgICAgICAgICAgICAgICAgICAgICAgYnJlYWs7DQogICAg 
echo ICAgICAgICAgICAgICAgICAgICBjYXNlICJwdXQiOg0KICAgICAgICAgICAgICAg 
echo ICAgICAgICAgICAgIGh0dHBfbWV0aG9kID0gJ1BVVCc7DQogICAgICAgICAgICAg 
echo ICAgICAgICAgICAgICAgYnJlYWs7DQogICAgICAgICAgICAgICAgICAgICAgICBj 
echo YXNlICJvcHRpb25zIjoNCiAgICAgICAgICAgICAgICAgICAgICAgICAgICBodHRw 
echo X21ldGhvZCA9ICdPUFRJT05TJzsNCiAgICAgICAgICAgICAgICAgICAgICAgICAg 
echo ICBicmVhazsNCiAgICAgICAgICAgICAgICAgICAgICAgIGNhc2UgImNvbm5lY3Qi 
echo Og0KICAgICAgICAgICAgICAgICAgICAgICAgICAgIGh0dHBfbWV0aG9kID0gJ0NP 
echo Tk5FQ1QnOw0KICAgICAgICAgICAgICAgICAgICAgICAgICAgIGJyZWFrOw0KICAg 
echo ICAgICAgICAgICAgICAgICAgICAgY2FzZSAicGF0Y2giOg0KICAgICAgICAgICAg 
echo ICAgICAgICAgICAgICAgIGh0dHBfbWV0aG9kID0gJ1BBVENIJzsNCiAgICAgICAg 
echo ICAgICAgICAgICAgICAgICAgICBicmVhazsNCiAgICAgICAgICAgICAgICAgICAg 
echo ICAgIGNhc2UgImRlbGV0ZSI6DQogICAgICAgICAgICAgICAgICAgICAgICAgICAg 
echo aHR0cF9tZXRob2QgPSAnREVMRVRFJzsNCiAgICAgICAgICAgICAgICAgICAgICAg 
echo ICAgICBicmVhazsNCiAgICAgICAgICAgICAgICAgICAgICAgIGRlZmF1bHQ6DQog 
echo ICAgICAgICAgICAgICAgICAgICAgICAgICAgV1NjcmlwdC5FY2hvKCJJbnZhbGlk 
echo IGh0dHAgbWV0aG9kIHBhc3NlZCAiICsgbmV4dCk7DQogICAgICAgICAgICAgICAg 
echo ICAgICAgICAgICAgV1NjcmlwdC5FY2hvKCJwb3NzaWJsZSB2YWx1ZXMgYXJlIEdF 
echo VCxQT1NULERFTEVURSxQVVQsQ09OTkVDVCxQQVRDSCxIRUFELE9QVElPTlMiKTsN 
echo CiAgICAgICAgICAgICAgICAgICAgICAgICAgICBXU2NyaXB0LlF1aXQoMTMyNik7 
echo DQogICAgICAgICAgICAgICAgICAgICAgICAgICAgYnJlYWs7DQogICAgICAgICAg 
echo ICAgICAgICAgIH0NCiAgICAgICAgICAgICAgICAgICAgYnJlYWs7DQogICAgICAg 
echo ICAgICAgICAgY2FzZSAiLWhlYWRlcnMtZmlsZSI6DQogICAgICAgICAgICAgICAg 
echo Y2FzZSAiLWhlYWRlciI6DQogICAgICAgICAgICAgICAgICAgIGhlYWRlcnMgPSBy 
echo ZWFkUHJvcEZpbGUobmV4dCk7DQogICAgICAgICAgICAgICAgICAgIGJyZWFrOw0K 
echo ICAgICAgICAgICAgICAgIGNhc2UgIi1yZXBvcnRmaWxlIjoNCiAgICAgICAgICAg 
echo ICAgICAgICAgcmVwb3J0ZmlsZSA9IG5leHQ7DQogICAgICAgICAgICAgICAgICAg 
echo IGJyZWFrOw0KICAgICAgICAgICAgICAgICAgICAvL3RpbWVvdXRzIA0KICAgICAg 
echo ICAgICAgICAgIGNhc2UgIi1zZW5kdGltZW91dCI6DQogICAgICAgICAgICAgICAg 
echo ICAgIFNFTkRfVElNRU9VVCA9IHBhcnNlSW50KG5leHQpOw0KICAgICAgICAgICAg 
echo ICAgICAgICBicmVhazsNCiAgICAgICAgICAgICAgICBjYXNlICItY29ubmVjdHRp 
echo bWVvdXQiOg0KICAgICAgICAgICAgICAgICAgICBDT05ORUNUX1RJTUVPVVQgPSBw 
echo YXJzZWludChuZXh0KTsNCiAgICAgICAgICAgICAgICAgICAgYnJlYWs7DQogICAg 
echo ICAgICAgICAgICAgY2FzZSAiLXJlc29sdmV0aW1lb3V0IjoNCiAgICAgICAgICAg 
echo ICAgICAgICAgUkVTT0xWRV9USU1FT1VUID0gcGFyc2VJbnQobmV4dCk7DQogICAg 
echo ICAgICAgICAgICAgICAgIGJyZWFrOw0KICAgICAgICAgICAgICAgIGNhc2UgIi1y 
echo ZWNlaXZldGltZW91dCI6DQogICAgICAgICAgICAgICAgICAgIFJFQ0VJVkVfVElN 
echo RU9VVCA9IHBhcnNlSW50KG5leHQpOw0KICAgICAgICAgICAgICAgICAgICBicmVh 
echo azsNCg0KICAgICAgICAgICAgICAgIGNhc2UgIi1hdXRvbG9nb25wb2xpY3kiOg0K 
echo ICAgICAgICAgICAgICAgICAgICBhdXRvbG9nb25fcG9saWN5ID0gcGFyc2VJbnQo 
echo bmV4dCk7DQogICAgICAgICAgICAgICAgICAgIGlmIChhdXRvbG9nb25fcG9saWN5 
echo ID4gMiB8fCBhdXRvbG9nb25fcG9saWN5IDwgMCkgew0KICAgICAgICAgICAgICAg 
echo ICAgICAgICAgV1NjcmlwdC5FY2hvKCJvdXQgb2YgYXV0b2xvZ29uIHBvbGljeSBy 
echo YW5nZSIpOw0KICAgICAgICAgICAgICAgICAgICAgICAgV1NjcmlwdC5RdWl0KDg3 
echo KTsNCiAgICAgICAgICAgICAgICAgICAgfTsNCiAgICAgICAgICAgICAgICAgICAg 
echo YnJlYWs7DQogICAgICAgICAgICAgICAgY2FzZSAiLXByb3h5c2V0dGluZ3MiOg0K 
echo ICAgICAgICAgICAgICAgICAgICBwcm94eV9zZXR0aW5ncyA9IHBhcnNlSW50KG5l 
echo eHQpOw0KICAgICAgICAgICAgICAgICAgICBpZiAocHJveHlfc2V0dGluZ3MgPiAy 
echo IHx8IHByb3h5X3NldHRpbmdzIDwgMCkgew0KICAgICAgICAgICAgICAgICAgICAg 
echo ICAgV1NjcmlwdC5FY2hvKCJvdXQgb2YgcHJveHkgc2V0dGluZ3MgcmFuZ2UiKTsN 
echo CiAgICAgICAgICAgICAgICAgICAgICAgIFdTY3JpcHQuUXVpdCg4Nyk7DQogICAg 
echo ICAgICAgICAgICAgICAgIH07DQogICAgICAgICAgICAgICAgICAgIGJyZWFrOw0K 
echo ICAgICAgICAgICAgICAgIGRlZmF1bHQ6DQogICAgICAgICAgICAgICAgICAgIFdT 
echo Y3JpcHQuRWNobygiSW52YWxpZCAgY29tbWFuZCBsaW5lIHN3aXRjaDogIiArIGFy 
echo Zyk7DQogICAgICAgICAgICAgICAgICAgIFdTY3JpcHQuUXVpdCgxNDA1KTsNCiAg 
echo ICAgICAgICAgICAgICAgICAgYnJlYWs7DQogICAgICAgICAgICB9DQogICAgICAg 
echo IH0gY2F0Y2ggKGVycikgew0KICAgICAgICAgICAgV1NjcmlwdC5FY2hvKGVyci5t 
echo ZXNzYWdlKTsNCiAgICAgICAgICAgIFdTY3JpcHQuUXVpdCgxMzQ4KTsNCiAgICAg 
echo ICAgfQ0KICAgIH0NCn0NCg0Kc3RyaXBUcmFpbGluZ1NsYXNoID0gZnVuY3Rpb24o 
echo cGF0aCkgew0KICAgIHdoaWxlIChwYXRoLnN1YnN0cihwYXRoLmxlbmd0aCAtIDEs 
echo IHBhdGgubGVuZ3RoKSA9PSAnXFwnKSB7DQogICAgICAgIHBhdGggPSBwYXRoLnN1 
echo YnN0cigwLCBwYXRoLmxlbmd0aCAtIDEpOw0KICAgIH0NCiAgICByZXR1cm4gcGF0 
echo aDsNCn0NCg0KZnVuY3Rpb24gZXhpc3RzSXRlbShwYXRoKSB7DQogICAgcmV0dXJu 
echo IEZpbGVTeXN0ZW1PYmouRm9sZGVyRXhpc3RzKHBhdGgpIHx8IEZpbGVTeXN0ZW1P 
echo YmouRmlsZUV4aXN0cyhwYXRoKTsNCn0NCg0KZnVuY3Rpb24gZGVsZXRlSXRlbShw 
echo YXRoKSB7DQogICAgaWYgKEZpbGVTeXN0ZW1PYmouRmlsZUV4aXN0cyhwYXRoKSkg 
echo ew0KICAgICAgICBGaWxlU3lzdGVtT2JqLkRlbGV0ZUZpbGUocGF0aCk7DQogICAg 
echo ICAgIHJldHVybiB0cnVlOw0KICAgIH0gZWxzZSBpZiAoRmlsZVN5c3RlbU9iai5G 
echo b2xkZXJFeGlzdHMocGF0aCkpIHsNCiAgICAgICAgRmlsZVN5c3RlbU9iai5EZWxl 
echo dGVGb2xkZXIoc3RyaXBUcmFpbGluZ1NsYXNoKHBhdGgpKTsNCiAgICAgICAgcmV0 
echo dXJuIHRydWU7DQogICAgfSBlbHNlIHsNCiAgICAgICAgcmV0dXJuIGZhbHNlOw0K 
echo ICAgIH0NCn0NCg0KLy8tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIA0K 
echo Ly8tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIA0KLy8tLS0tLS0tLS0tIA0KLy8tLS0t 
echo LSANCi8vLS0gDQpmdW5jdGlvbiByZXF1ZXN0KHVybCkgew0KDQogICAgdHJ5IHsN 
echo Cg0KICAgICAgICBXaW5IVFRQT2JqLk9wZW4oaHR0cF9tZXRob2QsIHVybCwgZmFs 
echo c2UpOw0KICAgICAgICBpZiAocHJveHkgIT0gMCAmJiBieXBhc3MgIT0gMCkgew0K 
echo ICAgICAgICAgICAgV2luSFRUUE9iai5TZXRQcm94eShwcm94eV9zZXR0aW5ncywg 
echo cHJveHksIGJ5cGFzcyk7DQogICAgICAgIH0NCg0KICAgICAgICBpZiAocHJveHkg 
echo IT0gMCkgew0KICAgICAgICAgICAgV2luSFRUUE9iai5TZXRQcm94eShwcm94eV9z 
echo ZXR0aW5ncywgcHJveHkpOw0KICAgICAgICB9DQoNCiAgICAgICAgaWYgKHVzZXIg 
echo IT0gMCAmJiBwYXNzICE9IDApIHsNCiAgICAgICAgICAgIFdpbkhUVFBPYmouU2V0 
echo Q3JlZGVudGlhbHModXNlciwgcGFzcywgSFRUUFJFUVVFU1RfU0VUQ1JFREVOVElB 
echo TFNfRk9SX1NFUlZFUik7DQogICAgICAgIH0NCg0KICAgICAgICBpZiAocHJveHlf 
echo dXNlciAhPSAwICYmIHByb3h5X3Bhc3MgIT0gMCkgew0KICAgICAgICAgICAgV2lu 
echo SFRUUE9iai5TZXRDcmVkZW50aWFscyhwcm94eV91c2VyLCBwcm94eV9wYXNzLCBI 
echo VFRQUkVRVUVTVF9TRVRDUkVERU5USUFMU19GT1JfUFJPWFkpOw0KICAgICAgICB9 
echo DQoNCiAgICAgICAgaWYgKGNlcnRpZmljYXRlICE9IDApIHsNCiAgICAgICAgICAg 
echo IFdpbkhUVFBPYmouU2V0Q2xpZW50Q2VydGlmaWNhdGUoY2VydGlmaWNhdGUpOw0K 
echo ICAgICAgICB9DQoNCiAgICAgICAgLy9zZXQgYXV0b2xvZ2luIHBvbGljeSANCiAg 
echo ICAgICAgV2luSFRUUE9iai5TZXRBdXRvTG9nb25Qb2xpY3koYXV0b2xvZ29uX3Bv 
echo bGljeSk7DQogICAgICAgIC8vc2V0IHRpbWVvdXRzIA0KICAgICAgICBXaW5IVFRQ 
echo T2JqLlNldFRpbWVvdXRzKFJFU09MVkVfVElNRU9VVCwgQ09OTkVDVF9USU1FT1VU 
echo LCBTRU5EX1RJTUVPVVQsIFJFQ0VJVkVfVElNRU9VVCk7DQoNCiAgICAgICAgaWYg 
echo KGhlYWRlcnMubGVuZ3RoICE9PSAwKSB7DQogICAgICAgICAgICBXU2NyaXB0LkVj 
echo aG8oIlNlbmRpbmcgd2l0aCBoZWFkZXJzOiIpOw0KICAgICAgICAgICAgZm9yICh2 
echo YXIgaSA9IDA7IGkgPCBoZWFkZXJzLmxlbmd0aDsgaSsrKSB7DQogICAgICAgICAg 
echo ICAgICAgV2luSFRUUE9iai5TZXRSZXF1ZXN0SGVhZGVyKGhlYWRlcnNbaV1bMF0s 
echo IGhlYWRlcnNbaV1bMV0pOw0KICAgICAgICAgICAgICAgIFdTY3JpcHQuRWNobyho 
echo ZWFkZXJzW2ldWzBdICsgIjoiICsgaGVhZGVyc1tpXVsxXSk7DQogICAgICAgICAg 
echo ICB9DQogICAgICAgICAgICBXU2NyaXB0LkVjaG8oIiIpOw0KICAgICAgICB9DQoN 
echo CiAgICAgICAgaWYgKHVhICE9PSAiIikgew0KICAgICAgICAgICAgLy91c2VyLWFn 
echo ZW50IG9wdGlvbiBmcm9tOiANCiAgICAgICAgICAgIC8vV2luSHR0cFJlcXVlc3RP 
echo cHRpb24gZW51bWVyYXRpb24gDQogICAgICAgICAgICAvLyBvdGhlciBvcHRpb25z 
echo IGNhbiBiZSBhZGRlZCBsaWtlIGJlbGxvdyANCiAgICAgICAgICAgIC8vaHR0cHM6 
echo Ly9tc2RuLm1pY3Jvc29mdC5jb20vZW4tdXMvbGlicmFyeS93aW5kb3dzL2Rlc2t0 
echo b3AvYWEzODQxMDgodj12cy44NSkuYXNweCANCiAgICAgICAgICAgIFdpbkhUVFBP 
echo YmouT3B0aW9uKDApID0gdWE7DQogICAgICAgIH0NCiAgICAgICAgaWYgKGVzY2Fw 
echo ZSkgew0KICAgICAgICAgICAgV2luSFRUUE9iai5PcHRpb24oMykgPSB0cnVlOw0K 
echo ICAgICAgICB9DQogICAgICAgIGlmICh0cmltKGJvZHkpID09PSAiIikgew0KICAg 
echo ICAgICAgICAgV2luSFRUUE9iai5TZW5kKCk7DQogICAgICAgIH0gZWxzZSB7DQog 
echo ICAgICAgICAgICBXaW5IVFRQT2JqLlNlbmQoYm9keSk7DQogICAgICAgIH0NCg0K 
echo ICAgICAgICB2YXIgc3RhdHVzID0gV2luSFRUUE9iai5TdGF0dXMNCiAgICB9IGNh 
echo dGNoIChlcnIpIHsNCiAgICAgICAgV1NjcmlwdC5FY2hvKGVyci5tZXNzYWdlKTsN 
echo CiAgICAgICAgV1NjcmlwdC5RdWl0KDY2Nik7DQogICAgfQ0KDQogICAgLy8vLy8v 
echo Ly8vLy8vLy8vLy8vLy8vLy8vIA0KICAgIC8vICAgICByZXBvcnQgICAgICAgICAv 
echo LyANCiAgICAvLy8vLy8vLy8vLy8vLy8vLy8vLy8vLy8gDQoNCiAgICBpZiAocmVw 
echo b3J0ZmlsZSAhPSAiIikgew0KDQogICAgICAgIC8vdmFyIHJlcG9ydF9zdHJpbmc9 
echo IiI7IA0KICAgICAgICB2YXIgbiA9ICJcclxuIjsNCiAgICAgICAgdmFyIHJlcG9y 
echo dF9zdHJpbmcgPSAiU3RhdHVzOiIgKyBuOw0KICAgICAgICByZXBvcnRfc3RyaW5n 
echo ID0gcmVwb3J0X3N0cmluZyArICIgICAgICAiICsgV2luSFRUUE9iai5TdGF0dXM7 
echo DQogICAgICAgIHJlcG9ydF9zdHJpbmcgPSByZXBvcnRfc3RyaW5nICsgIiAgICAg 
echo ICIgKyBXaW5IVFRQT2JqLlN0YXR1c1RleHQgKyBuOw0KICAgICAgICByZXBvcnRf 
echo c3RyaW5nID0gcmVwb3J0X3N0cmluZyArICIgICAgICAiICsgbjsNCiAgICAgICAg 
echo cmVwb3J0X3N0cmluZyA9IHJlcG9ydF9zdHJpbmcgKyAiUmVzcG9uc2U6IiArIG47 
echo DQogICAgICAgIHJlcG9ydF9zdHJpbmcgPSByZXBvcnRfc3RyaW5nICsgV2luSFRU 
echo UE9iai5SZXNwb25zZVRleHQgKyBuOw0KICAgICAgICByZXBvcnRfc3RyaW5nID0g 
echo cmVwb3J0X3N0cmluZyArICIgICAgICAiICsgbjsNCiAgICAgICAgcmVwb3J0X3N0 
echo cmluZyA9IHJlcG9ydF9zdHJpbmcgKyAiSGVhZGVyczoiICsgbjsNCiAgICAgICAg 
echo cmVwb3J0X3N0cmluZyA9IHJlcG9ydF9zdHJpbmcgKyBXaW5IVFRQT2JqLkdldEFs 
echo bFJlc3BvbnNlSGVhZGVycygpICsgbjsNCg0KICAgICAgICBXaW5IdHRwUmVxdWVz 
echo dE9wdGlvbl9Vc2VyQWdlbnRTdHJpbmcgPSAwOyAvLyBOYW1lIG9mIHRoZSB1c2Vy 
echo IGFnZW50IA0KICAgICAgICBXaW5IdHRwUmVxdWVzdE9wdGlvbl9VUkwgPSAxOyAv 
echo LyBDdXJyZW50IFVSTCANCiAgICAgICAgV2luSHR0cFJlcXVlc3RPcHRpb25fVVJM 
echo Q29kZVBhZ2UgPSAyOyAvLyBDb2RlIHBhZ2UgDQogICAgICAgIFdpbkh0dHBSZXF1 
echo ZXN0T3B0aW9uX0VzY2FwZVBlcmNlbnRJblVSTCA9IDM7IC8vIENvbnZlcnQgcGVy 
echo Y2VudHMgDQogICAgICAgIC8vIGluIHRoZSBVUkwgDQogICAgICAgIC8vIHJlc3Qg 
echo b2YgdGhlIG9wdGlvbnMgY2FuIGJlIHNlZW4gYW5kIGV2ZW50dWFsbHkgYWRkZWQg 
echo dXNpbmcgdGhpcyBhcyByZWZlcmVuY2UgDQogICAgICAgIC8vIGh0dHBzOi8vbXNk 
echo bi5taWNyb3NvZnQuY29tL2VuLXVzL2xpYnJhcnkvd2luZG93cy9kZXNrdG9wL2Fh 
echo Mzg0MTA4KHY9dnMuODUpLmFzcHggDQoNCiAgICAgICAgcmVwb3J0X3N0cmluZyA9 
echo IHJlcG9ydF9zdHJpbmcgKyAiVVJMOiIgKyBuOw0KICAgICAgICByZXBvcnRfc3Ry 
echo aW5nID0gcmVwb3J0X3N0cmluZyArIFdpbkhUVFBPYmouT3B0aW9uKFdpbkh0dHBS 
echo ZXF1ZXN0T3B0aW9uX1VSTCkgKyBuOw0KDQogICAgICAgIHJlcG9ydF9zdHJpbmcg 
echo PSByZXBvcnRfc3RyaW5nICsgIlVSTCBDb2RlIFBhZ2U6IiArIG47DQogICAgICAg 
echo IHJlcG9ydF9zdHJpbmcgPSByZXBvcnRfc3RyaW5nICsgV2luSFRUUE9iai5PcHRp 
echo b24oV2luSHR0cFJlcXVlc3RPcHRpb25fVVJMQ29kZVBhZ2UpICsgbjsNCg0KICAg 
echo ICAgICByZXBvcnRfc3RyaW5nID0gcmVwb3J0X3N0cmluZyArICJVc2VyIEFnZW50 
echo OiIgKyBuOw0KICAgICAgICByZXBvcnRfc3RyaW5nID0gcmVwb3J0X3N0cmluZyAr 
echo IFdpbkhUVFBPYmouT3B0aW9uKFdpbkh0dHBSZXF1ZXN0T3B0aW9uX1VzZXJBZ2Vu 
echo dFN0cmluZykgKyBuOw0KDQogICAgICAgIHJlcG9ydF9zdHJpbmcgPSByZXBvcnRf 
echo c3RyaW5nICsgIkVzY2FwcGVkIFVSTDoiICsgbjsNCiAgICAgICAgcmVwb3J0X3N0 
echo cmluZyA9IHJlcG9ydF9zdHJpbmcgKyBXaW5IVFRQT2JqLk9wdGlvbihXaW5IdHRw 
echo UmVxdWVzdE9wdGlvbl9Fc2NhcGVQZXJjZW50SW5VUkwpICsgbjsNCg0KICAgICAg 
echo ICBwcmVwYXJlYXRlRmlsZShmb3JjZSwgcmVwb3J0ZmlsZSk7DQoNCiAgICAgICAg 
echo V1NjcmlwdC5FY2hvKCJXcml0aW5nIHJlcG9ydCB0byAiICsgcmVwb3J0ZmlsZSk7 
echo DQoNCiAgICAgICAgd3JpdGVGaWxlKHJlcG9ydGZpbGUsIHJlcG9ydF9zdHJpbmcp 
echo Ow0KDQogICAgfQ0KDQogICAgc3dpdGNoIChzdGF0dXMpIHsNCiAgICAgICAgY2Fz 
echo ZSAyMDA6DQogICAgICAgICAgICBXU2NyaXB0LkVjaG8oIlN0YXR1czogMjAwIE9L 
echo Iik7DQogICAgICAgICAgICBicmVhazsNCiAgICAgICAgZGVmYXVsdDoNCiAgICAg 
echo ICAgICAgIFdTY3JpcHQuRWNobygiU3RhdHVzOiAiICsgc3RhdHVzKTsNCiAgICAg 
echo ICAgICAgIFdTY3JpcHQuRWNobygiU3RhdHVzIHdhcyBub3QgT0suIE1vcmUgaW5m 
echo byAtPiBodHRwczovL2VuLndpa2lwZWRpYS5vcmcvd2lraS9MaXN0X29mX0hUVFBf 
echo c3RhdHVzX2NvZGVzIik7DQogICAgfQ0KDQogICAgLy9pZiBhcyBiaW5hcnkgDQog 
echo ICAgaWYgKHNhdmVUby50b0xvd2VyQ2FzZSgpID09PSAiY29uIikgew0KICAgICAg 
echo ICBXU2NyaXB0LkVjaG8oV2luSFRUUE9iai5SZXNwb25zZVRleHQpOw0KICAgIH0N 
echo CiAgICBpZiAoc2F2ZVRvICE9PSAiIiAmJiBzYXZlVG8udG9Mb3dlckNhc2UoKSAh 
echo PT0gImNvbiIpIHsNCiAgICAgICAgcHJlcGFyZWF0ZUZpbGUoZm9yY2UsIHNhdmVU 
echo byk7DQogICAgICAgIHRyeSB7DQoNCiAgICAgICAgICAgIGlmICh1c2Vfc3RyZWFt 
echo KSB7DQogICAgICAgICAgICAgICAgd3JpdGVCaW5GaWxlKHNhdmVUbywgV2luSFRU 
echo UE9iai5SZXNwb25zZVN0cmVhbSk7DQogICAgICAgICAgICB9IGVsc2Ugew0KICAg 
echo ICAgICAgICAgICAgIHdyaXRlQmluRmlsZShzYXZlVG8sIFdpbkhUVFBPYmouUmVz 
echo cG9uc2VCb2R5KTsNCiAgICAgICAgICAgIH0NCg0KICAgICAgICB9IGNhdGNoIChl 
echo cnIpIHsNCiAgICAgICAgICAgIFdTY3JpcHQuRWNobygiRmFpbGVkIHRvIHNhdmUg 
echo dGhlIGZpbGUgYXMgYmluYXJ5LkF0dGVtcHQgdG8gc2F2ZSBpdCBhcyB0ZXh0Iik7 
echo DQogICAgICAgICAgICBBZG9EQk9iai5DbG9zZSgpOw0KICAgICAgICAgICAgcHJl 
echo cGFyZWF0ZUZpbGUodHJ1ZSwgc2F2ZVRvKTsNCiAgICAgICAgICAgIHdyaXRlRmls 
echo ZShzYXZlVG8sIFdpbkhUVFBPYmouUmVzcG9uc2VUZXh0KTsNCiAgICAgICAgfQ0K 
echo ICAgIH0NCiAgICBXU2NyaXB0LlF1aXQoc3RhdHVzKTsNCn0NCg0KLy8tLSANCi8v 
echo LS0tLS0gDQovLy0tLS0tLS0tLS0gDQovLy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0g 
echo DQovLy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0gDQoNCmZ1bmN0aW9u 
echo IHByZXBhcmVhdGVGaWxlKGZvcmNlLCBmaWxlKSB7DQogICAgaWYgKGZvcmNlICYm 
echo IGV4aXN0c0l0ZW0oZmlsZSkpIHsNCiAgICAgICAgaWYgKCFkZWxldGVJdGVtKGZp 
echo bGUpKSB7DQogICAgICAgICAgICBXU2NyaXB0LkVjaG8oIlVuYWJsZSB0byBkZWxl 
echo dGUgIiArIGZpbGUpOw0KICAgICAgICAgICAgV1NjcmlwdC5RdWl0KDgpOw0KICAg 
echo ICAgICB9DQogICAgfSBlbHNlIGlmIChleGlzdHNJdGVtKGZpbGUpKSB7DQogICAg 
echo ICAgIFdTY3JpcHQuRWNobygiSXRlbSAiICsgZmlsZSArICIgYWxyZWFkeSBleGlz 
echo dCIpOw0KICAgICAgICBXU2NyaXB0LlF1aXQoOSk7DQogICAgfQ0KfQ0KDQpmdW5j 
echo dGlvbiB3cml0ZUJpbkZpbGUoZmlsZU5hbWUsIGRhdGEpIHsNCiAgICBBZG9EQk9i 
echo ai5UeXBlID0gMTsNCiAgICBBZG9EQk9iai5PcGVuKCk7DQogICAgQWRvREJPYmou 
echo UG9zaXRpb24gPSAwOw0KICAgIEFkb0RCT2JqLldyaXRlKGRhdGEpOw0KICAgIEFk 
echo b0RCT2JqLlNhdmVUb0ZpbGUoZmlsZU5hbWUsIDIpOw0KICAgIEFkb0RCT2JqLkNs 
echo b3NlKCk7DQp9DQoNCmZ1bmN0aW9uIHdyaXRlRmlsZShmaWxlTmFtZSwgZGF0YSkg 
echo ew0KICAgIEFkb0RCT2JqLlR5cGUgPSAyOw0KICAgIEFkb0RCT2JqLkNoYXJTZXQg 
echo PSAiaXNvLTg4NTktMSI7DQogICAgQWRvREJPYmouT3BlbigpOw0KICAgIEFkb0RC 
echo T2JqLlBvc2l0aW9uID0gMDsNCiAgICBBZG9EQk9iai5Xcml0ZVRleHQoZGF0YSk7 
echo DQogICAgQWRvREJPYmouU2F2ZVRvRmlsZShmaWxlTmFtZSwgMik7DQogICAgQWRv 
echo REJPYmouQ2xvc2UoKTsNCn0NCg0KDQpmdW5jdGlvbiByZWFkRmlsZShmaWxlTmFt 
echo ZSkgew0KICAgIC8vY2hlY2sgZXhpc3RlbmNlIA0KICAgIHRyeSB7DQogICAgICAg 
echo IGlmICghRmlsZVN5c3RlbU9iai5GaWxlRXhpc3RzKGZpbGVOYW1lKSkgew0KICAg 
echo ICAgICAgICAgV1NjcmlwdC5FY2hvKCJmaWxlICIgKyBmaWxlTmFtZSArICIgZG9l 
echo cyBub3QgZXhpc3QhIik7DQogICAgICAgICAgICBXU2NyaXB0LlF1aXQoMTMpOw0K 
echo ICAgICAgICB9DQogICAgICAgIGlmIChGaWxlU3lzdGVtT2JqLkdldEZpbGUoZmls 
echo ZU5hbWUpLlNpemUgPT09IDApIHsNCiAgICAgICAgICAgIHJldHVybiAiIjsNCiAg 
echo ICAgICAgfQ0KICAgICAgICB2YXIgZmlsZVIgPSBGaWxlU3lzdGVtT2JqLk9wZW5U 
echo ZXh0RmlsZShmaWxlTmFtZSwgMSk7DQogICAgICAgIHZhciBjb250ZW50ID0gZmls 
echo ZVIuUmVhZEFsbCgpOw0KICAgICAgICBmaWxlUi5DbG9zZSgpOw0KICAgICAgICBy 
echo ZXR1cm4gY29udGVudDsNCiAgICB9IGNhdGNoIChlcnIpIHsNCiAgICAgICAgV1Nj 
echo cmlwdC5FY2hvKCJFcnJvciB3aGlsZSByZWFkaW5nIGZpbGU6ICIgKyBmaWxlTmFt 
echo ZSk7DQogICAgICAgIFdTY3JpcHQuRWNobyhlcnIubWVzc2FnZSk7DQogICAgICAg 
echo IFdTY3JpcHQuRWNobygiV2lsbCByZXR1cm4gZW1wdHkgc3RyaW5nIik7DQogICAg 
echo ICAgIHJldHVybiAiIjsNCiAgICB9DQp9DQoNCmZ1bmN0aW9uIHJlYWRQcm9wRmls 
echo ZShmaWxlTmFtZSkgew0KICAgIC8vY2hlY2sgZXhpc3RlbmNlIA0KICAgIHJlc3Vs 
echo dEFycmF5ID0gW107DQogICAgaWYgKCFGaWxlU3lzdGVtT2JqLkZpbGVFeGlzdHMo 
echo ZmlsZU5hbWUpKSB7DQogICAgICAgIFdTY3JpcHQuRWNobygiKGhlYWRlcnMpZmls 
echo ZSAiICsgZmlsZU5hbWUgKyAiIGRvZXMgbm90IGV4aXN0ISIpOw0KICAgICAgICBX 
echo U2NyaXB0LlF1aXQoMTUpOw0KICAgIH0NCiAgICBpZiAoRmlsZVN5c3RlbU9iai5H 
echo ZXRGaWxlKGZpbGVOYW1lKS5TaXplID09PSAwKSB7DQogICAgICAgIHJldHVybiBy 
echo ZXN1bHRBcnJheTsNCiAgICB9DQogICAgdmFyIGZpbGVSID0gRmlsZVN5c3RlbU9i 
echo ai5PcGVuVGV4dEZpbGUoZmlsZU5hbWUsIDEpOw0KICAgIHZhciBsaW5lID0gIiI7 
echo DQogICAgdmFyIGsgPSAiIjsNCiAgICB2YXIgdiA9ICIiOw0KICAgIHZhciBsaW5l 
echo TiA9IDA7DQogICAgdmFyIGluZGV4ID0gMDsNCiAgICB0cnkgew0KICAgICAgICBX 
echo U2NyaXB0LkVjaG8oInBhcnNpbmcgaGVhZGVycyBmb3JtICIgKyBmaWxlTmFtZSAr 
echo ICIgcHJvcGVydHkgZmlsZSAiKTsNCiAgICAgICAgd2hpbGUgKCFmaWxlUi5BdEVu 
echo ZE9mU3RyZWFtKSB7DQogICAgICAgICAgICBsaW5lID0gZmlsZVIuUmVhZExpbmUo 
echo KTsNCiAgICAgICAgICAgIGxpbmVOKys7DQogICAgICAgICAgICBpbmRleCA9IGxp 
echo bmUuaW5kZXhPZigiOiIpOw0KICAgICAgICAgICAgaWYgKGxpbmUuaW5kZXhPZigi 
echo IyIpID09PSAwIHx8IHRyaW0obGluZSkgPT09ICIiKSB7DQogICAgICAgICAgICAg 
echo ICAgY29udGludWU7DQogICAgICAgICAgICB9DQogICAgICAgICAgICBpZiAoaW5k 
echo ZXggPT09IC0xIHx8IGluZGV4ID09PSBsaW5lLmxlbmd0aCAtIDEgfHwgaW5kZXgg 
echo PT09IDApIHsNCiAgICAgICAgICAgICAgICBXU2NyaXB0LkVjaG8oIkludmFsaWQg 
echo bGluZSAiICsgbGluZU4pOw0KICAgICAgICAgICAgICAgIFdTY3JpcHQuUXVpdCg5 
echo Myk7DQogICAgICAgICAgICB9DQogICAgICAgICAgICBrID0gdHJpbShsaW5lLnN1 
echo YnN0cmluZygwLCBpbmRleCkpOw0KICAgICAgICAgICAgdiA9IHRyaW0obGluZS5z 
echo dWJzdHJpbmcoaW5kZXggKyAxLCBsaW5lLmxlbmd0aCkpOw0KICAgICAgICAgICAg 
echo cmVzdWx0QXJyYXkucHVzaChbaywgdl0pOw0KICAgICAgICB9DQogICAgICAgIGZp 
echo bGVSLkNsb3NlKCk7DQogICAgICAgIHJldHVybiByZXN1bHRBcnJheTsNCiAgICB9 
echo IGNhdGNoIChlcnIpIHsNCiAgICAgICAgV1NjcmlwdC5FY2hvKCJFcnJvciB3aGls 
echo ZSByZWFkaW5nIGhlYWRlcnMgZmlsZTogIiArIGZpbGVOYW1lKTsNCiAgICAgICAg 
echo V1NjcmlwdC5FY2hvKGVyci5tZXNzYWdlKTsNCiAgICAgICAgV1NjcmlwdC5FY2hv 
echo KCJXaWxsIHJldHVybiBlbXB0eSBhcnJheSIpOw0KICAgICAgICByZXR1cm4gcmVz 
echo dWx0QXJyYXk7DQogICAgfQ0KfQ0KDQpmdW5jdGlvbiB0cmltKHN0cikgew0KICAg 
echo IHJldHVybiBzdHIucmVwbGFjZSgvXlxzKy8sICcnKS5yZXBsYWNlKC9ccyskLywg 
echo JycpOw0KfQ0KDQpmdW5jdGlvbiBtYWluKCkgew0KICAgIHBhcnNlQXJncygpOw0K 
echo ICAgIHJlcXVlc3QodXJsKTsNCn0NCm1haW4oKTsNCg== 
echo -----END CERTIFICATE----- 
)>>temp.txt 
certutil -decode "temp.txt" "winhttpjs.bat" >nul 
del /f /q "temp.txt" 
:12093163769741218092587122853 
exit /b

