#!/bin/bash

# 도움말
function show_help() {
    echo "Usage: ./run.sh [spec] [problem_file] [argument]"
    echo ""
    echo "Example:"
    echo "  ./run.sh spec_0 problems/cap_set_spec.py 8"
    echo ""
}

# 인자 확인
if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
    show_help
    exit 0
fi

SPEC="${1:-no-spec}"
PROBLEM_FILE="${2:-problems/cap_set_spec.py}"
ARGUMENT="${3:-8}"

# 프리셋 로드
if [ -f "specs/${SPEC}.sh" ]; then
    echo "Loading spec: ${SPEC}"
    source "specs/${SPEC}.sh"
else
    echo "Warning: Specification '${SPEC}' not found, using default values"
fi

# 환경 변수 파일이 있으면 로드 (덮어쓰기)
# if [ -f ".env.experiment" ]; then
#    source .env.experiment
# fi

# run_experiment.sh 실행
./run_experiment.sh "${PROBLEM_FILE}" ${ARGUMENT}
