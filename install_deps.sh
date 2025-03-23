#!/bin/bash

# 현재 스크립트 디렉토리 설정
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# 설정 파일 불러오기
if [ -f "$SCRIPT_DIR/config.sh" ]; then
    source "$SCRIPT_DIR/config.sh"
fi

# 색상 정의
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 로그 메시지 함수
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# XCode Command Line Tools 설치 확인
check_xcode_cli_tools() {
    log_info "XCode Command Line Tools 설치 확인 중..."
    if ! xcode-select -p &> /dev/null; then
        log_info "XCode Command Line Tools가 설치되어 있지 않습니다. 설치를 시작합니다..."
        xcode-select --install
        log_info "설치 프로세스가 완료될 때까지 기다려주세요."
        read -p "XCode Command Line Tools 설치가 완료되면 Enter 키를 눌러주세요..." 
        
        # 추가 확인
        if ! xcode-select -p &> /dev/null; then
            log_error "XCode Command Line Tools 설치가 완료되지 않았습니다. 설치를 중단합니다."
            exit 1
        fi
        
        log_success "XCode Command Line Tools 설치 완료"
    else
        log_success "XCode Command Line Tools가 이미 설치되어 있습니다."
    fi
}

# 홈브류 설치 확인 및 설치
install_homebrew() {
    log_info "Homebrew 설치 확인 중..."
    if ! command -v brew &> /dev/null; then
        log_info "Homebrew가 설치되어 있지 않습니다. 설치를 시작합니다..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Homebrew 환경변수 설정
        if [[ $(uname -m) == 'arm64' ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
            eval "$(/opt/homebrew/bin/brew shellenv)"
        else
            echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zshrc
            eval "$(/usr/local/bin/brew shellenv)"
        fi
        
        log_success "Homebrew 설치 완료"
    else
        log_success "Homebrew가 이미 설치되어 있습니다."
    fi
}

# k9s 설치
install_k9s() {
    log_info "k9s 설치 중..."
    if ! command -v k9s &> /dev/null; then
        brew install k9s
        log_success "k9s 설치 완료"
    else
        log_success "k9s가 이미 설치되어 있습니다."
    fi
}

# kubectx 설치
install_kubectx() {
    log_info "kubectx 설치 중..."
    if ! command -v kubectx &> /dev/null; then
        brew install kubectx
        log_success "kubectx 설치 완료"
    else
        log_success "kubectx가 이미 설치되어 있습니다."
    fi
}

# Nerd Fonts 설치 (Powerlevel10k용)
install_nerd_fonts() {
    log_info "Powerlevel10k에 필요한 Nerd Fonts(MesloLGS NF) 설치 중..."
    
    # 폰트 디렉토리 생성
    FONT_DIR="$HOME/Library/Fonts"
    mkdir -p "$FONT_DIR"
    
    # MesloLGS NF 폰트 URL
    FONT_URLS=(
        "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf"
        "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf"
        "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf"
        "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf"
    )
    
    # 폰트 다운로드 및 설치
    for url in "${FONT_URLS[@]}"; do
        filename=$(basename "$url" | sed 's/%20/ /g')
        
        if [ ! -f "$FONT_DIR/$filename" ]; then
            log_info "폰트 다운로드 중: $filename"
            curl -L "$url" -o "$FONT_DIR/$filename"
            log_success "폰트 다운로드 완료: $filename"
        else
            log_success "폰트가 이미 설치되어 있습니다: $filename"
        fi
    done
    
    log_success "MesloLGS NF 폰트 설치 완료"
    log_info "iTerm2에서 Preferences > Profiles > Text > Font에서 MesloLGS NF를 선택하세요."
}

# iTerm2 설치
install_iterm2() {
    log_info "iTerm2 설치 중..."
    if [ ! -d "/Applications/iTerm.app" ]; then
        brew install --cask iterm2
        log_success "iTerm2 설치 완료"
        
        # iTerm2 테마 설치 (선택 사항)
        if [ ! -z "$ITERM2_COLOR_THEME" ]; then
            log_info "iTerm2 컬러 테마 다운로드 중..."
            curl -o /tmp/theme.itermcolors "$ITERM2_COLOR_THEME"
            log_info "iTerm2 컬러 테마가 /tmp/theme.itermcolors에 다운로드되었습니다."
            log_info "iTerm2를 실행한 후 Preferences > Profiles > Colors > Color Presets > Import에서 테마를 가져올 수 있습니다."
        fi
    else
        log_success "iTerm2가 이미 설치되어 있습니다."
    fi
}

# Rectangle 설치
install_rectangle() {
    log_info "Rectangle 설치 중..."
    if [ ! -d "/Applications/Rectangle.app" ]; then
        brew install --cask rectangle
        log_success "Rectangle 설치 완료"
    else
        log_success "Rectangle이 이미 설치되어 있습니다."
    fi
}

# VSCode 설치
install_vscode() {
    log_info "VSCode 설치 중..."
    if [ ! -d "/Applications/Visual Studio Code.app" ]; then
        brew install --cask visual-studio-code
        log_success "VSCode 설치 완료"
    else
        log_success "VSCode가 이미 설치되어 있습니다."
    fi
    
    # VSCode 확장 프로그램 설치 (code 명령어가 있을 경우)
    if command -v code &> /dev/null && [ ${#VSCODE_EXTENSIONS[@]} -gt 0 ]; then
        log_info "VSCode 확장 프로그램 설치 중..."
        for extension in "${VSCODE_EXTENSIONS[@]}"; do
            log_info "확장 프로그램 설치 중: $extension"
            code --install-extension "$extension" --force
        done
        log_success "VSCode 확장 프로그램 설치 완료"
    elif [ ${#VSCODE_EXTENSIONS[@]} -gt 0 ]; then
        log_info "VSCode 명령어를 찾을 수 없습니다. VSCode를 실행한 후 명령 팔레트(F1 또는 Cmd+Shift+P)에서 'Shell Command: Install 'code' command in PATH'를 실행해주세요."
    fi
}

# Cursor 설치
install_cursor() {
    log_info "Cursor 설치 중..."
    if [ ! -d "/Applications/Cursor.app" ]; then
        brew install --cask cursor
        log_success "Cursor 설치 완료"
    else
        log_success "Cursor가 이미 설치되어 있습니다."
    fi
}

# 메인 함수
main() {
    log_info "애플리케이션 설치를 시작합니다..."
    
    # XCode Command Line Tools 설치 확인
    check_xcode_cli_tools
    
    # Homebrew 설치
    install_homebrew
    
    # 각 애플리케이션 설치
    install_k9s
    install_kubectx
    
    # Powerlevel10k용 폰트 설치
    install_nerd_fonts
    
    install_iterm2
    install_rectangle
    install_vscode
    install_cursor
    
    log_success "모든 애플리케이션 설치가 완료되었습니다!"
    log_info "이제 터미널 설정을 진행하려면 './setup_terminal.sh' 명령어를 실행하세요."
}

# 스크립트 실행
main 