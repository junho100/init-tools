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

# Oh My Zsh 설치
install_oh_my_zsh() {
    log_info "Oh My Zsh 설치 중..."
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended || handle_error "Oh My Zsh 설치 실패"
        log_success "Oh My Zsh 설치 완료"
    else
        log_success "Oh My Zsh가 이미 설치되어 있습니다."
    fi
    
    # Powerlevel10k 테마 설치
    if [[ "$ZSH_THEME" == *"powerlevel10k"* ]]; then
        log_info "Powerlevel10k 테마 설치 중..."
        if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
            git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k || handle_error "Powerlevel10k 테마 설치 실패"
            log_success "Powerlevel10k 테마 설치 완료"
        else
            log_success "Powerlevel10k 테마가 이미 설치되어 있습니다."
        fi
    fi
    
    # Oh My Zsh 테마 설정
    if [ ! -z "$ZSH_THEME" ]; then
        log_info "Oh My Zsh 테마 ($ZSH_THEME) 설정 중..."
        if [ -f ~/.zshrc ]; then
            sed -i '' "s/ZSH_THEME=.*/ZSH_THEME=\"$ZSH_THEME\"/" ~/.zshrc || handle_error "테마 설정 실패"
            log_success "Oh My Zsh 테마 설정 완료"
        else
            handle_error "~/.zshrc 파일을 찾을 수 없습니다"
        fi
    fi
    
    # Powerlevel10k 구성 파일 복사
    if [ -f "$POWERLEVEL10K_CONFIG_PATH" ]; then
        log_info "Powerlevel10k 구성 파일 복사 중... ($POWERLEVEL10K_CONFIG_PATH -> ~/.p10k.zsh)"
        cp "$POWERLEVEL10K_CONFIG_PATH" ~/.p10k.zsh || handle_error "p10k 설정 파일 복사 실패"
        chmod 644 ~/.p10k.zsh
        
        # .zshrc에 p10k 구성 로드 설정이 없으면 추가
        if ! grep -q "source ~/.p10k.zsh" ~/.zshrc; then
            log_info ".zshrc에 p10k 설정 로드 코드 추가 중..."
            echo '' >> ~/.zshrc
            echo '# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.' >> ~/.zshrc
            echo '[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh' >> ~/.zshrc
        fi
        
        # p10k 즉시 프롬프트 설정이 없으면 추가
        if ! grep -q "p10k-instant-prompt" ~/.zshrc; then
            log_info ".zshrc에 p10k 즉시 프롬프트 설정 추가 중..."
            sed -i '' '1i\
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.\
# Initialization code that may require console input (password prompts, [y/n]\
# confirmations, etc.) must go above this block; everything else may go below.\
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then\
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"\
fi\
' ~/.zshrc || handle_error "p10k 즉시 프롬프트 설정 추가 실패"
        fi
        
        log_success "Powerlevel10k 구성 파일 복사 및 설정 완료"
    else
        handle_error "Powerlevel10k 구성 파일을 찾을 수 없습니다: $POWERLEVEL10K_CONFIG_PATH"
    fi
}

# Oh My Zsh 플러그인 설치
install_oh_my_zsh_plugins() {
    log_info "Oh My Zsh 플러그인 설치 중..."
    
    # zsh-autosuggestions 플러그인 설치
    if [[ " ${ZSH_PLUGINS[*]} " =~ " zsh-autosuggestions " ]]; then
        if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
            log_info "zsh-autosuggestions 플러그인 설치 중..."
            git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions || handle_error "zsh-autosuggestions 플러그인 설치 실패"
            log_success "zsh-autosuggestions 플러그인 설치 완료"
        fi
    fi
    
    # zsh-syntax-highlighting 플러그인 설치
    if [[ " ${ZSH_PLUGINS[*]} " =~ " zsh-syntax-highlighting " ]]; then
        if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
            log_info "zsh-syntax-highlighting 플러그인 설치 중..."
            git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting || handle_error "zsh-syntax-highlighting 플러그인 설치 실패"
            log_success "zsh-syntax-highlighting 플러그인 설치 완료"
        fi
    fi
    
    # 플러그인 설정 업데이트
    if [ ${#ZSH_PLUGINS[@]} -gt 0 ]; then
        plugins_str=$(IFS=' ' ; echo "${ZSH_PLUGINS[*]}")
        log_info "Oh My Zsh 플러그인 설정 업데이트 중... ($plugins_str)"
        
        # 기존 플러그인 라인 찾기 및 교체
        if grep -q "^plugins=" ~/.zshrc; then
            sed -i '' "s/^plugins=(.*)/plugins=($plugins_str)/" ~/.zshrc || handle_error "플러그인 설정 업데이트 실패"
        else
            echo "plugins=($plugins_str)" >> ~/.zshrc || handle_error "플러그인 설정 추가 실패"
        fi
        
        log_success "Oh My Zsh 플러그인 설정 완료"
    fi
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

# 메인 함수
main() {
    log_info "터미널 설정을 시작합니다..."
    
    # 설정 파일 존재 여부 확인
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