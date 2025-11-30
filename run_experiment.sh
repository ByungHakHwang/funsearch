#!/bin/bash

# FunSearch 실행 스크립트
# 사용법: ./run_experiment.sh [problem_file] [arguement]

# 기본 설정값
PROBLEM_FILE="${1:-problems/cap_set_spec.py}"
ARGUMENT="${2:-8}"
MODEL="${MODEL:-gpt-4o-mini}"
SAMPLERS="${SAMPLERS:-2}"
EVALUATORS="${EVALUATORS:-7}"
ISLANDS="${ISLANDS:-4}"
DURATION="${DURATION:-60}"
RESET="${RESET:-25}"
ITERATIONS="${ITERATIONS:--1}"
SANDBOX="${SANDBOX:-ExternalProcessSandbox}"
TEMPERATURE="${TEMPERATURE:-1.0}"
TOKEN_LIMIT="${TOKEN_LIMIT:-2000000}"
RELATIVE_COST="${RELATIVE_COST:-1.0}"
OUTPUT_PATH="${OUTPUT_PATH:-./data}"

# 실행 정보 출력
echo "================================================"
echo "       FunSearch Experiment Configuration      "
echo "================================================"
echo "Problem File:    ${PROBLEM_FILE}"
echo "Argument:        ${ARGUMENT}"
echo "Model:           ${MODEL}"
echo "Samplers:        ${SAMPLERS}"
echo "Evaluators:      ${EVALUATORS}"
echo "Islands:         ${ISLANDS}"
echo "Duration:        ${DURATION}s"
echo "Reset Interval:  ${RESET}s"
echo "Iterations:      ${ITERATIONS}"
echo "Sandbox:         ${SANDBOX}"
echo "Temperature:     ${TEMPERATURE}"
echo "Token Limit:     ${TOKEN_LIMIT}"
echo "Relative Cost:   ${RELATIVE_COST}"
echo "Output Path:     ${OUTPUT_PATH}"
echo "================================================"
echo ""

# 출력 디렉토리 확인 및 생성
if [ ! -d "${OUTPUT_PATH}" ]; then
    echo "Creating output directory: ${OUTPUT_PATH}"
    mkdir -p "${OUTPUT_PATH}"
fi

# Spec 파일 존재 확인
if [ ! -f "${PROBLEM_FILE}" ]; then
    echo "Error: Problem file not found: ${PROBLEM_FILE}"
    exit 1
fi

# 시작 시간 기록
START_TIME=$(date '+%Y-%m-%d %H:%M:%S')
echo "Starting experiment at: ${START_TIME}"
echo ""

# FunSearch 실행
funsearch runasync "${PROBLEM_FILE}" ${ARGUMENT} \
  --model "${MODEL}" \
  --samplers ${SAMPLERS} \
  --evaluators ${EVALUATORS} \
  --islands ${ISLANDS} \
  --duration ${DURATION} \
  --reset ${RESET} \
  --iterations ${ITERATIONS} \
  --sandbox "${SANDBOX}" \
  --temperature ${TEMPERATURE} \
  --token_limit ${TOKEN_LIMIT} \
  --relative_cost_of_input_tokens ${RELATIVE_COST} \
  --output_path "${OUTPUT_PATH}"

# 종료 코드 확인
EXIT_CODE=$?

# 종료 시간 기록
END_TIME=$(date '+%Y-%m-%d %H:%M:%S')
echo ""
echo "=========================================="
echo "Experiment completed at: ${END_TIME}"
echo "Exit code: ${EXIT_CODE}"
echo "=========================================="

exit ${EXIT_CODE}
