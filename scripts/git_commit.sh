#!/bin/bash

# g_kit 프로젝트의 git commit/push 스크립트
# staging된 파일들의 수정 내용을 자동으로 감지하여 커밋 메시지를 생성합니다.

set -e

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# 로그 함수
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_git() {
    echo -e "${PURPLE}[GIT]${NC} $1"
}

# 현재 디렉토리 확인
if [ ! -f "melos.yaml" ]; then
    log_error "melos.yaml 파일을 찾을 수 없습니다. g_kit 디렉토리에서 실행하세요."
    exit 1
fi

# Git 저장소 확인
if [ ! -d ".git" ]; then
    log_error "Git 저장소가 아닙니다."
    exit 1
fi

# 커밋 메시지 생성 함수
generate_commit_message() {
    local staged_files=$(git diff --cached --name-only)
    
    if [ -z "$staged_files" ]; then
        log_warning "staging된 파일이 없습니다."
        return 1
    fi
    
    # 파일 타입별로 분류
    local dart_files=""
    local yaml_files=""
    local md_files=""
    local sh_files=""
    local other_files=""
    
    for file in $staged_files; do
        case "$file" in
            *.dart)
                dart_files="$dart_files $file"
                ;;
            *.yaml|*.yml)
                yaml_files="$yaml_files $file"
                ;;
            *.md)
                md_files="$md_files $file"
                ;;
            *.sh)
                sh_files="$sh_files $file"
                ;;
            *)
                other_files="$other_files $file"
                ;;
        esac
    done
    
    # 커밋 메시지 생성
    local message=""
    local changes=""
    
    # 주요 변경사항 감지
    if [ -n "$dart_files" ]; then
        changes="${changes}📦 Dart 파일 수정"
        message="${message}Dart 코드 수정\n"
    fi
    
    if [ -n "$yaml_files" ]; then
        changes="${changes}⚙️ 설정 파일 수정"
        message="${message}설정 파일 수정\n"
    fi
    
    if [ -n "$md_files" ]; then
        changes="${changes}📝 문서 수정"
        message="${message}문서 수정\n"
    fi
    
    if [ -n "$sh_files" ]; then
        changes="${changes}🔧 스크립트 수정"
        message="${message}스크립트 수정\n"
    fi
    
    if [ -n "$other_files" ]; then
        changes="${changes}📄 기타 파일 수정"
        message="${message}기타 파일 수정\n"
    fi
    
    # 변경된 파일 목록 추가
    message="${message}\n변경된 파일:\n"
    for file in $staged_files; do
        message="${message}- $file\n"
    done
    
    echo "$message"
}

# Git 상태 확인
check_git_status() {
    local staged_files=$(git diff --cached --name-only)
    local unstaged_files=$(git diff --name-only)
    local untracked_files=$(git ls-files --others --exclude-standard)
    
    log_info "Git 상태 확인 중..."
    
    if [ -n "$staged_files" ]; then
        log_info "Staging된 파일:"
        echo "$staged_files" | while read file; do
            if [ -n "$file" ]; then
                echo "  ✅ $file"
            fi
        done
    else
        log_warning "Staging된 파일이 없습니다."
        return 1
    fi
    
    if [ -n "$unstaged_files" ]; then
        log_warning "Unstaged 파일이 있습니다:"
        echo "$unstaged_files" | while read file; do
            if [ -n "$file" ]; then
                echo "  ⚠️ $file"
            fi
        done
    fi
    
    if [ -n "$untracked_files" ]; then
        log_warning "Untracked 파일이 있습니다:"
        echo "$untracked_files" | while read file; do
            if [ -n "$file" ]; then
                echo "  ❓ $file"
            fi
        done
    fi
    
    return 0
}

# 메인 함수
main() {
    local push_flag=false
    local message=""
    
    # 인자 파싱
    while [[ $# -gt 0 ]]; do
        case $1 in
            --push|-p)
                push_flag=true
                shift
                ;;
            --message|-m)
                message="$2"
                shift 2
                ;;
            --help|-h)
                echo "사용법: $0 [옵션]"
                echo ""
                echo "옵션:"
                echo "  --push, -p        커밋 후 push 실행"
                echo "  --message, -m     커밋 메시지 직접 지정"
                echo "  --help, -h        도움말 표시"
                echo ""
                echo "예시:"
                echo "  $0                    # 커밋만 실행"
                echo "  $0 --push            # 커밋 후 push"
                echo "  $0 -m '커밋 메시지'   # 커스텀 메시지로 커밋"
                exit 0
                ;;
            *)
                log_error "알 수 없는 옵션: $1"
                exit 1
                ;;
        esac
    done
    
    # Git 상태 확인
    if ! check_git_status; then
        log_error "커밋할 파일이 없습니다."
        exit 1
    fi
    
    # 커밋 메시지 생성
    if [ -z "$message" ]; then
        message=$(generate_commit_message)
        if [ $? -ne 0 ]; then
            log_error "커밋 메시지 생성에 실패했습니다."
            exit 1
        fi
    fi
    
    # 커밋 실행
    log_git "커밋을 실행합니다..."
    echo "$message" | git commit -F -
    
    if [ $? -eq 0 ]; then
        log_success "커밋이 완료되었습니다!"
        
        # Push 실행
        if [ "$push_flag" = true ]; then
            log_git "Push를 실행합니다..."
            git push
            
            if [ $? -eq 0 ]; then
                log_success "Push가 완료되었습니다!"
            else
                log_error "Push에 실패했습니다."
                exit 1
            fi
        else
            log_info "Push를 실행하려면 --push 옵션을 사용하세요."
        fi
    else
        log_error "커밋에 실패했습니다."
        exit 1
    fi
}

# 스크립트 실행
main "$@" 