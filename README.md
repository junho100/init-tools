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
   chmod +x install.sh install_deps.sh setup_terminal.sh config.sh
   ```

3. 필요한 경우 `config.sh` 파일을 수정하여 원하는 설정을 변경합니다.

4. 설치 스크립트를 실행합니다:

   ```bash
   ./install.sh
   ```

   메뉴에서 다음 옵션 중 하나를 선택할 수 있습니다:

   - 1: 애플리케이션 설치만 진행
   - 2: 터미널 설정만 진행
   - 3: 모든 설치를 순차적으로 진행
   - q: 종료

## 모듈식 설치

이 도구는 두 단계로 나누어 설치할 수 있습니다:

1. **애플리케이션 설치** (install_deps.sh)

   - Homebrew, XCode Command Line Tools 설치
   - 필요한 애플리케이션 및 도구 설치
   - VSCode 확장 프로그램 설치
   - 폰트 설치

2. **터미널 설정** (setup_terminal.sh)
   - Oh My Zsh 설치 및 설정
   - Powerlevel10k 테마 설정
   - 플러그인 설치 및 구성
   - 설정 검증 및 디버깅 정보 수집

각 단계는 독립적으로 실행할 수 있으며, 문제가 발생할 경우 디버깅 정보가 자동으로 수집됩니다.

## 문제 해결 및 디버깅

터미널 설정 중 문제가 발생하면 자동으로 디버깅 정보가 수집됩니다. 디버깅 파일은 `debug_info_YYYYMMDD_HHMMSS.log` 형식으로 저장되며, 다음 정보를 포함합니다:

- OS 정보
- Shell 정보 및 ZSH 버전
- Homebrew 버전
- PATH 환경변수
- .zshrc 파일 내용
- .p10k.zsh 파일 존재 여부
- 설정 파일 위치
- 폰트 설치 상태
- Oh My Zsh 설치 상태

문제 해결을 위해 이 디버깅 파일을 개발자에게 공유할 수 있습니다.

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
- eamodio.gitlens (GitLens)
- golang.go (Go)

### iTerm2 컬러 테마

`config.sh` 파일에서 `ITERM2_COLOR_THEME` 변수를 설정하여 원하는 테마를 지정할 수 있습니다.

## Powerlevel10k 테마 설정

Powerlevel10k 테마는 자동으로 설치되며, `config` 디렉토리의 `.p10k.zsh` 파일이 홈 디렉토리에 자동으로 복사됩니다.

이 설정 파일은 **매우 중요**합니다. 만약 `config/.p10k.zsh` 파일이 존재하지 않으면 설치 과정에서 Powerlevel10k 설정이 제대로 적용되지 않을 수 있습니다.

### 설정 파일 위치 확인

설치 전에 다음 명령어로 p10k 설정 파일이 제대로 존재하는지 확인하세요:

```bash
ls -la config/.p10k.zsh
```

파일이 없는 경우:

1. p10k 설정 파일을 다운로드하거나 생성하여 `config/.p10k.zsh` 경로에 저장하세요.
2. 또는 기존 p10k 설정 파일을 복사하여 저장소의 `config/.p10k.zsh` 위치에 복사하세요.

### Nerd Fonts

Powerlevel10k에 필요한 MesloLGS NF 폰트는 자동으로 설치됩니다. iTerm2에서 폰트 설정을 해주어야 아이콘이 제대로 표시됩니다.

## 문제 해결

### 폰트 표시 문제

폰트 아이콘이 제대로 표시되지 않는 경우, iTerm2 설정에서 폰트를 `MesloLGS NF`로 설정했는지 확인하세요.

### p10k 설정 문제

Powerlevel10k가 제대로 설정되지 않는 경우 다음을 확인하세요:

1. `config/.p10k.zsh` 파일이 존재하는지 확인
2. 설치 후 `~/.p10k.zsh` 파일이 생성되었는지 확인
3. `~/.zshrc` 파일에 다음 코드가 포함되어 있는지 확인:
   ```bash
   [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
   ```
4. 수동으로 설정을 적용하려면 터미널에서 다음 명령어를 실행:
   ```bash
   echo 'source ~/.p10k.zsh' >> ~/.zshrc
   source ~/.zshrc
   ```

### 구성 초기화

설정을 초기화하려면 `p10k configure` 명령어를 실행하세요.

## 개발 및 테스트

이 도구는 macOS에서 개발 및 테스트되었습니다. 새 사용자 계정에서 테스트하여 모든 기능이 올바르게 작동하는지 확인하는 것이 좋습니다.

## 라이센스

MIT 라이센스
