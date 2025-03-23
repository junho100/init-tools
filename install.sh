#!/bin/bash

# 색상 정의
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# 실행 권한 부여
chmod +x install_deps.sh setup_terminal.sh config.sh

echo -e "${BLUE}[INFO]${NC} Mac 초기 설정 자동화 도구"
echo -e "${BLUE}[INFO]${NC} 이 도구는 두 단계로 나누어 실행됩니다:"
echo -e "${BLUE}[INFO]${NC} 1. 애플리케이션 설치 (install_deps.sh)"
echo -e "${BLUE}[INFO]${NC} 2. 터미널 설정 (setup_terminal.sh)"
echo ""
echo -e "${YELLOW}[선택]${NC} 어떤 작업을 수행하시겠습니까?"
echo "1) 애플리케이션 설치 (의존성 설치)"
echo "2) 터미널 설정 (zsh, p10k 설정)"
echo "3) 모두 실행 (순차적으로 1, 2 실행)"
echo "q) 종료"
echo ""
read -p "선택 (1, 2, 3, q): " choice

case $choice in
    1)
        echo -e "${GREEN}[실행]${NC} 애플리케이션 설치를 시작합니다..."
        ./install_deps.sh
        ;;
    2)
        echo -e "${GREEN}[실행]${NC} 터미널 설정을 시작합니다..."
        ./setup_terminal.sh
        ;;
    3)
        echo -e "${GREEN}[실행]${NC} 모든 설치를 순차적으로 시작합니다..."
        ./install_deps.sh && ./setup_terminal.sh
        ;;
    q|Q)
        echo -e "${BLUE}[INFO]${NC} 프로그램을 종료합니다."
        exit 0
        ;;
    *)
        echo -e "${RED}[ERROR]${NC} 잘못된 선택입니다. 프로그램을 종료합니다."
        exit 1
        ;;
esac

echo -e "${GREEN}[완료]${NC} 선택한 작업이 완료되었습니다." 