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

# Powerlevel10k 설정 파일 경로 (항상 config 디렉터리의 .p10k.zsh 파일 사용)
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
POWERLEVEL10K_CONFIG_PATH="$SCRIPT_DIR/config/.p10k.zsh" 