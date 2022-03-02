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

Starting from NOJ `v0.18.0` and NOJ JudgeServer `v0.3.0`, NOJ JudgeServer provides a SPJ library called **testlib**, it contains some useful constants and definitions and it would be bundled as a optional SPJ library of `C++`.

Right now **testlib** would be the only two SPJ libraries but we are planning to support more SPJ libraries in the future.

### SPJ Checker Languages

NOJ JudgeServer provides SPJ support for `C` only prior to `v0.3.0`.

Starting from NOJ `v0.18.0` and NOJ JudgeServer `v0.3.0`, NOJ JudgeServer provides support for `C++`, `PHP` and `Python3`.

|Language|Compiler|Additional SPJ Libraries|
|--------|--------|------------------------|
|C|gcc (C99)|-|
|C++|g++ (C++11)|testlib|
|PHP|php (7.3-cli)|-|
|Python3|python3.7|testlib|

### SPJ sample code

#### Clang without any libraries

Here is a simple SPJ checker written in `Clang`, this checker checks if the user output equals the given testcase:

```cpp
#include <stdio.h>

#define AC 0
#define WA 1
#define ERROR -1

int spj(FILE *input, FILE *output, FILE *user_output);

void close_file(FILE *f){
    if(f != NULL){
        fclose(f);
    }
}

int main(int argc, char *args[]){
    FILE *input = NULL, *output = NULL, *user_output = NULL;
    int result;
    if(argc != 4){
        printf("Usage: spj x.in x.out x.ans\n");
        return ERROR;
    }
    input = fopen(args[1], "r");
    output = fopen(args[2], "r");
    user_output = fopen(args[3], "r");
    if(input == NULL || output == NULL || user_output == NULL){
        printf("Failed to open output file\n");
        close_file(input);
        close_file(output);
        close_file(user_output);
        return ERROR;
    }

    result = spj(input, output, user_output);
    printf("result: %d\n", result);
    
    close_file(input);
    close_file(output);
    close_file(user_output);
    return result;
}

int spj(FILE *input, FILE *output, FILE *user_output){
    int a, b;
    fscanf(output, "%d", &b);
    if(~fscanf(user_output, "%d", &a)) {
        if(a == b){
            return AC;
        }
    }
    return WA;
}
```

Input: **3**  
Output: **3**  
Verdict: **Accepted**  

Input: **3**  
Output: **4**  
Verdict: **Wrong Answer**  

#### C++ with testlib support

Here is a simple SPJ checker written in `C++` with testlib support, this checker checks if the user output equals the square root of the given testcase, with a tolerance scope of 1:

```cpp
#include <testlib>
#include <stdio.h>

#define AC 0
#define WA 1
#define ERROR -1

int spj(FILE *input, FILE *output, FILE *user_output);

void close_file(FILE *f){
    if(f != NULL){
        fclose(f);
    }
}

int main(int argc, char *args[]){
    FILE *input = NULL, *output = NULL, *user_output = NULL;
    int result;
    if(argc != 4){
        printf("Usage: spj x.in x.out x.ans\n");
        return ERROR;
    }
    input = fopen(args[1], "r");
    output = fopen(args[2], "r");
    user_output = fopen(args[3], "r");
    if(input == NULL || output == NULL || user_output == NULL){
        printf("Failed to open output file\n");
        close_file(input);
        close_file(output);
        close_file(user_output);
        return ERROR;
    }

    result = spj(input, output, user_output);
    printf("result: %d\n", result);
    
    close_file(input);
    close_file(output);
    close_file(user_output);
    return result;
}

int spj(FILE *input, FILE *output, FILE *user_output){
    int a, b;
    fscanf(output, "%d", &b);
    if(~fscanf(user_output, "%d", &a)) {
        if(a == b){
            return AC;
        }
    }
    return WA;
}
```

Input: **3**  
Output: **1.732050**  
Verdict: **Accepted**  

Input: **3**  
Output: **1.732051**  
Verdict: **Accepted**  

Input: **3**  
Output: **1.732059**  
Verdict: **Accepted**  

Input: **3**  
Output: **1.732089**  
Verdict: **Wrong Answer**  

#### PHP SPJ Support

NOJ JudgeServer Provides exclusive PHP SPJ supports for contest arrangers to be benefited from this dynamic, weakly typed and *artistic* language.

```php
<?php
    const ACCEPTED = 0;
    const WRONG_ANSWER = 1;
    const SYSTEM_ERROR = -1;

    if($argc != 4){
        printf("Usage: php {$argv[0]} x.in x.out x.ans\n");
        exit(SYSTEM_ERROR);
    }

    $input = fopen($argv[1], "r");
    $output = fopen($argv[2], "r");
    $user_output = fopen($argv[3], "r");

    if($input === false || $output === false || $user_output === false){
        printf("Failed to open output file\n");
        exit(SYSTEM_ERROR);
    }

    fscanf($output, "%d", $b);
    if(fscanf($user_output, "%d", $a) !== false) {
        if($a == $b){
            exit(ACCEPTED);
        }
    }

    exit(WRONG_ANSWER);
```