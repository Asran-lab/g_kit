#!/bin/bash

# g_kit 프로젝트의 melos 기반 정리 스크립트
# 용량을 절약하고 빌드 캐시를 정리합니다.

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

log_melos() {
    echo -e "${PURPLE}[MELOS]${NC} $1"
}

# 현재 디렉토리 확인
if [ ! -f "melos.yaml" ]; then
    log_error "melos.yaml 파일을 찾을 수 없습니다. g_kit 디렉토리에서 실행하세요."
    exit 1
fi

# 정리 전 용량 확인
log_info "정리 전 용량 확인 중..."
TOTAL_SIZE_BEFORE=0

if [ -d ".dart_tool" ]; then
    DART_TOOL_SIZE=$(du -sh .dart_tool 2>/dev/null | cut -f1)
    log_info "루트 .dart_tool 크기: $DART_TOOL_SIZE"
fi

# 하위 패키지들의 용량 확인
for dir in g_common g_core g_lib g_model g_plugin; do
    if [ -d "$dir/.dart_tool" ]; then
        SIZE=$(du -sh "$dir/.dart_tool" 2>/dev/null | cut -f1)
        log_info "$dir/.dart_tool 크기: $SIZE"
    fi
    if [ -d "$dir/build" ]; then
        SIZE=$(du -sh "$dir/build" 2>/dev/null | cut -f1)
        log_info "$dir/build 크기: $SIZE"
    fi
done

echo ""

# 1. melos clean 실행
log_melos "melos clean을 실행합니다..."
melos clean

# 2. 추가 정리 (melos clean으로 정리되지 않는 파일들)
log_info "추가 정리를 수행합니다..."

# .dart_tool 디렉토리들 정리
for dir in . g_common g_core g_lib g_model g_plugin; do
    if [ -d "$dir/.dart_tool" ]; then
        log_info "$dir/.dart_tool 삭제 중..."
        rm -rf "$dir/.dart_tool"
        log_success "$dir/.dart_tool 삭제 완료"
    fi
done

# build 디렉토리들 정리
for dir in . g_common g_core g_lib g_model g_plugin; do
    if [ -d "$dir/build" ]; then
        log_info "$dir/build 삭제 중..."
        rm -rf "$dir/build"
        log_success "$dir/build 삭제 완료"
    fi
done

# 3. pubspec.lock 파일들 정리 (선택사항)
if [ "$1" = "--clean-lock" ]; then
    log_warning "pubspec.lock 파일들도 삭제합니다..."
    
    for dir in . g_common g_core g_lib g_model g_plugin; do
        if [ -f "$dir/pubspec.lock" ]; then
            rm "$dir/pubspec.lock"
            log_success "$dir/pubspec.lock 삭제 완료"
        fi
    done
fi

# 4. Flutter 관련 캐시 정리
log_info "Flutter 캐시를 정리합니다..."

# Flutter pub cache 정리
if command -v flutter &> /dev/null; then
    log_info "Flutter pub cache 정리 중..."
    flutter pub cache clean
    log_success "Flutter pub cache 정리 완료"
fi

# 5. 정리 후 상태 확인
log_info "정리 완료! 다음 명령어로 의존성을 다시 가져올 수 있습니다:"
echo ""
echo "  # 전체 프로젝트 의존성 가져오기 (권장)"
echo "  melos bootstrap"
echo ""
echo "  # 또는 개별 패키지 의존성 가져오기"
echo "  melos exec -- dart pub get"
echo ""
echo "  # Flutter 프로젝트의 경우"
echo "  melos exec -- flutter pub get"
echo ""

# 6. 정리 후 용량 확인
log_info "정리 후 상태 확인 중..."
REMAINING_FILES=0

for dir in . g_common g_core g_lib g_model g_plugin; do
    if [ -d "$dir/.dart_tool" ]; then
        log_warning "$dir/.dart_tool이 여전히 존재합니다"
        REMAINING_FILES=$((REMAINING_FILES + 1))
    fi
    if [ -d "$dir/build" ]; then
        log_warning "$dir/build가 여전히 존재합니다"
        REMAINING_FILES=$((REMAINING_FILES + 1))
    fi
done

if [ $REMAINING_FILES -eq 0 ]; then
    log_success "모든 캐시 파일이 성공적으로 정리되었습니다!"
else
    log_warning "$REMAINING_FILES개의 파일/디렉토리가 남아있습니다."
fi

echo ""
log_success "정리 작업이 완료되었습니다!" 