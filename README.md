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

Right now **testlib** would be the only SPJ library available but we are planning to support more SPJ libraries in the future.

### SPJ Checker Languages

NOJ JudgeServer provides SPJ support for `C` language only prior to `v0.3.0`.

Starting from NOJ `v0.18.0` and NOJ JudgeServer `v0.3.0`, NOJ JudgeServer provides additional support for `C++` and `PHP`.

|Language|Compiler|Additional SPJ Libraries|
|--------|--------|------------------------|
|C|gcc (C99)|-|
|C++|g++ (C++11)|testlib|
|PHP|php (7.3-cli)|-|

### Migration from version prior to v0.3.0

Older versions of NOJ JudgeServer SPJs are feeded with testcase input and user output only. While in latest version of `v0.3.0`, It becomes testcase input, testcase output and user output. The changes not only grants testcase output access to SPJs, but also alters the given order. Thus all legacy version of SPJ need to:

1. Alter accepted `argc` to 4 and accepts testcase input as first, testcase output as second and user output as third;
2. Re-bundle testcases archive file to include .out files, then use NOJ v0.18.0 Admin Portal to re-upload the testcases, the `.out` files, if not needed, can be blank or simply the same as input.

### SPJ sample code

#### SPJ Cheatsheet

Here lists all valid exit code for SPJ:

|Verdict|Exit Codes|
|--------|--------|
|Accepted|0|
|Wrong Answer|1, 2, 4, 8|
|System Error|3, 7, 255|

All unlisted exit codes would be viewed as **System Error**.

> Since Linux only accepts last 8 bits of exit code, you can practically use `-1` for **System Error** for it actually converts to `255`. You can also use `-255` (`1`) for **Wrong Answer** or `-253` (`3`) for **System Error**, etc.

For C++ with testlib support, you can use testlib `quitf` function and macro defined `_wa`, `_ok` and so on without any conversion except `Points` and `Partically Accepted` status. NOJ Judge Server would recognize them properly and auto-convert them to NOJ JudgeServer standard.

|NOJ Verdict|Testlib Verdict|
|--------|--------|
|Accepted|`_ok`|
|Wrong Answer|`_wa`, `_pe`, `_dirt`, `_unexpected_eof`|
|System Error|`_fail`, `_points`, `_partically`, `_pc`|

For `Points` and `Partically Accepted` status, NOJ would verdict them all **System Error** no matter what score this SPJ actually nailed. For NOJ does not support single testcase with divided score.

> We may support single-testcase-wide partically accepted status in the future.

#### Clang without any libraries

Here is a simple SPJ checker written in `Clang`, this checker checks if the integer user outputs equals the given testcase:

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

#### C++ with testlib support

Here is a simple SPJ checker written in `C++` with testlib support, this checker checks if the integer user outputs equals the given testcase:

```cpp
#include <testlib>

int main(int argc, char * argv[]) {
    setName("compares two signed integers");
    registerTestlibCmd(argc, argv);
    int ja = ans.readInt();
    int pa = ouf.readInt();
    if (ja != pa) quitf(_wa, "expected %d, found %d", ja, pa);
    quitf(_ok, "answer is %d", ja);
}
``` 

#### PHP SPJ Support

NOJ JudgeServer Provides exclusive `php` language SPJ supports for contest arrangers to be benefited from this dynamic, weakly typed and *artistic* language, this checker checks if the integer user outputs equals the given testcase:

```php
<?php

class Judge
{
    private const ACCEPTED = 0;
    private const WRONG_ANSWER = 1;
    private const SYSTEM_ERROR = -1;

    private $input = false;
    private $output = false;
    private $user_output = false;

    private $verdict = null;

    private function settleVerdict(int $ret = 0): void
    {
        if ($this->input !== false) {
            fclose($this->input);
        }
        if ($this->output !== false) {
            fclose($this->output);
        }
        if ($this->user_output !== false) {
            fclose($this->user_output);
        }
        $this->verdict = $ret;
    }

    public function __construct($argc, $argv)
    {
        if ($argc != 4) {
            printf("Usage: php {$argv[0]} x.in x.out x.ans\n");
            $this->settleVerdict(Judge::SYSTEM_ERROR);
            return;
        }

        $this->input = fopen($argv[1], "r");
        $this->output = fopen($argv[2], "r");
        $this->user_output = fopen($argv[3], "r");

        if ($this->input === false || $this->output === false || $this->user_output === false) {
            printf("Failed to open output file\n");
            $this->settleVerdict(Judge::SYSTEM_ERROR);
            return;
        }
    }

    public static function register($argc, $argv): Judge
    {
        return new Judge($argc, $argv);
    }

    private function judge(): int
    {
        fscanf($this->output, "%d", $b);
        if (fscanf($this->user_output, "%d", $a) !== false) {
            if ($a == $b) {
                return Judge::ACCEPTED;
            }
        }
        return Judge::WRONG_ANSWER;
    }

    public function getVerdict(): int
    {
        return $this->verdict ?? $this->judge();
    }
}

exit(Judge::register($argc, $argv)->getVerdict());
```