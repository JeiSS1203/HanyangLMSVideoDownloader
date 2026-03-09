@echo off
chcp 65001 >nul

>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

if '%errorlevel%' NEQ '0' (

    echo 관리 권한을 요청 ...

    goto UACPrompt

) else ( goto gotAdmin )

:UACPrompt

    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"

    set params = %*:"=""

    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"



    "%temp%\getadmin.vbs"

    rem del "%temp%\getadmin.vbs"

    exit /B



:gotAdmin

pushd "%CD%"

net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] 관리자 권한으로 실행해야 합니다.
    pause
    exit /b
)

::--------------------------------------------
:: 1) 배치 파일 위치로 이동
::--------------------------------------------
cd /d %~dp0

::--------------------------------------------
:: 2) 사용자로부터 Chrome 확장 ID 입력
::--------------------------------------------
set /p EXT_ID=Chrome Extension ID를 입력하세요 (예: abcdefghijklmnopabcdef...): 
::set "EXT_ID=eckiakojbfplibfdddblfgembodbgfkl"
::--------------------------------------------
:: 3) 경로 변수 설정
::--------------------------------------------
set "TARGET_DIR=C:\Program Files\HanyangDownloader"
set "SOURCE_EXE=dist\downloader.exe"
set "MANIFEST_NAME=com.hanyang.ffmpeg_downloader.json"
set "MANIFEST_PATH=%TARGET_DIR%\%MANIFEST_NAME%"

::--------------------------------------------
:: 4) exe 설치 폴더 생성 및 복사
::--------------------------------------------
echo [INFO] HanyangDownloader 폴더 생성 중...
mkdir "%TARGET_DIR%" 2>nul

echo [INFO] downloader.exe 복사 중...
copy /Y "%SOURCE_EXE%" "%TARGET_DIR%" >nul

::--------------------------------------------
:: 5) 매니페스트 JSON 생성 (exe 폴더 바로 아래)
::--------------------------------------------
echo [INFO] Native host manifest 생성 중...
(
  echo {
  echo   "name": "com.hanyang.ffmpeg_downloader",
  echo   "description": "Downloads video from Hanyang LMS",
  echo   "path": "C:\\Program Files\\HanyangDownloader\\downloader.exe",
  echo   "type": "stdio",
  echo   "allowed_origins": [
  echo     "chrome-extension://%EXT_ID%/"
  echo   ]
  echo }
) > "%MANIFEST_PATH%"

::--------------------------------------------
:: 6) 레지스트리에 네이티브 호스트 등록 (HKCU)
::--------------------------------------------
echo [INFO] 레지스트리에 네이티브 호스트 등록 중...
:: reg add "HKCU\Software\Google\Chrome\NativeMessagingHosts\com.hanyang.ffmpeg_downloader" ^
    /ve /t REG_SZ /d "%MANIFEST_PATH%" /f >nul

:: (모든 사용자 대상하려면 아래 줄을 사용할 수 있습니다)
reg add "HKLM\Software\Google\Chrome\NativeMessagingHosts\com.hanyang.ffmpeg_downloader" /ve /t REG_SZ /d "%MANIFEST_PATH%" /f >nul

::--------------------------------------------
:: 완료 메시지
::--------------------------------------------
echo.
echo [SUCCESS] 설치 및 등록이 모두 완료되었습니다!
echo   - downloader.exe 위치: %TARGET_DIR%
echo   - manifest 위치:        %MANIFEST_PATH%
echo   - 레지스트리 등록 키:   HKCU\Software\Google\Chrome\NativeMessagingHosts\com.hanyang.ffmpeg_downloader
pause

