#!/bin/bash

# ========================================
# Depth Estimation Viewer - Auto Launcher
# ========================================

echo ""
echo "========================================"
echo " Depth Estimation Viewer 실행 중..."
echo "========================================"
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Check if Python is installed
if ! command -v python3 &> /dev/null && ! command -v python &> /dev/null; then
    echo -e "${RED}[오류] Python이 설치되어 있지 않습니다.${NC}"
    echo ""
    echo "Python 설치 방법:"
    echo "  macOS: brew install python3"
    echo "  Ubuntu/Debian: sudo apt-get install python3"
    echo "  Fedora: sudo dnf install python3"
    echo ""
    exit 1
fi

# Use python3 if available, otherwise python
PYTHON_CMD="python3"
if ! command -v python3 &> /dev/null; then
    PYTHON_CMD="python"
fi

echo -e "${GREEN}[1/3] HTTP 서버 시작 중...${NC}"
echo ""
echo "서버 주소: http://localhost:8000"
echo "파일 위치: $SCRIPT_DIR"
echo ""

# Kill any existing server on port 8000
lsof -ti:8000 | xargs kill -9 2>/dev/null

# Start Python HTTP server in background
$PYTHON_CMD -m http.server 8000 > /dev/null 2>&1 &
SERVER_PID=$!

# Wait for server to start
sleep 2

echo -e "${GREEN}[2/3] 브라우저 열기 중...${NC}"
echo ""

# Open browser based on OS
URL="http://localhost:8000/depth-estimation-viewer.html"

if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    open "$URL"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    if command -v xdg-open &> /dev/null; then
        xdg-open "$URL"
    elif command -v gnome-open &> /dev/null; then
        gnome-open "$URL"
    else
        echo -e "${YELLOW}브라우저를 자동으로 열 수 없습니다.${NC}"
        echo "수동으로 브라우저에서 다음 주소를 열어주세요:"
        echo "$URL"
    fi
else
    echo -e "${YELLOW}알 수 없는 운영체제입니다.${NC}"
    echo "브라우저에서 다음 주소를 열어주세요:"
    echo "$URL"
fi

echo -e "${GREEN}[3/3] 완료!${NC}"
echo ""
echo "========================================"
echo " 실행 완료"
echo "========================================"
echo ""
echo "브라우저에서 애플리케이션이 열렸습니다."
echo ""
echo -e "${YELLOW}[중요] 서버 종료: Ctrl+C를 누르세요${NC}"
echo ""
echo "========================================"
echo ""

# Function to cleanup on exit
cleanup() {
    echo ""
    echo "서버를 종료하는 중..."
    kill $SERVER_PID 2>/dev/null
    echo "종료되었습니다."
    exit 0
}

# Set trap to cleanup on Ctrl+C
trap cleanup INT TERM

echo "서버 실행 중... (Ctrl+C를 눌러 종료)"
echo ""

# Keep script running
wait $SERVER_PID
