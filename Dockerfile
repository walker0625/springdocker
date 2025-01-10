FROM openjdk:17-jdk

# image 생성 과정에 동작하는 명령어
# RUN apt update && apt install -y git

# 파일들의 root 경로이자, exec 접속시 지정되는 기본 경로
WORKDIR /springdocker

# COPY A B : host 컴퓨터(프로젝트 내)의 A 경로의 파일을, container root 경로(WORKDIR)에 B라는 이름으로 복사
# COPY /build/libs/*SNAPSHOT.jar /app.jar로 작성하면 절대 경로로 인식하므로 주의
# 아래와 같이 작성하면 상대 경로로 인식되며 기준은 Dockerfile이 위치한 디렉토리
COPY build/libs/*SNAPSHOT.jar app.jar

# container에서 첫 실행되는 명령어
ENTRYPOINT ["java", "-jar", "app.jar"]

# 해당 컨테이너가 어느 포트로 작동하는지 적어주는 일종의 문서(외부 포트는 실행시 따로 -p 8080:8080 같이 적어줘야 함)
EXPOSE 8080

# Volume 관련(mysql) : host의 저장 공간을 컨테이너에 공유하는 것이 목적(container와 data를 독립적으로 유지)
# 1. 처음 설정한 비밀번호(1234)도 지워지지 않음
# 2. host 절대경로 디렉토리에 파일이 이미 존재하면 컨테이너에 덮어 씌워버림(컨테이너 데이터가 호스트로 복사되지 못함)
# docker run -d -p 8080:8080 -e MYSQL_ROOT_PASSWORD=1234 -v /host의 절대경로 디렉토리:/var/lib/mysql mysql


# ECR 관련(IAM/KEY/ECR/Auth/Build/Run/Compose는 따로 참고) - CICD 부분은 추가 필요

# 1. ec2(ubuntu)에 Docker, Docker Compose 설치(version마다 command 다를 수 있으므로 주의)

# sudo apt-get update && \
# sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common && \
# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - && \
# sudo apt-key fingerprint 0EBFCD88 && \
# sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \
# sudo apt-get update && \
# sudo apt-get install -y docker-ce && \
# sudo usermod -aG docker ubuntu && \
# newgrp docker && \
# sudo curl -L "https://github.com/docker/compose/releases/download/2.27.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
# sudo chmod +x /usr/local/bin/docker-compose && \
# sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# docker -v # Docker 버전 확인
# docker compose version # Docker Compose 버전 확인


# 2. local에 awscli 설치

# brew install awscli
# aws --version # 설치 버전 확인


# 3. ec2에 awscli 설치

# sudo apt install unzip
# curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
# unzip awscliv2.zip
# sudo ./aws/install
# aws --version # 잘 출력된다면 정상 설치된 상태