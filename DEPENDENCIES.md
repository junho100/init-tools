# 개발 환경 설정 가이드

이 문서는 개발 환경 설정에 필요한 의존성 설치 방법을 안내합니다.

## 1. 필수 도구

다음은 개발 환경에 필요한 필수 도구 목록입니다:

### XCode Command Line Tools

MacOS에서 개발에 필요한 기본 도구들을 제공합니다.

```bash
xcode-select --install
```

### Homebrew

MacOS용 패키지 관리자입니다.

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

설치 후 환경변수 설정을 위해 다음 명령어 실행이 필요할 수 있습니다:

```bash
# Apple Silicon(M1/M2) Mac
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
eval "$(/opt/homebrew/bin/brew shellenv)"

# Intel Mac
echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zshrc
eval "$(/usr/local/bin/brew shellenv)"
```

## 2. 개발 도구

### k9s

쿠버네티스 CLI 툴입니다.

```bash
brew install k9s
```

설치 후 폰트 깨짐을 방지하기 위해 다음 alias 설정을 추가하세요:

```bash
echo 'alias k9s="LANG=de_DE.UTF-8 k9s"' >> ~/.zshrc
```

### kubectx

쿠버네티스 컨텍스트 전환 툴입니다.

```bash
brew install kubectx
```

### MesloLGS NF 폰트 (Powerlevel10k용)

Powerlevel10k 테마를 사용하기 위한 폰트입니다.

```bash
# 폰트 저장 디렉토리 생성
mkdir -p "$HOME/Library/Fonts"

# 폰트 다운로드
curl -L "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf" -o "$HOME/Library/Fonts/MesloLGS NF Regular.ttf"
curl -L "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf" -o "$HOME/Library/Fonts/MesloLGS NF Bold.ttf"
curl -L "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf" -o "$HOME/Library/Fonts/MesloLGS NF Italic.ttf"
curl -L "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf" -o "$HOME/Library/Fonts/MesloLGS NF Bold Italic.ttf"
```

## 3. 터미널 및 개발 환경

### iTerm2

```bash
brew install --cask iterm2
```

iTerm2 실행 후, Preferences > Profiles > Text > Font에서 MesloLGS NF 폰트를 선택하세요.

### Rectangle (창 관리 도구)

```bash
brew install --cask rectangle
```

### VSCode (코드 에디터)

```bash
brew install --cask visual-studio-code
```

### Cursor (AI 지원 코드 에디터)

```bash
brew install --cask cursor
```

### VSCode 확장 프로그램 (선택사항)

VSCode 설치 후 터미널에서 다음 명령어로 확장 프로그램을 설치하세요:

```bash
code --install-extension formulahendry.auto-rename-tag
code --install-extension hashicorp.terraform
code --install-extension eamodio.gitlens
code --install-extension golang.go
```

## 4. 설치 후 확인 사항

각 도구가 제대로 설치되었는지 확인하세요:

```bash
brew --version              # Homebrew 버전 확인
k9s version                 # k9s 버전 확인
kubectx --version           # kubectx 버전 확인
```

## 5. 터미널 설정

터미널 설정은 `setup_terminal.sh` 스크립트를 통해 자동으로 설정할 수 있습니다:

```bash
./setup_terminal.sh
```

이 스크립트는 다음 작업을 수행합니다:

- Oh My Zsh 설치 및 설정
- Powerlevel10k 테마 설정
- git, z, zsh-autosuggestions 플러그인 설치
- k9s alias 설정 (폰트 깨짐 방지)

`config.sh` 파일에서 `ZSH_PLUGINS` 배열을 수정하여 설치할 플러그인을 변경할 수 있습니다.
