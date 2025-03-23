#!/bin/bash

# 현재 스크립트 디렉토리 설정
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# 설정 파일 불러오기
if [ -f "$SCRIPT_DIR/config.sh" ]; then
    source "$SCRIPT_DIR/config.sh"
else
    echo "설정 파일을 찾을 수 없습니다: config.sh"
    exit 1
fi

# 색상 정의
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
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

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# 디버깅 정보 수집 및 출력
collect_debug_info() {
    local debug_file="$SCRIPT_DIR/debug_info_$(date +%Y%m%d_%H%M%S).log"
    
    log_info "디버깅 정보를 수집합니다. 파일: $debug_file"
    
    echo "===== 디버깅 정보 $(date) =====" > "$debug_file"
    echo "" >> "$debug_file"
    echo "OS 정보:" >> "$debug_file"
    sw_vers >> "$debug_file"
    echo "" >> "$debug_file"
    
    echo "Shell 정보:" >> "$debug_file"
    echo "SHELL: $SHELL" >> "$debug_file"
    echo "ZSH 버전:" >> "$debug_file"
    zsh --version 2>&1 >> "$debug_file"
    echo "" >> "$debug_file"
    
    echo "Homebrew 정보:" >> "$debug_file"
    brew --version 2>&1 >> "$debug_file"
    echo "" >> "$debug_file"
    
    echo "PATH 환경변수:" >> "$debug_file"
    echo "$PATH" >> "$debug_file"
    echo "" >> "$debug_file"
    
    echo ".zshrc 파일:" >> "$debug_file"
    if [ -f ~/.zshrc ]; then
        cat ~/.zshrc >> "$debug_file"
    else
        echo "파일이 없음" >> "$debug_file"
    fi
    echo "" >> "$debug_file"
    
    echo ".p10k.zsh 파일:" >> "$debug_file"
    if [ -f ~/.p10k.zsh ]; then
        echo "파일 존재함" >> "$debug_file"
    else
        echo "파일이 없음" >> "$debug_file"
    fi
    echo "" >> "$debug_file"
    
    echo "설정 파일 위치:" >> "$debug_file"
    echo "SCRIPT_DIR: $SCRIPT_DIR" >> "$debug_file"
    echo "POWERLEVEL10K_CONFIG_PATH: $POWERLEVEL10K_CONFIG_PATH" >> "$debug_file"
    echo "" >> "$debug_file"
    
    echo "폰트 설치 상태:" >> "$debug_file"
    ls -la "$HOME/Library/Fonts/MesloLGS"* 2>&1 >> "$debug_file"
    echo "" >> "$debug_file"
    
    echo "Oh My Zsh 설치 상태:" >> "$debug_file"
    if [ -d "$HOME/.oh-my-zsh" ]; then
        echo "설치됨" >> "$debug_file"
        ls -la "$HOME/.oh-my-zsh/custom/themes" 2>&1 >> "$debug_file"
    else
        echo "설치되지 않음" >> "$debug_file"
    fi
    echo "" >> "$debug_file"
    
    log_success "디버깅 정보가 $debug_file 파일에 저장되었습니다."
    log_info "문제 해결을 위해 이 파일을 개발자에게 보내주세요."
}

# 오류 처리 함수
handle_error() {
    log_error "오류가 발생했습니다: $1"
    log_error "스크립트를 중단합니다."
    log_info "문제 진단을 위해 디버깅 정보를 수집합니다."
    collect_debug_info
    exit 1
}

# Oh My Zsh 및 테마 설치
install_oh_my_zsh() {
    log_info "Oh My Zsh 설치 확인 중..."
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        log_info "Oh My Zsh가 설치되어 있지 않습니다. 설치를 시작합니다..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        log_success "Oh My Zsh 설치 완료"
    else
        log_success "Oh My Zsh가 이미 설치되어 있습니다."
    fi
    
    # Powerlevel10k 테마 설치
    log_info "Powerlevel10k 테마 설치 중..."
    if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
        log_success "Powerlevel10k 테마 설치 완료"
    else
        log_success "Powerlevel10k 테마가 이미 설치되어 있습니다."
    fi
    
    # .zshrc 백업 (아직 백업이 없는 경우)
    local timestamp=$(date +"%Y%m%d%H%M%S")
    local zshrc_backup="$HOME/.zshrc.backup-$timestamp"
    if [ -f "$HOME/.zshrc" ]; then
        log_info ".zshrc 파일 백업 중... ($zshrc_backup)"
        cp "$HOME/.zshrc" "$zshrc_backup"
    fi
    
    # ZSH_THEME 설정을 검사하고 업데이트
    log_info ".zshrc 파일에서 ZSH_THEME 설정 확인 중..."
    
    if [ -f "$HOME/.zshrc" ]; then
        # .zshrc에 ZSH_THEME가 있는지 확인
        if grep -q "^ZSH_THEME=" "$HOME/.zshrc"; then
            log_info "기존 ZSH_THEME 설정을 업데이트합니다..."
            # ZSH_THEME 라인을 찾아서 교체
            sed -i.bak -E 's/^ZSH_THEME="[^"]*"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' "$HOME/.zshrc"
        else
            # ZSH_THEME가 없는 경우, 추가
            log_info "ZSH_THEME 설정이 없습니다. 새로 추가합니다..."
            echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >> "$HOME/.zshrc"
        fi
    else
        # .zshrc가 없는 경우, 새로 생성
        log_info ".zshrc 파일이 없습니다. 새로 생성합니다..."
        cat > "$HOME/.zshrc" << 'EOL'
# 기본 .zshrc 파일
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git z zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh
EOL
    fi
    
    # .p10k.zsh 설정 파일 링크가 있는지 확인하고 추가
    if ! grep -q "source.*\.p10k\.zsh" "$HOME/.zshrc"; then
        log_info "p10k 설정 파일 소스 추가 중..."
        echo -e "\n# p10k 설정 파일 소스\n[[ -f \"$POWERLEVEL10K_CONFIG_PATH\" ]] && source \"$POWERLEVEL10K_CONFIG_PATH\"" >> "$HOME/.zshrc"
    else
        # 이미 존재하는 p10k 설정 파일 라인을 업데이트
        log_info "기존 p10k 설정 파일 라인 업데이트 중..."
        sed -i.bak -E "s|source.*\.p10k\.zsh|source \"$POWERLEVEL10K_CONFIG_PATH\"|" "$HOME/.zshrc"
    fi
    
    log_success ".zshrc 파일의 Powerlevel10k 설정 완료"
}

# Oh My Zsh 플러그인 설치
install_oh_my_zsh_plugins() {
    local plugins_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"
    log_info "Oh My Zsh 플러그인 설치 중..."
    
    # zsh-autosuggestions 플러그인 설치
    if [ ! -d "$plugins_dir/zsh-autosuggestions" ]; then
        log_info "zsh-autosuggestions 플러그인 설치 중..."
        git clone https://github.com/zsh-users/zsh-autosuggestions "$plugins_dir/zsh-autosuggestions"
        log_success "zsh-autosuggestions 플러그인 설치 완료"
    else
        log_success "zsh-autosuggestions 플러그인이 이미 설치되어 있습니다."
    fi
    
    # zsh-syntax-highlighting 플러그인 설치
    if [ ! -d "$plugins_dir/zsh-syntax-highlighting" ]; then
        log_info "zsh-syntax-highlighting 플러그인 설치 중..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$plugins_dir/zsh-syntax-highlighting"
        log_success "zsh-syntax-highlighting 플러그인 설치 완료"
    else
        log_success "zsh-syntax-highlighting 플러그인이 이미 설치되어 있습니다."
    fi
    
    # .zshrc 파일에 플러그인 설정
    log_info ".zshrc 파일의 플러그인 설정 업데이트 중..."
    if [ -f "$HOME/.zshrc" ]; then
        # plugins 설정이 있는지 확인
        if grep -q "^plugins=(" "$HOME/.zshrc"; then
            log_info "기존 플러그인 설정 업데이트 중..."
            
            # 현재 플러그인 설정 추출
            local current_plugins=$(grep -E "^plugins=\([^)]*\)" "$HOME/.zshrc" | sed -E 's/^plugins=\(([^)]*)\)/\1/')
            
            # 필요한 플러그인들이 모두 있는지 확인하고 없으면 추가
            local needed_plugins=("git" "z" "zsh-autosuggestions" "zsh-syntax-highlighting")
            local updated_plugins="$current_plugins"
            
            for plugin in "${needed_plugins[@]}"; do
                # 플러그인이 없으면 추가
                if ! echo "$updated_plugins" | grep -q "$plugin"; then
                    # 플러그인 목록이 비어있지 않으면 공백 추가
                    if [ ! -z "$updated_plugins" ]; then
                        updated_plugins="$updated_plugins $plugin"
                    else
                        updated_plugins="$plugin"
                    fi
                fi
            done
            
            # 새 플러그인 설정으로 업데이트
            log_info "플러그인 설정 업데이트: plugins=($updated_plugins)"
            sed -i.bak -E "s/^plugins=\([^)]*\)/plugins=($updated_plugins)/" "$HOME/.zshrc"
        else
            # plugins 설정이 없는 경우 추가
            log_info "플러그인 설정이 없습니다. 새로 추가합니다..."
            echo 'plugins=(git z zsh-autosuggestions zsh-syntax-highlighting)' >> "$HOME/.zshrc"
        fi
    else
        # .zshrc 파일이 없는 경우 에러 처리
        log_error ".zshrc 파일이 존재하지 않습니다. 플러그인 설정을 추가할 수 없습니다."
        return 1
    fi
    
    log_success "Oh My Zsh 플러그인 설치 및 설정 완료"
}

# 설정 검증
validate_setup() {
    log_info "설정 검증 중..."
    local has_error=0
    
    # Oh My Zsh 확인
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        log_error "Oh My Zsh가 설치되어 있지 않습니다."
        has_error=1
    fi
    
    # Powerlevel10k 테마 확인
    if [[ "$ZSH_THEME" == *"powerlevel10k"* ]]; then
        if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
            log_error "Powerlevel10k 테마가 설치되어 있지 않습니다."
            has_error=1
        fi
    fi
    
    # p10k 설정 파일 확인
    if [ ! -f ~/.p10k.zsh ]; then
        log_error "~/.p10k.zsh 파일이 없습니다."
        has_error=1
    fi
    
    # .zshrc에 p10k 설정 확인
    if ! grep -q "source ~/.p10k.zsh" ~/.zshrc; then
        log_error ".zshrc에 p10k.zsh 로드 설정이 없습니다."
        has_error=1
    fi
    
    # Oh My Zsh 플러그인 확인
    for plugin in "${ZSH_PLUGINS[@]}"; do
        if [[ "$plugin" == "zsh-autosuggestions" && ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]]; then
            log_error "zsh-autosuggestions 플러그인이 설치되어 있지 않습니다."
            has_error=1
        fi
        if [[ "$plugin" == "zsh-syntax-highlighting" && ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]]; then
            log_error "zsh-syntax-highlighting 플러그인이 설치되어 있지 않습니다."
            has_error=1
        fi
    done
    
    # 플러그인 설정 확인
    plugins_str=$(IFS=' ' ; echo "${ZSH_PLUGINS[*]}")
    if ! grep -q "plugins=($plugins_str)" ~/.zshrc; then
        log_warning "플러그인 설정이 정확하지 않을 수 있습니다."
    fi
    
    if [ $has_error -eq 1 ]; then
        log_error "설정 검증 실패. 문제를 해결하기 위해 디버깅 정보를 수집합니다."
        collect_debug_info
        return 1
    else
        log_success "설정 검증 완료. 모든 항목이 정상적으로 설정되었습니다."
        return 0
    fi
}

# 폰트 설치 여부 확인 및 설치
check_and_install_fonts() {
    log_info "폰트 설치 여부 확인 중..."
    
    local FONT_DIR="$HOME/Library/Fonts"
    local any_font_installed=false
    
    # MesloLGS NF 폰트 일부 파일 확인
    if [ -f "$FONT_DIR/MesloLGS NF Regular.ttf" ]; then
        log_success "MesloLGS NF 폰트가 이미 설치되어 있습니다."
        any_font_installed=true
    else
        log_info "MesloLGS NF 폰트가 설치되어 있지 않습니다. 설치를 시작합니다..."
        
        # 폰트 디렉토리 생성
        mkdir -p "$FONT_DIR"
        
        # MesloLGS NF 폰트 URL
        FONT_URLS=(
            "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf"
            "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf"
            "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf"
            "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf"
        )
        
        # 폰트 다운로드 및 설치
        local install_success=true
        for url in "${FONT_URLS[@]}"; do
            filename=$(basename "$url" | sed 's/%20/ /g')
            
            if [ ! -f "$FONT_DIR/$filename" ]; then
                log_info "폰트 다운로드 중: $filename"
                if curl -L "$url" -o "$FONT_DIR/$filename"; then
                    log_success "폰트 다운로드 완료: $filename"
                else
                    log_error "폰트 다운로드 실패: $filename"
                    install_success=false
                fi
            else
                log_success "폰트가 이미 설치되어 있습니다: $filename"
            fi
        done
        
        if [ "$install_success" = true ]; then
            log_success "MesloLGS NF 폰트 설치 완료"
            log_info "iTerm2에서 Preferences > Profiles > Text > Font에서 MesloLGS NF를 선택하세요."
        else
            log_error "일부 폰트 설치에 실패했습니다."
            return 1
        fi
    fi
    
    return 0
}

# p10k 설정 파일 확인 및 준비
check_p10k_config() {
    log_info "Powerlevel10k 설정 파일 확인 중..."
    
    if [ ! -f "$POWERLEVEL10K_CONFIG_PATH" ]; then
        log_error "Powerlevel10k 설정 파일이 존재하지 않습니다: $POWERLEVEL10K_CONFIG_PATH"
        
        # config 디렉토리 확인
        if [ ! -d "$SCRIPT_DIR/config" ]; then
            log_info "config 디렉토리를 생성합니다..."
            mkdir -p "$SCRIPT_DIR/config" || handle_error "config 디렉토리 생성 실패"
        fi
        
        # 기본 p10k 설정 파일 생성 시도
        log_info "기본 p10k 설정 파일 생성을 시도합니다..."
        if command -v p10k &> /dev/null; then
            log_info "p10k 명령어를 사용하여 설정 파일을 생성합니다..."
            p10k configure -f -y > /dev/null 2>&1
            
            if [ -f "$HOME/.p10k.zsh" ]; then
                log_info "p10k 설정 파일을 config 디렉토리로 복사합니다..."
                cp "$HOME/.p10k.zsh" "$POWERLEVEL10K_CONFIG_PATH" || handle_error "p10k 설정 파일 복사 실패"
                log_success "기본 p10k 설정 파일 생성 완료"
            else
                log_error "p10k 설정 파일 생성 실패"
                return 1
            fi
        else
            log_error "p10k 명령어를 찾을 수 없습니다. 수동으로 p10k 설정 파일을 생성해야 합니다."
            log_info "다음 옵션 중 하나를 선택하세요:"
            log_info "1) 빈 p10k 설정 파일 생성"
            log_info "2) 설정 종료"
            read -p "선택 (1, 2): " choice
            
            case $choice in
                1)
                    log_info "빈 p10k 설정 파일을 생성합니다..."
                    echo "# 기본 p10k 설정 파일" > "$POWERLEVEL10K_CONFIG_PATH" || handle_error "p10k 설정 파일 생성 실패"
                    log_success "빈 p10k 설정 파일 생성 완료"
                    ;;
                *)
                    log_info "설정을 종료합니다."
                    return 1
                    ;;
            esac
        fi
    else
        log_success "Powerlevel10k 설정 파일이 존재합니다: $POWERLEVEL10K_CONFIG_PATH"
    fi
    
    return 0
}

# 메인 함수
main() {
    log_info "터미널 설정을 시작합니다..."
    
    # 폰트 설치 여부 확인 및 설치
    check_and_install_fonts || log_warning "폰트 설치에 문제가 발생했습니다. 계속 진행합니다."
    
    # p10k 설정 파일 확인 및 준비
    check_p10k_config || handle_error "p10k 설정 파일 준비 실패"
    
    # 설정 파일 존재 여부 다시 확인
    if [ ! -f "$POWERLEVEL10K_CONFIG_PATH" ]; then
        log_error "Powerlevel10k 설정 파일이 존재하지 않습니다: $POWERLEVEL10K_CONFIG_PATH"
        log_info "설정 파일 없이 계속 진행하시겠습니까? (y/n)"
        read -p ">" answer
        if [[ "$answer" != "y" && "$answer" != "Y" ]]; then
            log_info "설정을 중단합니다."
            exit 0
        fi
    fi
    
    # Oh My Zsh 및 테마 설치
    install_oh_my_zsh
    
    # Oh My Zsh 플러그인 설치
    install_oh_my_zsh_plugins
    
    # 설정 검증
    validate_setup
    result=$?
    
    if [ $result -eq 0 ]; then
        log_success "모든 터미널 설정이 완료되었습니다!"
        log_info "변경사항을 적용하려면 터미널을 재시작하거나 'source ~/.zshrc' 명령어를 실행하세요."
        log_info "iTerm2에서 MesloLGS NF 폰트를 설정하는 것을 잊지 마세요."
    else
        log_warning "일부 설정이 완료되지 않았습니다. 위의 오류 메시지를 확인하고 필요한 경우 스크립트를 다시 실행하세요."
        log_info "DEBUG 정보를 개발자에게 전달하여 도움을 받을 수 있습니다."
    fi
}

# 스크립트 실행
main 