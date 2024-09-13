# Ubuntu 베이스 이미지
FROM ubuntu:20.04

# Azure CLI 설치
RUN apt-get update && \
    apt-get install -y curl apt-transport-https lsb-release gnupg && \
    curl -sL https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    AZ_REPO=$(lsb_release -cs) && \
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | tee /etc/apt/sources.list.d/azure-cli.list && \
    apt-get update && \
    apt-get install -y azure-cli jq && \
    rm -rf /var/lib/apt/lists/*

# 기본 작업 디렉토리 설정
WORKDIR /workspace

# kubectl install
RUN az aks install-cli

# az cli 로그인
# 환경 변수를 사용하여 로그인 정보 설정
ARG AZ_USERNAME
ARG AZ_PASSWORD
ARG AZ_TENANT

# Azure 로그인 실행
RUN az login --service-principal --username $AZ_USERNAME --password $AZ_PASSWORD --tenant $AZ_TENANT


# kube-config 받아옴
RUN az aks get-credentials --resource-group ned-test --name ned-cluster

# 컨테이너 시작 시 bash 실행
CMD ["/bin/bash"]
