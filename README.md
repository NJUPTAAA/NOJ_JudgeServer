# NOJ JudgeServer
![NOJ JudgeServer](noj_banner.png)

![Travis (.org)](https://img.shields.io/travis/NJUPTAAA/NOJ_JudgeServer.svg?style=flat-square)

JudgeServer for NOJ, inspired by QDUOJ.

## Compiled Images

This package is available on [Docker Hub](https://hub.docker.com/repository/docker/njuptaaa/judge_server) and [Github Container Registry](https://github.com/orgs/NJUPTAAA/packages/container/package/judge_server).

You can download from *Docker Hub*:

```bash
docker pull njuptaaa/judge_server
```

Since `v0.3.0` all version are pre-released on *Github Container Registry* then upload to Docker Hub later, thus you can download latest version from GHCR:

```bash
docker pull ghcr.io/njuptaaa/judge_server
```

You might want to specify a certain version of JudgeServer, for example, if you are using NOJ `v0.18.0`, you need at least JudgeServer `v0.3.0` for SPJ supporting libraries to function properly:

```bash
docker pull njuptaaa/judge_server:v0.3.0
```

You can download latest experimental build by using `master` tag, they are latest for sure, but may contain developing features that your NOJ version does not currently support:

```bash
docker pull njuptaaa/judge_server:master
```

### Compile Yourself

You can compile NOJ JudgeServer yourself.

```bash
docker build . -t njuptaaa/judge_server
```

If you are using networks that have limited internet access, you can try using proxy to build. In the following example we using a proxy located on port 1080 of youe computer:

```bash
docker build . -t njuptaaa/judge_server --build-arg http_proxy=http://host.docker.internal:1080 --build-arg https_proxy=http://host.docker.internal:1080
```

If you are a resident of Chinese mainland, try using `Dockerfile.cn`, it is pre-configured to use some mirroring service:

```bash
docker build . -f Dockerfile.cn -t njuptaaa/judge_server
```

## Babel Extension NOJ

NOJ JudgeServer is driven by Babel Extension NOJ, see [Babel Extension NOJ](https://github.com/ZsgsDesign/NOJ/tree/master/app/Babel/Extension/noj) and [NOJ BABEL Github Public Mirror](https://njuptaaa.github.io/babel/) for more information.

## All Supported Languages and Examples

|Language|Compile/Run Command|
|--------|-------------------|
|C|/usr/bin/gcc -DONLINE_JUDGE -O2 -w -fmax-errors=3 -std=c99 {src_path} -lm -o {exe_path}|
|C++|/usr/bin/g++ -DONLINE_JUDGE -O2 -w -fmax-errors=3 -std=c++11 {src_path} -lm -o {exe_path}|
|Java|/usr/bin/javac {src_path} -d {exe_dir} -encoding UTF8<br>/usr/bin/java -cp {exe_dir} -XX:MaxRAM={max_memory}k -Djava.security.manager -Dfile.encoding=UTF-8 -Djava.security.policy==/etc/java_policy -Djava.awt.headless=true Main|
|Python2|/usr/bin/python -m py_compile {src_path}<br>/usr/bin/python {exe_path}|
|Python3|/usr/bin/python3.7 -m py_compile {src_path}<br>/usr/bin/python3.7 {exe_path}|
|PHP7|/usr/bin/php {exe_path}|
|Javascript|/usr/bin/jsc {exe_path}|
|Go|/usr/bin/go build -o {exe_path} {src_path}|
|C#|/usr/bin/mcs -optimize+ -out:{exe_path} {src_path}|
|Ruby|/usr/bin/ruby {exe_path}|
|Rust|/usr/bin/rustc -O -o {exe_path} {src_path}|
|Haskell|/usr/bin/ghc -O -outputdir /tmp -o {exe_path} {src_path}|
|Free Pascal|/usr/bin/fpc -O2 -o{exe_path} {src_path}|
|Plaintext|/bin/cat {exe_path}|
|Free Basic|/usr/local/bin/fbc {src_path}|

> Besides, `C++14`, `C++17` and `C11` are also supported, they are standards thus would not be listed from above.

## Special Judge Support

### SPJ Libraries

Starting from NOJ `v0.18.0` and NOJ JudgeServer `v0.3.0`, NOJ JudgeServer provides a SPJ library called **nojlib**, it contains some useful constants and definitions. 

Also starting from NOJ `v0.18.0` and NOJ JudgeServer `v0.3.0`, **testlib** would be bundled as a optional SPJ library of `C++`.

Right now **nojlib** and **testlib** would be the only two SPJ libraries but we are planning to support more SPJ libraries in the future.

### SPJ Languages

NOJ JudgeServer provides SPJ support for `C` only prior to `v0.3.0`.

Starting from NOJ `v0.18.0` and NOJ JudgeServer `v0.3.0`, NOJ JudgeServer provides support for `C++`, `Java` and `Python3`.

|Language|Additional SPJ Libraries|
|--------|-------------------|
|C|nojlib|
|C++|nojlib, testlib|
|Java|nojlib|
|Python3|nojlib|

### SPJ sample code

```cpp
#include <cstdio>

#define AC 0
#define WA 1
#define ERROR -1

int spj(FILE *input, FILE *user_output);

void close_file(FILE *f){
    if(f != NULL){
        fclose(f);
    }
}

int main(int argc, char *args[]){
    FILE *input = NULL, *user_output = NULL;
    int result;
    if(argc != 3){
        printf("Usage: spj x.in x.out\n");
        return ERROR;
    }
    input = fopen(args[1], "r");
    user_output = fopen(args[2], "r");
    if(input == NULL || user_output == NULL){
        printf("Failed to open output file\n");
        close_file(input);
        close_file(user_output);
        return ERROR;
    }

    result = spj(input, user_output);
    printf("result: %d\n", result);
    
    close_file(input);
    close_file(user_output);
    return result;
}

int spj(FILE *input, FILE *user_output){
    int a, b;
    fscanf(input, "%d", &b);
    if(~fscanf(user_output, "%d", &a)) {
        if(a == b){
            return AC;
        }
    }
    return WA;
}
```