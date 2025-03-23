#!/bin/bash

# Oh My Zsh 플러그인 설정
# 원하는 플러그인 목록을 콤마로 구분하지 않고 공백으로 구분된 문자열로 정의
ZSH_PLUGINS=(
  "git"
  "zsh-autosuggestions"
  "z"
)

# Oh My Zsh 테마
ZSH_THEME="powerlevel10k/powerlevel10k"

# VSCode 확장 프로그램
VSCODE_EXTENSIONS=(
  "formulahendry.auto-rename-tag"
  "hashicorp.terraform"
  "eamodio.gitlens"
  "golang.go"
)

# iTerm2 색상 테마 URL
ITERM2_COLOR_THEME="https://raw.githubusercontent.com/mbadolato/iTerm2-Color-Schemes/master/schemes/Solarized%20Dark.itermcolors"

# Powerlevel10k 설정 파일 경로 설정
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# 항상 config 디렉토리의 .p10k.zsh 파일을 사용합니다
POWERLEVEL10K_CONFIG_PATH="$SCRIPT_DIR/config/.p10k.zsh"

# 설정 파일이 존재하는지 확인
if [ ! -f "$POWERLEVEL10K_CONFIG_PATH" ]; then
  echo "경고: Powerlevel10k 설정 파일이 존재하지 않습니다: $POWERLEVEL10K_CONFIG_PATH"
  echo "이 설정 파일이 없으면 설치 과정에서 p10k 설정이 제대로 적용되지 않을 수 있습니다."
  echo "config 디렉토리에 .p10k.zsh 파일이 있는지 확인하세요."
fi 