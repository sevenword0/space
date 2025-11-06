@echo off
REM ========================================
REM Depth Estimation Viewer - Auto Launcher
REM ========================================

echo.
echo ========================================
echo  Depth Estimation Viewer 실행 중...
echo ========================================
echo.

REM Check if Python is installed
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [오류] Python이 설치되어 있지 않습니다.
    echo.
    echo Python 설치 방법:
    echo 1. https://www.python.org/downloads/ 방문
    echo 2. Python 다운로드 및 설치
    echo 3. 설치 시 "Add Python to PATH" 체크
    echo.
    pause
    exit /b 1
)

REM Get script directory
set "SCRIPT_DIR=%~dp0"
cd /d "%SCRIPT_DIR%"

echo [1/3] HTTP 서버 시작 중...
echo.
echo 서버 주소: http://localhost:8000
echo 파일 위치: %SCRIPT_DIR%
echo.

REM Start Python HTTP server in background
start /B python -m http.server 8000 >nul 2>&1

REM Wait for server to start
timeout /t 2 /nobreak >nul

echo [2/3] 브라우저 열기 중...
echo.

REM Open browser
start http://localhost:8000/depth-estimation-viewer.html

echo [3/3] 완료!
echo.
echo ========================================
echo  실행 완료
echo ========================================
echo.
echo 브라우저에서 애플리케이션이 열렸습니다.
echo.
echo [중요] 이 창을 닫으면 서버가 종료됩니다.
echo 사용이 끝나면 이 창을 닫아주세요.
echo.
echo ========================================
echo.

REM Keep server running
echo 서버 실행 중... (Ctrl+C를 눌러 종료)
echo.
python -m http.server 8000

pause
