FROM docker.io/python:3.11.6

# 빌드 시점 인자 (기본값 설정)
ARG USER_ID=1000
ARG GROUP_ID=1000
ARG USERNAME=appuser

# 임시 작업 디렉토리에서 설치 작업 수행
WORKDIR /tmp/build

# Copy build and dependency files first for better layer caching
COPY pyproject.toml README.md ./
COPY requirements*.txt ./

# Install dependencies using pip (UV 옵션 제거)
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

# Copy application code
COPY examples ./examples
COPY funsearch ./funsearch

# Install the application
RUN pip install --no-deps . && \
    rm -rf ./funsearch ./build

# 그룹 및 사용자 생성 (이미 존재하는 GID/UID 처리)
RUN if getent group ${GROUP_ID} >/dev/null 2>&1; then \
        groupmod -n ${USERNAME} $(getent group ${GROUP_ID} | cut -d: -f1); \
    else \
        groupadd -g ${GROUP_ID} ${USERNAME}; \
    fi && \
    useradd -l -u ${USER_ID} -g ${GROUP_ID} -s /bin/bash -m ${USERNAME}

# 사용자 홈 디렉토리로 작업 공간 설정
WORKDIR /home/${USERNAME}/workspace

# 필요한 디렉토리 구조 생성 및 권한 설정
RUN mkdir -p data/scores data/graphs data/backups examples && \
    chown -R ${USER_ID}:${GROUP_ID} /home/${USERNAME}

# 임시 빌드 디렉토리 정리
RUN rm -rf /tmp/build

# 사용자 전환
USER ${USER_ID}:${GROUP_ID}

CMD ["bash"]

