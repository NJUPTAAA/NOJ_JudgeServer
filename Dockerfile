FROM ubuntu:18.04

COPY build/java_policy /etc

RUN buildDeps='software-properties-common git libtool cmake python-dev python3-pip python-pip libseccomp-dev' && \
    apt-get update && \
    apt-get install -y \
        python \
        python3.7 \
        python-pkg-resources \
        python3-pkg-resources \
        gcc \
        g++ \
        libjavascriptcoregtk-4.0-bin \
        golang \
        apt-transport-https \
        lsb-release \
        ca-certificates \
        $buildDeps && \
    export DEBIAN_FRONTEND=noninteractive && \
    add-apt-repository ppa:openjdk-r/ppa && apt-get update && apt-get install -y openjdk-8-jdk && \
    add-apt-repository ppa:ondrej/php && apt-get update && apt-get install -y php7.3-cli && \
    pip3 install --no-cache-dir psutil gunicorn flask requests && \
    cd /tmp && git clone --depth 1 https://github.com/NJUPTAAA/NOJ_Judger Judger && cd Judger && \
    mkdir build && cd build && cmake .. && make && make install && cd ../bindings/Python && python3 setup.py install && \
    apt-get purge -y --auto-remove $buildDeps && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    mkdir -p /code && \
    useradd -u 12001 compiler && useradd -u 12002 code && useradd -u 12003 spj && usermod -a -G code spj

HEALTHCHECK --interval=5s --retries=3 CMD python3 /code/service.py
ADD server /code
WORKDIR /code
RUN gcc -shared -fPIC -o unbuffer.so unbuffer.c
EXPOSE 8080
RUN chmod 744 /code/entrypoint.sh
ENTRYPOINT /code/entrypoint.sh
