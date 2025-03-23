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

# Oh My Zsh 설치
install_oh_my_zsh() {
    log_info "Oh My Zsh 설치 중..."
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        log_success "Oh My Zsh 설치 완료"
    else
        log_success "Oh My Zsh가 이미 설치되어 있습니다."
    fi
    
    # Powerlevel10k 테마 설치
    if [[ "$ZSH_THEME" == *"powerlevel10k"* ]]; then
        log_info "Powerlevel10k 테마 설치 중..."
        if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
            git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
            log_success "Powerlevel10k 테마 설치 완료"
        else
            log_success "Powerlevel10k 테마가 이미 설치되어 있습니다."
        fi
    fi
    
    # Oh My Zsh 테마 설정
    if [ ! -z "$ZSH_THEME" ]; then
        log_info "Oh My Zsh 테마 ($ZSH_THEME) 설정 중..."
        sed -i '' "s/ZSH_THEME=.*/ZSH_THEME=\"$ZSH_THEME\"/" ~/.zshrc
        log_success "Oh My Zsh 테마 설정 완료"
    fi
    
    # Powerlevel10k 구성 파일 복사 (사용자가 제공한 경우)
    if [ -f "$POWERLEVEL10K_CONFIG_PATH" ]; then
        log_info "Powerlevel10k 구성 파일 복사 중..."
        cp "$POWERLEVEL10K_CONFIG_PATH" ~/.p10k.zsh
        
        # .zshrc에 p10k 구성 로드 설정이 없으면 추가
        if ! grep -q "source ~/.p10k.zsh" ~/.zshrc; then
            echo '[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh' >> ~/.zshrc
        fi
        
        log_success "Powerlevel10k 구성 파일 복사 완료"
    else
        log_error "Powerlevel10k 구성 파일을 찾을 수 없습니다: $POWERLEVEL10K_CONFIG_PATH"
        log_info "설정 파일이 없어도 계속 진행합니다. 터미널에서 'p10k configure' 명령어로 직접 설정할 수 있습니다."
    fi
}

# Oh My Zsh 플러그인 설치
install_oh_my_zsh_plugins() {
    log_info "Oh My Zsh 플러그인 설치 중..."
    
    # zsh-autosuggestions 플러그인 설치
    if [[ " ${ZSH_PLUGINS[*]} " =~ " zsh-autosuggestions " ]]; then
        if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
            log_info "zsh-autosuggestions 플러그인 설치 중..."
            git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
            log_success "zsh-autosuggestions 플러그인 설치 완료"
        fi
    fi
    
    # zsh-syntax-highlighting 플러그인 설치
    if [[ " ${ZSH_PLUGINS[*]} " =~ " zsh-syntax-highlighting " ]]; then
        if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
            log_info "zsh-syntax-highlighting 플러그인 설치 중..."
            git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
            log_success "zsh-syntax-highlighting 플러그인 설치 완료"
        fi
    fi
    
    # 플러그인 설정 업데이트
    if [ ${#ZSH_PLUGINS[@]} -gt 0 ]; then
        plugins_str=$(IFS=' ' ; echo "${ZSH_PLUGINS[*]}")
        log_info "Oh My Zsh 플러그인 설정 업데이트 중... ($plugins_str)"
        
        # 기존 플러그인 라인 찾기 및 교체
        if grep -q "^plugins=" ~/.zshrc; then
            sed -i '' "s/^plugins=(.*)/plugins=($plugins_str)/" ~/.zshrc
        else
            echo "plugins=($plugins_str)" >> ~/.zshrc
        fi
        
        log_success "Oh My Zsh 플러그인 설정 완료"
    fi
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

# 메인 함수
main() {
    log_info "맥북 초기 설정을 시작합니다..."
    
    # XCode Command Line Tools 설치 확인
    check_xcode_cli_tools
    
    # Homebrew 설치
    install_homebrew
    
    # 각 애플리케이션 설치
    install_k9s
    install_kubectx
    
    # Powerlevel10k용 폰트 설치
    if [[ "$ZSH_THEME" == *"powerlevel10k"* ]]; then
        install_nerd_fonts
    fi
    
    install_oh_my_zsh
    install_oh_my_zsh_plugins
    install_iterm2
    install_rectangle
    install_vscode
    install_cursor
    
    log_success "모든 설치가 완료되었습니다!"
    log_info "변경사항을 적용하려면 터미널을 재시작하거나 'source ~/.zshrc' 명령어를 실행하세요."
    
    if [[ "$ZSH_THEME" == *"powerlevel10k"* ]]; then
        log_info "iTerm2에서 Preferences > Profiles > Text > Font에서 MesloLGS NF를 선택해야 Powerlevel10k 아이콘이 제대로 표시됩니다."
    fi
}

# 스크립트 실행
main 