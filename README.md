# Mac 초기 설정 자동화 도구

새로운 맥북을 설정할 때 필요한 도구들을 자동으로 설치하는 스크립트입니다.

## 전제 조건

- Git이 이미 설치되어 있어야 합니다. (저장소를 클론하기 위해 필요)

## 설치되는 도구들

- k9s - 쿠버네티스 CLI 툴
- kubectx - 쿠버네티스 컨텍스트 전환 툴
- Oh My Zsh - Zsh 구성 관리 프레임워크
- iTerm2 - 터미널 에뮬레이터
- Rectangle - 창 관리 도구
- VSCode - 코드 에디터
- Cursor - AI 지원 코드 에디터
- Powerlevel10k - Zsh 테마
- MesloLGS NF - 폰트(Powerlevel10k용)
- z - 디렉토리 이동 유틸리티
- Zsh-autosuggestions - Zsh 자동 완성 플러그인

## 새 맥북에서 설정하는 방법

1. 이 저장소를 클론합니다:

   ```bash
   git clone https://github.com/your-username/init-tools.git
   cd init-tools
   ```

2. 실행 권한을 부여합니다:

   ```bash
   chmod +x install.sh config.sh
   ```

3. 필요한 경우 `config.sh` 파일을 수정하여 원하는 설정을 변경합니다.

4. 설치 스크립트를 실행합니다:
   ```bash
   ./install.sh
   ```

## 설치 후 확인 사항

- iTerm2 폰트 설정: Preferences > Profiles > Text > Font에서 `MesloLGS NF` 선택
- iTerm2 컬러 테마 설정: Preferences > Profiles > Colors > Color Presets
- Homebrew 설치 확인: `brew --version`
- VSCode 확장 프로그램 확인
- Oh My Zsh 플러그인이 ~/.zshrc 파일에 포함되어 있는지 확인

## 설정 사용자 정의

`config.sh` 파일을 수정하여 다음 설정을 변경할 수 있습니다:

### ZSH 플러그인

기본적으로 다음 플러그인이 설치됩니다:

- git
- z
- zsh-autosuggestions

### ZSH 테마

기본 테마는 `powerlevel10k/powerlevel10k`입니다.

### VSCode 확장 프로그램

기본적으로 다음 확장 프로그램이 설치됩니다:

- formulahendry.auto-rename-tag (Auto Rename Tag)
- hashicorp.terraform (HashiCorp Terraform)
- ms-kubernetes-tools.vscode-kubernetes-tools (Kubernetes Tools)
- eamodio.gitlens (GitLens)
- golang.go (Go)

### iTerm2 컬러 테마

`config.sh` 파일에서 `ITERM2_COLOR_THEME` 변수를 설정하여 원하는 테마를 지정할 수 있습니다.

## Powerlevel10k 테마 설정

Powerlevel10k 테마는 자동으로 설치되며, `config` 디렉토리의 `.p10k.zsh` 파일이 홈 디렉토리에 자동으로 복사됩니다.

### Nerd Fonts

Powerlevel10k에 필요한 MesloLGS NF 폰트는 자동으로 설치됩니다. iTerm2에서 폰트 설정을 해주어야 아이콘이 제대로 표시됩니다.

## 문제 해결

### 폰트 표시 문제

폰트 아이콘이 제대로 표시되지 않는 경우, iTerm2 설정에서 폰트를 `MesloLGS NF`로 설정했는지 확인하세요.

### 구성 초기화

설정을 초기화하려면 `p10k configure` 명령어를 실행하세요.

## 개발 및 테스트

이 도구는 macOS에서 개발 및 테스트되었습니다. 새 사용자 계정에서 테스트하여 모든 기능이 올바르게 작동하는지 확인하는 것이 좋습니다.

## 라이센스

MIT 라이센스
