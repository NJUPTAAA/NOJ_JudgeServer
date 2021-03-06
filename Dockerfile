FROM ubuntu:18.04

COPY build/java_policy /etc

RUN buildDeps='software-properties-common git libtool cmake python-dev python3-pip python-pip libseccomp-dev wget ncurses-dev' && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y \
        python \
        python3.7 \
        python-pkg-resources \
        python3-pkg-resources \
        fp-compiler \
        rustc \
        haskell-platform \
        gcc \
        g++ \
        ruby \
        mono-runtime \
        mono-mcs \
        libjavascriptcoregtk-4.0-bin \
        apt-transport-https \
        lsb-release \
        ca-certificates \
        $buildDeps && \
    add-apt-repository ppa:openjdk-r/ppa && apt-get update && apt-get install -y openjdk-8-jdk && \
    add-apt-repository ppa:longsleep/golang-backports && apt-get update && apt-get install -y golang-go && \
    add-apt-repository ppa:ondrej/php && apt-get update && apt-get install -y php7.3-cli && \
    cd /tmp && wget -O FreeBASIC.tar.gz https://versaweb.dl.sourceforge.net/project/fbc/Binaries%20-%20Linux/ubuntu-18.04/FreeBASIC-1.07.2-ubuntu-18.04-x86_64.tar.gz && \
    tar zxvf FreeBASIC.tar.gz && rm -f FreeBASIC.tar.gz && cd /tmp/FreeBASIC-1.07.2-ubuntu-18.04-x86_64 && ./install.sh -i && cd /tmp && rm -rf /tmp/FreeBASIC-1.07.2-ubuntu-18.04-x86_64 && \
    pip3 install -I --no-cache-dir psutil gunicorn flask requests idna && \
    cd /tmp && git clone --depth 1 https://github.com/NJUPTAAA/NOJ_Judger Judger && cd Judger && \
    mkdir build && cd build && cmake .. && make && make install && cd ../bindings/Python && python3 setup.py install && \
    apt-get purge -y --auto-remove $buildDeps && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    mkdir -p /code && \
    useradd -u 12001 compiler && useradd -u 12002 code && useradd -u 12003 spj && usermod -a -G code spj

# HEALTHCHECK --interval=5s --retries=3 CMD python3 /code/service.py
ADD server /code
WORKDIR /code
RUN gcc -shared -fPIC -o unbuffer.so unbuffer.c
EXPOSE 8080
RUN chmod 744 /code/entrypoint.sh
ENTRYPOINT /code/entrypoint.sh
